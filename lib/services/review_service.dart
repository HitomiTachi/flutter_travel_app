import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/models/review_model.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream reviews cho một target (location/hotel)
  Stream<List<ReviewModel>> getReviewsStream({
    required String targetId,
    String? targetType,
    int limit = 50,
  }) {
    Query query = _firestore
        .collection('reviews')
        .where('targetId', isEqualTo: targetId);

    if (targetType != null) {
      query = query.where('targetType', isEqualTo: targetType);
    }

    return query
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ReviewModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Lấy reviews (không stream)
  Future<List<ReviewModel>> getReviews({
    required String targetId,
    String? targetType,
    int limit = 50,
  }) async {
    Query query = _firestore
        .collection('reviews')
        .where('targetId', isEqualTo: targetId);

    if (targetType != null) {
      query = query.where('targetType', isEqualTo: targetType);
    }

    final snapshot = await query
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList();
  }

  // Tạo review mới
  Future<String> createReview({
    required String targetId,
    required String targetType,
    required String targetName,
    required double rating,
    required String comment,
    List<String> imageUrls = const [],
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Lấy thông tin user (hỗ trợ cả anonymous user)
    String userName = 'Người dùng';
    String? userAvatarUrl;

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        userName = userData?['name'] ?? user.displayName ?? 'Người dùng';
        userAvatarUrl = userData?['avatarUrl'];
      } else {
        // Anonymous user hoặc user chưa có trong Firestore
        userName = user.isAnonymous
            ? 'Khách'
            : (user.displayName ?? 'Người dùng');
        userAvatarUrl = null;
      }
    } catch (e) {
      // Fallback nếu có lỗi
      userName = user.isAnonymous
          ? 'Khách'
          : (user.displayName ?? 'Người dùng');
      userAvatarUrl = null;
    }

    final review = ReviewModel(
      id: '', // Sẽ được tạo tự động
      userId: user.uid,
      userName: userName,
      userAvatarUrl: userAvatarUrl,
      targetId: targetId,
      targetType: targetType,
      targetName: targetName,
      rating: rating,
      comment: comment,
      imageUrls: imageUrls,
      createdAt: DateTime.now(),
    );

    final docRef = await _firestore
        .collection('reviews')
        .add(review.toFirestore());

    // Cập nhật rating trung bình của target
    await _updateTargetRating(targetId, targetType);

    return docRef.id;
  }

  // Cập nhật review
  Future<void> updateReview({
    required String reviewId,
    double? rating,
    String? comment,
    List<String>? imageUrls,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final reviewDoc = await _firestore
        .collection('reviews')
        .doc(reviewId)
        .get();
    if (!reviewDoc.exists) throw Exception('Review not found');

    final review = ReviewModel.fromFirestore(reviewDoc);
    if (review.userId != user.uid) {
      throw Exception('Not authorized to update this review');
    }

    final updates = <String, dynamic>{
      'updatedAt': Timestamp.now(),
      'isEdited': true,
    };

    if (rating != null) updates['rating'] = rating;
    if (comment != null) updates['comment'] = comment;
    if (imageUrls != null) updates['imageUrls'] = imageUrls;

    await _firestore.collection('reviews').doc(reviewId).update(updates);

    // Cập nhật rating trung bình
    await _updateTargetRating(review.targetId, review.targetType);
  }

  // Xóa review
  Future<void> deleteReview(String reviewId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final reviewDoc = await _firestore
        .collection('reviews')
        .doc(reviewId)
        .get();
    if (!reviewDoc.exists) throw Exception('Review not found');

    final review = ReviewModel.fromFirestore(reviewDoc);
    if (review.userId != user.uid) {
      throw Exception('Not authorized to delete this review');
    }

    await _firestore.collection('reviews').doc(reviewId).delete();

    // Cập nhật rating trung bình
    await _updateTargetRating(review.targetId, review.targetType);
  }

  // Toggle helpful cho review (cho phép cả anonymous user)
  Future<void> toggleHelpful(String reviewId, bool isYes) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Vui lòng đăng nhập để đánh giá hữu ích');
    }

    final reviewDoc = await _firestore
        .collection('reviews')
        .doc(reviewId)
        .get();
    if (!reviewDoc.exists) throw Exception('Review not found');

    final review = ReviewModel.fromFirestore(reviewDoc);
    final helpfulUserIds = List<String>.from(review.helpfulUserIds);
    final wasHelpful = helpfulUserIds.contains(user.uid);

    int newHelpfulYes = review.helpfulYes;
    int newHelpfulNo = review.helpfulNo;

    if (wasHelpful) {
      helpfulUserIds.remove(user.uid);
      if (isYes) {
        newHelpfulYes--;
      } else {
        newHelpfulNo--;
      }
    } else {
      helpfulUserIds.add(user.uid);
      if (isYes) {
        newHelpfulYes++;
      } else {
        newHelpfulNo++;
      }
    }

    await _firestore.collection('reviews').doc(reviewId).update({
      'helpfulYes': newHelpfulYes,
      'helpfulNo': newHelpfulNo,
      'helpfulUserIds': helpfulUserIds,
    });
  }

  // Tính rating trung bình và cập nhật
  Future<void> _updateTargetRating(String targetId, String targetType) async {
    final reviews = await getReviews(
      targetId: targetId,
      targetType: targetType,
    );
    if (reviews.isEmpty) return;

    final totalRating = reviews.fold<double>(
      0.0,
      (sum, review) => sum + review.rating,
    );
    final averageRating = totalRating / reviews.length;

    // Cập nhật vào collection tương ứng
    final collection = targetType == 'hotel' ? 'hotels' : 'locations';
    await _firestore.collection(collection).doc(targetId).update({
      'rating': averageRating,
      'reviewCount': reviews.length,
    });
  }

  // Lấy rating trung bình
  Future<double> getAverageRating({
    required String targetId,
    String? targetType,
  }) async {
    final reviews = await getReviews(
      targetId: targetId,
      targetType: targetType,
    );
    if (reviews.isEmpty) return 0.0;

    final totalRating = reviews.fold<double>(
      0.0,
      (sum, review) => sum + review.rating,
    );
    return totalRating / reviews.length;
  }

  // Lọc reviews theo rating
  List<ReviewModel> filterByRating(List<ReviewModel> reviews, {required double minRating}) {
    return reviews.where((review) => review.rating >= minRating).toList();
  }

  // Lọc reviews theo trip type
  List<ReviewModel> filterByTripType(List<ReviewModel> reviews, {required String tripType}) {
    if (tripType == 'all') return reviews;
    return reviews.where((review) => review.tripType == tripType).toList();
  }

  // Lọc reviews đã verified
  List<ReviewModel> filterByVerified(List<ReviewModel> reviews, {required bool isVerified}) {
    return reviews.where((review) => review.isVerified == isVerified).toList();
  }

  // Sắp xếp reviews
  List<ReviewModel> sortReviews(List<ReviewModel> reviews, {required ReviewSortType sortType}) {
    final sortedReviews = List<ReviewModel>.from(reviews);
    
    switch (sortType) {
      case ReviewSortType.newest:
        sortedReviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case ReviewSortType.oldest:
        sortedReviews.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case ReviewSortType.highestRating:
        sortedReviews.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ReviewSortType.lowestRating:
        sortedReviews.sort((a, b) => a.rating.compareTo(b.rating));
        break;
      case ReviewSortType.mostHelpful:
        sortedReviews.sort((a, b) => b.helpfulYes.compareTo(a.helpfulYes));
        break;
    }
    
    return sortedReviews;
  }

  // Lấy % người recommend
  double getRecommendedPercentage(List<ReviewModel> reviews) {
    if (reviews.isEmpty) return 0.0;
    final recommended = reviews.where((review) => review.isRecommended).length;
    return (recommended / reviews.length) * 100;
  }

  // Lấy phân bố rating (1-5 sao)
  Map<int, int> getRatingDistribution(List<ReviewModel> reviews) {
    final distribution = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final review in reviews) {
      final stars = review.rating.round();
      distribution[stars] = (distribution[stars] ?? 0) + 1;
    }
    return distribution;
  }

  // Lấy phân bố theo trip type
  Map<String, int> getTripTypeDistribution(List<ReviewModel> reviews) {
    final distribution = <String, int>{};
    for (final review in reviews) {
      distribution[review.tripType] = (distribution[review.tripType] ?? 0) + 1;
    }
    return distribution;
  }
}
