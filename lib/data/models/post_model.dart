import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String? description;
  final List<String>? imageUrls;
  final String? locationName;
  final GeoPoint? location;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? authorName;
  final String? authorAvatar;
  
  // Constants for default values
  static const String defaultDescription = 'Cập nhật sau';
  static const String defaultLocationName = 'Cập nhật sau';
  static const String defaultAuthorName = 'Cập nhật sau';

  PostModel({
    required this.id,
    required this.userId,
    this.description,
    this.imageUrls,
    this.locationName,
    this.location,
    required this.createdAt,
    this.updatedAt,
    this.authorName,
    this.authorAvatar,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'description': description,
      'imageUrls': imageUrls ?? [],
      'locationName': locationName,
      'location': location,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      description: map['description'],
      imageUrls: map['imageUrls'] != null ? List<String>.from(map['imageUrls']) : null,
      locationName: map['locationName'],
      location: map['location'] as GeoPoint?,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: map['updatedAt'] != null 
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
      authorName: map['authorName'],
      authorAvatar: map['authorAvatar'],
    );
  }
}