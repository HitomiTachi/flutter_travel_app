import 'package:cloud_firestore/cloud_firestore.dart';

enum ExpenseCategory {
  transport,
  accommodation,
  dining,
  sightseeing,
  shopping,
  entertainment,
  other,
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get label {
    switch (this) {
      case ExpenseCategory.transport:
        return 'Di chuyển';
      case ExpenseCategory.accommodation:
        return 'Lưu trú';
      case ExpenseCategory.dining:
        return 'Ăn uống';
      case ExpenseCategory.sightseeing:
        return 'Tham quan';
      case ExpenseCategory.shopping:
        return 'Mua sắm';
      case ExpenseCategory.entertainment:
        return 'Giải trí';
      case ExpenseCategory.other:
        return 'Khác';
    }
  }

  String get firestoreValue {
    return toString().split('.').last;
  }

  static ExpenseCategory fromString(String value) {
    return ExpenseCategory.values.firstWhere(
      (e) => e.firestoreValue == value,
      orElse: () => ExpenseCategory.other,
    );
  }
}

class ExpenseModel {
  final String id;
  final String tripPlanId;
  final int day; // Ngày nào trong chuyến đi
  final String? activityId; // Liên kết với activity nếu có
  final String description;
  final double amount;
  final ExpenseCategory category;
  final DateTime expenseDate;
  final String? notes;
  final String? receiptImageUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ExpenseModel({
    required this.id,
    required this.tripPlanId,
    required this.day,
    this.activityId,
    required this.description,
    required this.amount,
    required this.category,
    required this.expenseDate,
    this.notes,
    this.receiptImageUrl,
    required this.createdAt,
    this.updatedAt,
  });

  factory ExpenseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExpenseModel(
      id: doc.id,
      tripPlanId: data['tripPlanId'] as String,
      day: data['day'] as int,
      activityId: data['activityId'] as String?,
      description: data['description'] as String,
      amount: (data['amount'] as num).toDouble(),
      category: ExpenseCategoryExtension.fromString(data['category'] as String),
      expenseDate: (data['expenseDate'] as Timestamp).toDate(),
      notes: data['notes'] as String?,
      receiptImageUrl: data['receiptImageUrl'] as String?,
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
      'activityId': activityId,
      'description': description,
      'amount': amount,
      'category': category.firestoreValue,
      'expenseDate': Timestamp.fromDate(expenseDate),
      'notes': notes,
      'receiptImageUrl': receiptImageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  ExpenseModel copyWith({
    String? id,
    String? tripPlanId,
    int? day,
    String? activityId,
    String? description,
    double? amount,
    ExpenseCategory? category,
    DateTime? expenseDate,
    String? notes,
    String? receiptImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      tripPlanId: tripPlanId ?? this.tripPlanId,
      day: day ?? this.day,
      activityId: activityId ?? this.activityId,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      expenseDate: expenseDate ?? this.expenseDate,
      notes: notes ?? this.notes,
      receiptImageUrl: receiptImageUrl ?? this.receiptImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Format amount
  String get amountDisplay {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
