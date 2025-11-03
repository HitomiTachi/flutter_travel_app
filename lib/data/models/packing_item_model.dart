enum PackingItemType {
  clothing,
  toiletries,
  electronics,
  documents,
  medicines,
  other,
}

extension PackingItemTypeExtension on PackingItemType {
  String get label {
    switch (this) {
      case PackingItemType.clothing:
        return 'Quần áo';
      case PackingItemType.toiletries:
        return 'Đồ dùng vệ sinh';
      case PackingItemType.electronics:
        return 'Điện tử';
      case PackingItemType.documents:
        return 'Giấy tờ';
      case PackingItemType.medicines:
        return 'Thuốc';
      case PackingItemType.other:
        return 'Khác';
    }
  }

  static PackingItemType fromString(String value) {
    return PackingItemType.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => PackingItemType.other,
    );
  }
}

enum TripType { beach, mountain, city, adventure, business, family, other }

extension TripTypeExtension on TripType {
  String get label {
    switch (this) {
      case TripType.beach:
        return 'Biển';
      case TripType.mountain:
        return 'Núi';
      case TripType.city:
        return 'Thành phố';
      case TripType.adventure:
        return 'Phiêu lưu';
      case TripType.business:
        return 'Công tác';
      case TripType.family:
        return 'Gia đình';
      case TripType.other:
        return 'Khác';
    }
  }

  String get firestoreValue {
    return toString().split('.').last;
  }

  static TripType fromString(String value) {
    return TripType.values.firstWhere(
      (e) => e.firestoreValue == value,
      orElse: () => TripType.other,
    );
  }
}

class PackingItemModel {
  final String id;
  final String? tripPlanId; // null nếu là template item
  final String name;
  final PackingItemType type;
  final int quantity;
  final bool isChecked;
  final int? order; // Thứ tự để sort
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PackingItemModel({
    required this.id,
    this.tripPlanId,
    required this.name,
    required this.type,
    this.quantity = 1,
    this.isChecked = false,
    this.order,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  PackingItemModel copyWith({
    String? id,
    String? tripPlanId,
    String? name,
    PackingItemType? type,
    int? quantity,
    bool? isChecked,
    int? order,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PackingItemModel(
      id: id ?? this.id,
      tripPlanId: tripPlanId ?? this.tripPlanId,
      name: name ?? this.name,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      isChecked: isChecked ?? this.isChecked,
      order: order ?? this.order,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
