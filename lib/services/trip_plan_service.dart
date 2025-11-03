import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/models/trip_plan_detail_model.dart';
import '../data/models/trip_activity_model.dart';

class TripPlanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Tạo trip plan mới
  Future<String> createTripPlan({
    required String title,
    required String destination,
    required String departure,
    required DateTime startDate,
    required DateTime endDate,
    required int travelers,
    required double budget,
    String? description,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final tripPlan = TripPlanDetailModel(
      id: '', // Sẽ được tạo tự động
      userId: user.uid,
      title: title,
      destination: destination,
      departure: departure,
      startDate: startDate,
      endDate: endDate,
      travelers: travelers,
      budget: budget,
      status: TripStatus.planned,
      description: description,
      createdAt: DateTime.now(),
    );

    final docRef = await _firestore
        .collection('trip_plans')
        .add(tripPlan.toFirestore());

    return docRef.id;
  }

  // Cập nhật trip plan
  Future<void> updateTripPlan(
    String tripPlanId, {
    String? title,
    String? destination,
    String? departure,
    DateTime? startDate,
    DateTime? endDate,
    int? travelers,
    double? budget,
    String? description,
    TripStatus? status,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final tripPlanDoc = await _firestore
        .collection('trip_plans')
        .doc(tripPlanId)
        .get();

    if (!tripPlanDoc.exists) throw Exception('Trip plan not found');

    final tripPlan = TripPlanDetailModel.fromFirestore(tripPlanDoc);

    if (tripPlan.userId != user.uid) {
      throw Exception('Permission denied');
    }

    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (title != null) updates['title'] = title;
    if (destination != null) updates['destination'] = destination;
    if (departure != null) updates['departure'] = departure;
    if (startDate != null) updates['startDate'] = Timestamp.fromDate(startDate);
    if (endDate != null) updates['endDate'] = Timestamp.fromDate(endDate);
    if (travelers != null) updates['travelers'] = travelers;
    if (budget != null) updates['budget'] = budget;
    if (description != null) updates['description'] = description;
    if (status != null) updates['status'] = status.firestoreValue;

    await _firestore.collection('trip_plans').doc(tripPlanId).update(updates);
  }

  // Xóa trip plan
  Future<void> deleteTripPlan(String tripPlanId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final tripPlanDoc = await _firestore
        .collection('trip_plans')
        .doc(tripPlanId)
        .get();

    if (!tripPlanDoc.exists) throw Exception('Trip plan not found');

    final tripPlan = TripPlanDetailModel.fromFirestore(tripPlanDoc);

    if (tripPlan.userId != user.uid) {
      throw Exception('Permission denied');
    }

    // Xóa tất cả activities
    final activitiesSnapshot = await _firestore
        .collection('trip_activities')
        .where('tripPlanId', isEqualTo: tripPlanId)
        .get();

    final batch = _firestore.batch();
    for (var doc in activitiesSnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();

    // Xóa trip plan
    await _firestore.collection('trip_plans').doc(tripPlanId).delete();
  }

  // Lấy trip plan theo ID
  Future<TripPlanDetailModel?> getTripPlan(String tripPlanId) async {
    final doc = await _firestore.collection('trip_plans').doc(tripPlanId).get();

    if (!doc.exists) return null;
    return TripPlanDetailModel.fromFirestore(doc);
  }

  // Lấy trip plan stream theo ID
  Stream<TripPlanDetailModel?> getTripPlanStream(String tripPlanId) {
    return _firestore.collection('trip_plans').doc(tripPlanId).snapshots().map((
      doc,
    ) {
      if (!doc.exists) return null;
      return TripPlanDetailModel.fromFirestore(doc);
    });
  }

  // Lấy danh sách trip plans của user
  Stream<List<TripPlanDetailModel>> getTripPlansStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('trip_plans')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TripPlanDetailModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Lấy trip plans được chia sẻ
  Stream<List<TripPlanDetailModel>> getSharedTripPlansStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('trip_plans')
        .where('sharedWithUserIds', arrayContains: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TripPlanDetailModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Chia sẻ trip plan với user khác
  Future<void> shareTripPlan(String tripPlanId, String userId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final tripPlanDoc = await _firestore
        .collection('trip_plans')
        .doc(tripPlanId)
        .get();

    if (!tripPlanDoc.exists) throw Exception('Trip plan not found');

    final tripPlan = TripPlanDetailModel.fromFirestore(tripPlanDoc);

    if (tripPlan.userId != user.uid) {
      throw Exception('Permission denied');
    }

    final sharedWithUserIds = List<String>.from(tripPlan.sharedWithUserIds);
    if (!sharedWithUserIds.contains(userId)) {
      sharedWithUserIds.add(userId);
      await _firestore.collection('trip_plans').doc(tripPlanId).update({
        'sharedWithUserIds': sharedWithUserIds,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Bỏ chia sẻ trip plan
  Future<void> unshareTripPlan(String tripPlanId, String userId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final tripPlanDoc = await _firestore
        .collection('trip_plans')
        .doc(tripPlanId)
        .get();

    if (!tripPlanDoc.exists) throw Exception('Trip plan not found');

    final tripPlan = TripPlanDetailModel.fromFirestore(tripPlanDoc);

    if (tripPlan.userId != user.uid) {
      throw Exception('Permission denied');
    }

    final sharedWithUserIds = List<String>.from(tripPlan.sharedWithUserIds);
    sharedWithUserIds.remove(userId);

    await _firestore.collection('trip_plans').doc(tripPlanId).update({
      'sharedWithUserIds': sharedWithUserIds,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ================== TRIP ACTIVITIES ==================

  // Tạo activity
  Future<String> createActivity({
    required String tripPlanId,
    required int day,
    required String time,
    required String title,
    required String description,
    required ActivityType type,
    int? durationMinutes,
    double? estimatedCost,
    String? locationId,
    String? locationName,
    String? notes,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Lấy order cao nhất trong ngày
    final activitiesSnapshot = await _firestore
        .collection('trip_activities')
        .where('tripPlanId', isEqualTo: tripPlanId)
        .where('day', isEqualTo: day)
        .orderBy('order', descending: true)
        .limit(1)
        .get();

    int nextOrder = 0;
    if (activitiesSnapshot.docs.isNotEmpty) {
      final lastActivity = TripActivityModel.fromFirestore(
        activitiesSnapshot.docs.first,
      );
      nextOrder = lastActivity.order + 1;
    }

    final activity = TripActivityModel(
      id: '', // Sẽ được tạo tự động
      tripPlanId: tripPlanId,
      day: day,
      order: nextOrder,
      time: time,
      title: title,
      description: description,
      type: type,
      durationMinutes: durationMinutes,
      estimatedCost: estimatedCost,
      locationId: locationId,
      locationName: locationName,
      notes: notes,
      createdAt: DateTime.now(),
    );

    final docRef = await _firestore
        .collection('trip_activities')
        .add(activity.toFirestore());

    return docRef.id;
  }

  // Cập nhật activity
  Future<void> updateActivity(
    String activityId, {
    String? time,
    String? title,
    String? description,
    ActivityType? type,
    int? durationMinutes,
    double? estimatedCost,
    String? locationId,
    String? locationName,
    String? notes,
    int? order,
  }) async {
    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (time != null) updates['time'] = time;
    if (title != null) updates['title'] = title;
    if (description != null) updates['description'] = description;
    if (type != null) updates['type'] = type.firestoreValue;
    if (durationMinutes != null) updates['durationMinutes'] = durationMinutes;
    if (estimatedCost != null) updates['estimatedCost'] = estimatedCost;
    if (locationId != null) updates['locationId'] = locationId;
    if (locationName != null) updates['locationName'] = locationName;
    if (notes != null) updates['notes'] = notes;
    if (order != null) updates['order'] = order;

    await _firestore
        .collection('trip_activities')
        .doc(activityId)
        .update(updates);
  }

  // Xóa activity
  Future<void> deleteActivity(String activityId) async {
    await _firestore.collection('trip_activities').doc(activityId).delete();
  }

  // Lấy activities theo trip plan và ngày
  Stream<List<TripActivityModel>> getActivitiesStream(
    String tripPlanId,
    int day,
  ) {
    return _firestore
        .collection('trip_activities')
        .where('tripPlanId', isEqualTo: tripPlanId)
        .where('day', isEqualTo: day)
        .orderBy('order')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TripActivityModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Lấy tất cả activities theo trip plan
  Stream<Map<int, List<TripActivityModel>>> getAllActivitiesStream(
    String tripPlanId,
  ) {
    return _firestore
        .collection('trip_activities')
        .where('tripPlanId', isEqualTo: tripPlanId)
        .orderBy('day')
        .orderBy('order')
        .snapshots()
        .map((snapshot) {
          final activities = snapshot.docs
              .map((doc) => TripActivityModel.fromFirestore(doc))
              .toList();

          final Map<int, List<TripActivityModel>> grouped = {};
          for (var activity in activities) {
            grouped.putIfAbsent(activity.day, () => []).add(activity);
          }

          return grouped;
        });
  }

  // Sắp xếp lại activities (drag-drop)
  Future<void> reorderActivities(
    String tripPlanId,
    int day,
    List<String> activityIds,
  ) async {
    final batch = _firestore.batch();

    for (int i = 0; i < activityIds.length; i++) {
      final activityRef = _firestore
          .collection('trip_activities')
          .doc(activityIds[i]);

      batch.update(activityRef, {
        'order': i,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }
}
