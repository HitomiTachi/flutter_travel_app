import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final String? userCountry;
  final String targetId; // ID của location/hotel/destination được review
  final String targetType; // 'location', 'hotel', 'destination'
  final String targetName;
  final double rating; // 1.0 - 5.0
  final String title; // Tiêu đề review
  final String comment;
  final List<String> imageUrls;
  final List<String> tags; // Tags như 'Tuyệt vời', 'Đáng tiền', etc
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int helpfulYes; // Số lượt helpful
  final int helpfulNo; // Số lượt not helpful
  final List<String> helpfulUserIds; // Users đã like review này
  final bool isEdited;
  final bool isRecommended; // Có recommend địa điểm này không
  final String tripType; // 'couple', 'family', 'friends', 'solo'
  final bool isVerified; // Đã xác thực đã đến chưa

  ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    this.userCountry,
    required this.targetId,
    required this.targetType,
    required this.targetName,
    required this.rating,
    this.title = '',
    required this.comment,
    this.imageUrls = const [],
    this.tags = const [],
    required this.createdAt,
    this.updatedAt,
    this.helpfulYes = 0,
    this.helpfulNo = 0,
    this.helpfulUserIds = const [],
    this.isEdited = false,
    this.isRecommended = true,
    this.tripType = 'solo',
    this.isVerified = false,
  });

  // Factory constructor từ Firestore
  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userAvatarUrl: data['userAvatarUrl'],
      userCountry: data['userCountry'],
      targetId: data['targetId'] ?? '',
      targetType: data['targetType'] ?? 'location',
      targetName: data['targetName'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      title: data['title'] ?? '',
      comment: data['comment'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      tags: List<String>.from(data['tags'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      helpfulYes: data['helpfulYes'] ?? 0,
      helpfulNo: data['helpfulNo'] ?? 0,
      helpfulUserIds: List<String>.from(data['helpfulUserIds'] ?? []),
      isEdited: data['isEdited'] ?? false,
      isRecommended: data['isRecommended'] ?? true,
      tripType: data['tripType'] ?? 'solo',
      isVerified: data['isVerified'] ?? false,
    );
  }

  // Chuyển đổi sang Map để lưu Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'userCountry': userCountry,
      'targetId': targetId,
      'targetType': targetType,
      'targetName': targetName,
      'rating': rating,
      'title': title,
      'comment': comment,
      'imageUrls': imageUrls,
      'tags': tags,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'helpfulYes': helpfulYes,
      'helpfulNo': helpfulNo,
      'helpfulUserIds': helpfulUserIds,
      'isEdited': isEdited,
      'isRecommended': isRecommended,
      'tripType': tripType,
      'isVerified': isVerified,
    };
  }

  // Copy with
  ReviewModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatarUrl,
    String? userCountry,
    String? targetId,
    String? targetType,
    String? targetName,
    double? rating,
    String? title,
    String? comment,
    List<String>? imageUrls,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? helpfulYes,
    int? helpfulNo,
    List<String>? helpfulUserIds,
    bool? isEdited,
    bool? isRecommended,
    String? tripType,
    bool? isVerified,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      userCountry: userCountry ?? this.userCountry,
      targetId: targetId ?? this.targetId,
      targetType: targetType ?? this.targetType,
      targetName: targetName ?? this.targetName,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      comment: comment ?? this.comment,
      imageUrls: imageUrls ?? this.imageUrls,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      helpfulYes: helpfulYes ?? this.helpfulYes,
      helpfulNo: helpfulNo ?? this.helpfulNo,
      helpfulUserIds: helpfulUserIds ?? this.helpfulUserIds,
      isEdited: isEdited ?? this.isEdited,
      isRecommended: isRecommended ?? this.isRecommended,
      tripType: tripType ?? this.tripType,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  // Helper getters
  String get tripTypeLabel {
    switch (tripType) {
      case 'couple':
        return 'Cặp đôi';
      case 'family':
        return 'Gia đình';
      case 'friends':
        return 'Bạn bè';
      case 'solo':
        return 'Một mình';
      default:
        return 'Khác';
    }
  }

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays < 1) {
      if (difference.inHours < 1) {
        return '${difference.inMinutes} phút trước';
      }
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} tháng trước';
    } else {
      return '${(difference.inDays / 365).floor()} năm trước';
    }
  }

  int get totalHelpful => helpfulYes + helpfulNo;

  double get helpfulPercentage {
    if (totalHelpful == 0) return 0.0;
    return (helpfulYes / totalHelpful) * 100;
  }
}

/// Enum cho loại chuyến đi
enum TripType {
  all,
  couple,
  family,
  friends,
  solo,
}

extension TripTypeExtension on TripType {
  String get label {
    switch (this) {
      case TripType.all:
        return 'Tất cả';
      case TripType.couple:
        return 'Cặp đôi';
      case TripType.family:
        return 'Gia đình';
      case TripType.friends:
        return 'Bạn bè';
      case TripType.solo:
        return 'Một mình';
    }
  }

  String get value {
    switch (this) {
      case TripType.all:
        return 'all';
      case TripType.couple:
        return 'couple';
      case TripType.family:
        return 'family';
      case TripType.friends:
        return 'friends';
      case TripType.solo:
        return 'solo';
    }
  }
}

/// Enum cho sắp xếp review
enum ReviewSortType {
  newest,
  oldest,
  highestRating,
  lowestRating,
  mostHelpful,
}

extension ReviewSortTypeExtension on ReviewSortType {
  String get label {
    switch (this) {
      case ReviewSortType.newest:
        return 'Mới nhất';
      case ReviewSortType.oldest:
        return 'Cũ nhất';
      case ReviewSortType.highestRating:
        return 'Đánh giá cao';
      case ReviewSortType.lowestRating:
        return 'Đánh giá thấp';
      case ReviewSortType.mostHelpful:
        return 'Hữu ích nhất';
    }
  }
}
