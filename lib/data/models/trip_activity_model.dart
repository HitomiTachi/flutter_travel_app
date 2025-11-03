import 'package:cloud_firestore/cloud_firestore.dart';

enum ActivityType {
  transport,
  accommodation,
  sightseeing,
  dining,
  shopping,
  entertainment,
  leisure,
}

extension ActivityTypeExtension on ActivityType {
  String get label {
    switch (this) {
      case ActivityType.transport:
        return 'Di chuyển';
      case ActivityType.accommodation:
        return 'Lưu trú';
      case ActivityType.sightseeing:
        return 'Tham quan';
      case ActivityType.dining:
        return 'Ăn uống';
      case ActivityType.shopping:
        return 'Mua sắm';
      case ActivityType.entertainment:
        return 'Giải trí';
      case ActivityType.leisure:
        return 'Tự do';
    }
  }

  String get firestoreValue {
    return toString().split('.').last;
  }

  static ActivityType fromString(String value) {
    return ActivityType.values.firstWhere(
      (e) => e.firestoreValue == value,
      orElse: () => ActivityType.leisure,
    );
  }
}

class TripActivityModel {
  final String id;
  final String tripPlanId;
  final int day;
  final int order; // Thứ tự để sort và drag-drop
  final String time; // Format: "HH:mm"
  final String title;
  final String description;
  final ActivityType type;
  final int? durationMinutes; // Thời gian ước tính (phút)
  final double? estimatedCost; // Chi phí ước tính (VNĐ)
  final String? locationId; // ID của location/hotel nếu có
  final String? locationName;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  TripActivityModel({
    required this.id,
    required this.tripPlanId,
    required this.day,
    required this.order,
    required this.time,
    required this.title,
    required this.description,
    required this.type,
    this.durationMinutes,
    this.estimatedCost,
    this.locationId,
    this.locationName,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  factory TripActivityModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TripActivityModel(
      id: doc.id,
      tripPlanId: data['tripPlanId'] as String,
      day: data['day'] as int,
      order: (data['order'] as num?)?.toInt() ?? 0,
      time: data['time'] as String,
      title: data['title'] as String,
      description: data['description'] as String,
      type: ActivityTypeExtension.fromString(data['type'] as String),
      durationMinutes: (data['durationMinutes'] as num?)?.toInt(),
      estimatedCost: (data['estimatedCost'] as num?)?.toDouble(),
      locationId: data['locationId'] as String?,
      locationName: data['locationName'] as String?,
      notes: data['notes'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tripPlanId': tripPlanId,
      'day': day,
      'order': order,
      'time': time,
      'title': title,
      'description': description,
      'type': type.firestoreValue,
      'durationMinutes': durationMinutes,
      'estimatedCost': estimatedCost,
      'locationId': locationId,
      'locationName': locationName,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  TripActivityModel copyWith({
    String? id,
    String? tripPlanId,
    int? day,
    int? order,
    String? time,
    String? title,
    String? description,
    ActivityType? type,
    int? durationMinutes,
    double? estimatedCost,
    String? locationId,
    String? locationName,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TripActivityModel(
      id: id ?? this.id,
      tripPlanId: tripPlanId ?? this.tripPlanId,
      day: day ?? this.day,
      order: order ?? this.order,
      time: time ?? this.time,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      locationId: locationId ?? this.locationId,
      locationName: locationName ?? this.locationName,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Format duration
  String get durationDisplay {
    if (durationMinutes == null) return 'Không xác định';
    if (durationMinutes! < 60) return '$durationMinutes phút';
    final hours = durationMinutes! ~/ 60;
    final minutes = durationMinutes! % 60;
    if (minutes == 0) return '$hours giờ';
    return '$hours giờ $minutes phút';
  }

  // Format cost
  String get costDisplay {
    if (estimatedCost == null) return 'Tùy chọn';
    return '${estimatedCost!.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} VNĐ';
  }
}
