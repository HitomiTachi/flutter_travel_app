import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/models/packing_item_model.dart';

class PackingChecklistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Template items theo loại chuyến đi
  static List<PackingItemModel> getTemplateItems(TripType tripType) {
    final List<PackingItemModel> items = [];

    // Items cơ bản cho mọi loại chuyến đi
    items.addAll([
      PackingItemModel(
        id: 'template_passport',
        name: 'Hộ chiếu/CMND',
        type: PackingItemType.documents,
        quantity: 1,
      ),
      PackingItemModel(
        id: 'template_wallet',
        name: 'Ví tiền',
        type: PackingItemType.documents,
        quantity: 1,
      ),
      PackingItemModel(
        id: 'template_phone',
        name: 'Điện thoại',
        type: PackingItemType.electronics,
        quantity: 1,
      ),
      PackingItemModel(
        id: 'template_charger',
        name: 'Sạc điện thoại',
        type: PackingItemType.electronics,
        quantity: 1,
      ),
      PackingItemModel(
        id: 'template_toothbrush',
        name: 'Bàn chải đánh răng',
        type: PackingItemType.toiletries,
        quantity: 1,
      ),
      PackingItemModel(
        id: 'template_toothpaste',
        name: 'Kem đánh răng',
        type: PackingItemType.toiletries,
        quantity: 1,
      ),
    ]);

    // Items theo loại chuyến đi
    switch (tripType) {
      case TripType.beach:
        items.addAll([
          PackingItemModel(
            id: 'template_swimsuit',
            name: 'Đồ bơi',
            type: PackingItemType.clothing,
            quantity: 1,
          ),
          PackingItemModel(
            id: 'template_sunscreen',
            name: 'Kem chống nắng',
            type: PackingItemType.toiletries,
            quantity: 1,
          ),
          PackingItemModel(
            id: 'template_hat',
            name: 'Mũ/nón',
            type: PackingItemType.clothing,
            quantity: 1,
          ),
          PackingItemModel(
            id: 'template_towel',
            name: 'Khăn tắm',
            type: PackingItemType.clothing,
            quantity: 1,
          ),
        ]);
        break;
      case TripType.mountain:
        items.addAll([
          PackingItemModel(
            id: 'template_jacket',
            name: 'Áo khoác',
            type: PackingItemType.clothing,
            quantity: 1,
          ),
          PackingItemModel(
            id: 'template_shoes',
            name: 'Giày leo núi',
            type: PackingItemType.clothing,
            quantity: 1,
          ),
          PackingItemModel(
            id: 'template_backpack',
            name: 'Ba lô',
            type: PackingItemType.other,
            quantity: 1,
          ),
        ]);
        break;
      case TripType.adventure:
        items.addAll([
          PackingItemModel(
            id: 'template_backpack',
            name: 'Ba lô',
            type: PackingItemType.other,
            quantity: 1,
          ),
          PackingItemModel(
            id: 'template_flashlight',
            name: 'Đèn pin',
            type: PackingItemType.electronics,
            quantity: 1,
          ),
          PackingItemModel(
            id: 'template_water_bottle',
            name: 'Bình nước',
            type: PackingItemType.other,
            quantity: 1,
          ),
        ]);
        break;
      case TripType.business:
        items.addAll([
          PackingItemModel(
            id: 'template_suit',
            name: 'Đồ vest',
            type: PackingItemType.clothing,
            quantity: 1,
          ),
          PackingItemModel(
            id: 'template_laptop',
            name: 'Laptop',
            type: PackingItemType.electronics,
            quantity: 1,
          ),
        ]);
        break;
      default:
        break;
    }

    return items;
  }

  // Tạo checklist từ template
  Future<void> createChecklistFromTemplate(
    String tripPlanId,
    TripType tripType,
  ) async {
    final templateItems = getTemplateItems(tripType);

    final batch = _firestore.batch();

    for (int i = 0; i < templateItems.length; i++) {
      final item = templateItems[i];
      final itemRef = _firestore
          .collection('packing_checklists')
          .doc('${tripPlanId}_${item.id}');

      batch.set(itemRef, {
        'tripPlanId': tripPlanId,
        'name': item.name,
        'type': item.type.toString().split('.').last,
        'quantity': item.quantity,
        'isChecked': false,
        'order': i,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  // Tạo item tùy chỉnh
  Future<String> createItem({
    required String tripPlanId,
    required String name,
    required PackingItemType type,
    int quantity = 1,
    String? notes,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Lấy order cao nhất
    final snapshot = await _firestore
        .collection('packing_checklists')
        .where('tripPlanId', isEqualTo: tripPlanId)
        .orderBy('order', descending: true)
        .limit(1)
        .get();

    int nextOrder = 0;
    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      nextOrder = (data['order'] as num?)?.toInt() ?? 0;
      nextOrder += 1;
    }

    final itemData = {
      'tripPlanId': tripPlanId,
      'name': name,
      'type': type.toString().split('.').last,
      'quantity': quantity,
      'isChecked': false,
      'order': nextOrder,
      'notes': notes,
      'createdAt': FieldValue.serverTimestamp(),
    };

    final docRef = await _firestore
        .collection('packing_checklists')
        .add(itemData);

    return docRef.id;
  }

  // Cập nhật item
  Future<void> updateItem(
    String itemId, {
    String? name,
    PackingItemType? type,
    int? quantity,
    bool? isChecked,
    String? notes,
    int? order,
  }) async {
    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (name != null) updates['name'] = name;
    if (type != null) {
      updates['type'] = type.toString().split('.').last;
    }
    if (quantity != null) updates['quantity'] = quantity;
    if (isChecked != null) updates['isChecked'] = isChecked;
    if (notes != null) updates['notes'] = notes;
    if (order != null) updates['order'] = order;

    await _firestore
        .collection('packing_checklists')
        .doc(itemId)
        .update(updates);
  }

  // Xóa item
  Future<void> deleteItem(String itemId) async {
    await _firestore.collection('packing_checklists').doc(itemId).delete();
  }

  // Toggle checked
  Future<void> toggleItem(String itemId) async {
    final itemDoc = await _firestore
        .collection('packing_checklists')
        .doc(itemId)
        .get();

    if (!itemDoc.exists) throw Exception('Item not found');

    final data = itemDoc.data()!;
    final isChecked = (data['isChecked'] as bool?) ?? false;

    await _firestore.collection('packing_checklists').doc(itemId).update({
      'isChecked': !isChecked,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Lấy checklist theo trip plan
  Stream<List<PackingItemModel>> getChecklistStream(String tripPlanId) {
    return _firestore
        .collection('packing_checklists')
        .where('tripPlanId', isEqualTo: tripPlanId)
        .orderBy('order')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return PackingItemModel(
              id: doc.id,
              tripPlanId: data['tripPlanId'] as String?,
              name: data['name'] as String,
              type: PackingItemTypeExtension.fromString(data['type'] as String),
              quantity: (data['quantity'] as num?)?.toInt() ?? 1,
              isChecked: (data['isChecked'] as bool?) ?? false,
              order: (data['order'] as num?)?.toInt(),
              notes: data['notes'] as String?,
              createdAt: data['createdAt'] != null
                  ? (data['createdAt'] as Timestamp).toDate()
                  : null,
              updatedAt: data['updatedAt'] != null
                  ? (data['updatedAt'] as Timestamp).toDate()
                  : null,
            );
          }).toList();
        });
  }

  // Lấy checklist theo type
  Stream<Map<PackingItemType, List<PackingItemModel>>> getChecklistByTypeStream(
    String tripPlanId,
  ) {
    return _firestore
        .collection('packing_checklists')
        .where('tripPlanId', isEqualTo: tripPlanId)
        .orderBy('order')
        .snapshots()
        .map((snapshot) {
          final items = snapshot.docs.map((doc) {
            final data = doc.data();
            return PackingItemModel(
              id: doc.id,
              tripPlanId: data['tripPlanId'] as String?,
              name: data['name'] as String,
              type: PackingItemTypeExtension.fromString(data['type'] as String),
              quantity: (data['quantity'] as num?)?.toInt() ?? 1,
              isChecked: (data['isChecked'] as bool?) ?? false,
              order: (data['order'] as num?)?.toInt(),
              notes: data['notes'] as String?,
              createdAt: data['createdAt'] != null
                  ? (data['createdAt'] as Timestamp).toDate()
                  : null,
              updatedAt: data['updatedAt'] != null
                  ? (data['updatedAt'] as Timestamp).toDate()
                  : null,
            );
          }).toList();

          final Map<PackingItemType, List<PackingItemModel>> grouped = {};
          for (var item in items) {
            grouped.putIfAbsent(item.type, () => []).add(item);
          }

          return grouped;
        });
  }

  // Sắp xếp lại items (drag-drop)
  Future<void> reorderItems(String tripPlanId, List<String> itemIds) async {
    final batch = _firestore.batch();

    for (int i = 0; i < itemIds.length; i++) {
      final itemRef = _firestore
          .collection('packing_checklists')
          .doc(itemIds[i]);

      batch.update(itemRef, {
        'order': i,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }
}
