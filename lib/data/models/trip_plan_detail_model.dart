import 'package:cloud_firestore/cloud_firestore.dart';
import 'trip_activity_model.dart';

enum TripStatus { planned, ongoing, completed, cancelled }

extension TripStatusExtension on TripStatus {
  String get label {
    switch (this) {
      case TripStatus.planned:
        return 'Kế hoạch';
      case TripStatus.ongoing:
        return 'Đang thực hiện';
      case TripStatus.completed:
        return 'Hoàn thành';
      case TripStatus.cancelled:
        return 'Đã hủy';
    }
  }

  String get firestoreValue {
    return toString().split('.').last;
  }

  static TripStatus fromString(String value) {
    return TripStatus.values.firstWhere(
      (e) => e.firestoreValue == value,
      orElse: () => TripStatus.planned,
    );
  }
}

class TripPlanDetailModel {
  final String id;
  final String userId;
  final String title;
  final String destination;
  final String departure;
  final DateTime startDate;
  final DateTime endDate;
  final int travelers;
  final double budget;
  final double? actualSpent; // Tổng chi tiêu thực tế
  final TripStatus status;
  final String? description;
  final List<String> sharedWithUserIds; // Danh sách user được chia sẻ
  final bool isPublic; // Cho phép công khai
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;

  // Computed properties
  int get totalDays {
    return endDate.difference(startDate).inDays + 1;
  }

  double get remainingBudget {
    if (actualSpent == null) return budget;
    return budget - actualSpent!;
  }

  double get budgetProgress {
    if (budget == 0) return 0.0;
    if (actualSpent == null) return 0.0;
    return (actualSpent! / budget).clamp(0.0, 1.0);
  }

  bool get isOverBudget {
    return actualSpent != null && actualSpent! > budget;
  }

  TripPlanDetailModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.destination,
    required this.departure,
    required this.startDate,
    required this.endDate,
    required this.travelers,
    required this.budget,
    this.actualSpent,
    required this.status,
    this.description,
    this.sharedWithUserIds = const [],
    this.isPublic = false,
    required this.createdAt,
    this.updatedAt,
    this.completedAt,
  });

  factory TripPlanDetailModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TripPlanDetailModel(
      id: doc.id,
      userId: data['userId'] as String,
      title: data['title'] as String,
      destination: data['destination'] as String,
      departure: data['departure'] as String,
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      travelers: (data['travelers'] as num).toInt(),
      budget: (data['budget'] as num).toDouble(),
      actualSpent: (data['actualSpent'] as num?)?.toDouble(),
      status: TripStatusExtension.fromString(data['status'] as String),
      description: data['description'] as String?,
      sharedWithUserIds:
          (data['sharedWithUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isPublic: data['isPublic'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'destination': destination,
      'departure': departure,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'travelers': travelers,
      'budget': budget,
      'actualSpent': actualSpent,
      'status': status.firestoreValue,
      'description': description,
      'sharedWithUserIds': sharedWithUserIds,
      'isPublic': isPublic,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'completedAt': completedAt != null
          ? Timestamp.fromDate(completedAt!)
          : null,
    };
  }

  TripPlanDetailModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? destination,
    String? departure,
    DateTime? startDate,
    DateTime? endDate,
    int? travelers,
    double? budget,
    double? actualSpent,
    TripStatus? status,
    String? description,
    List<String>? sharedWithUserIds,
    bool? isPublic,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) {
    return TripPlanDetailModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      destination: destination ?? this.destination,
      departure: departure ?? this.departure,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      travelers: travelers ?? this.travelers,
      budget: budget ?? this.budget,
      actualSpent: actualSpent ?? this.actualSpent,
      status: status ?? this.status,
      description: description ?? this.description,
      sharedWithUserIds: sharedWithUserIds ?? this.sharedWithUserIds,
      isPublic: isPublic ?? this.isPublic,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
