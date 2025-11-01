import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final String targetId; // ID của location/hotel/destination được review
  final String targetType; // 'location', 'hotel', 'destination'
  final String targetName;
  final double rating; // 1.0 - 5.0
  final String comment;
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int helpfulCount;
  final List<String> helpfulUserIds; // Users đã like review này
  final bool isEdited;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.targetId,
    required this.targetType,
    required this.targetName,
    required this.rating,
    required this.comment,
    this.imageUrls = const [],
    required this.createdAt,
    this.updatedAt,
    this.helpfulCount = 0,
    this.helpfulUserIds = const [],
    this.isEdited = false,
  });

  // Factory constructor từ Firestore
  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userAvatarUrl: data['userAvatarUrl'],
      targetId: data['targetId'] ?? '',
      targetType: data['targetType'] ?? 'location',
      targetName: data['targetName'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      comment: data['comment'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      helpfulCount: data['helpfulCount'] ?? 0,
      helpfulUserIds: List<String>.from(data['helpfulUserIds'] ?? []),
      isEdited: data['isEdited'] ?? false,
    );
  }

  // Chuyển đổi sang Map để lưu Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'targetId': targetId,
      'targetType': targetType,
      'targetName': targetName,
      'rating': rating,
      'comment': comment,
      'imageUrls': imageUrls,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'helpfulCount': helpfulCount,
      'helpfulUserIds': helpfulUserIds,
      'isEdited': isEdited,
    };
  }

  // Copy with
  ReviewModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatarUrl,
    String? targetId,
    String? targetType,
    String? targetName,
    double? rating,
    String? comment,
    List<String>? imageUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? helpfulCount,
    List<String>? helpfulUserIds,
    bool? isEdited,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      targetId: targetId ?? this.targetId,
      targetType: targetType ?? this.targetType,
      targetName: targetName ?? this.targetName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      helpfulUserIds: helpfulUserIds ?? this.helpfulUserIds,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}
