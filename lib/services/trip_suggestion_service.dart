import 'package:cloud_firestore/cloud_firestore.dart';

class TripSuggestionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Gợi ý điểm đến theo ngân sách
  Future<List<Map<String, dynamic>>> suggestDestinationsByBudget(
    double budget,
    int days,
    int travelers,
  ) async {
    try {
      // Tính ngân sách trung bình mỗi ngày cho mỗi người
      final budgetPerPersonPerDay = budget / (days * travelers);

      // Query locations có rating và price range phù hợp
      final snapshot = await _firestore
          .collection('locations')
          .where(
            'averagePricePerDay',
            isLessThanOrEqualTo: budgetPerPersonPerDay * 1.5,
          )
          .orderBy('averagePricePerDay')
          .orderBy('rating', descending: true)
          .limit(10)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? '',
          'description': data['description'] ?? '',
          'imageUrl': data['imageUrl'],
          'rating': (data['rating']?.toDouble() ?? 0.0),
          'averagePricePerDay': (data['averagePricePerDay']?.toDouble() ?? 0.0),
          'location': data['location'] ?? '',
        };
      }).toList();
    } catch (e) {
      // Fallback: trả về danh sách phổ biến
      return _getPopularDestinations();
    }
  }

  // Gợi ý hoạt động theo thời tiết/giờ
  Future<List<Map<String, dynamic>>> suggestActivitiesByWeather(
    String location,
    DateTime dateTime,
    String? weatherCondition, // 'sunny', 'rainy', 'cloudy', etc.
  ) async {
    try {
      final hour = dateTime.hour;
      List<String> activityTypes = [];

      // Gợi ý theo thời tiết
      if (weatherCondition != null) {
        switch (weatherCondition.toLowerCase()) {
          case 'sunny':
          case 'clear':
            activityTypes.addAll(['sightseeing', 'entertainment', 'dining']);
            break;
          case 'rainy':
          case 'stormy':
            activityTypes.addAll(['dining', 'shopping', 'entertainment']);
            break;
          case 'cloudy':
            activityTypes.addAll(['sightseeing', 'dining', 'shopping']);
            break;
          default:
            activityTypes.addAll(['sightseeing', 'dining', 'entertainment']);
        }
      } else {
        activityTypes.addAll(['sightseeing', 'dining', 'entertainment']);
      }

      // Gợi ý theo giờ trong ngày
      if (hour >= 6 && hour < 10) {
        // Buổi sáng
        activityTypes.add('sightseeing');
      } else if (hour >= 10 && hour < 14) {
        // Giữa trưa
        activityTypes.add('dining');
      } else if (hour >= 14 && hour < 18) {
        // Buổi chiều
        activityTypes.add('sightseeing');
        activityTypes.add('entertainment');
      } else if (hour >= 18 && hour < 22) {
        // Buổi tối
        activityTypes.add('dining');
        activityTypes.add('entertainment');
      }

      // Query activities
      final results = <Map<String, dynamic>>[];

      for (var type in activityTypes.toSet()) {
        final snapshot = await _firestore
            .collection('activities')
            .where('type', isEqualTo: type)
            .where('location', isEqualTo: location)
            .orderBy('rating', descending: true)
            .limit(5)
            .get();

        for (var doc in snapshot.docs) {
          final data = doc.data();
          results.add({
            'id': doc.id,
            'name': data['name'] ?? '',
            'description': data['description'] ?? '',
            'type': type,
            'rating': (data['rating']?.toDouble() ?? 0.0),
            'estimatedDuration': data['estimatedDuration'],
            'estimatedCost': (data['estimatedCost']?.toDouble() ?? 0.0),
            'imageUrl': data['imageUrl'],
          });
        }
      }

      return results;
    } catch (e) {
      // Fallback: trả về danh sách mặc định
      return _getDefaultActivities();
    }
  }

  // Gợi ý nhà hàng gần đây
  Future<List<Map<String, dynamic>>> suggestNearbyRestaurants({
    required double latitude,
    required double longitude,
    double radiusKm = 5.0,
    int limit = 10,
  }) async {
    try {
      // Firestore không hỗ trợ geo query trực tiếp,
      // nên ta sẽ query tất cả và filter sau
      // Hoặc có thể dùng extension như geofirestore
      // Ở đây tạm thời query theo location name

      final snapshot = await _firestore
          .collection('restaurants')
          .where('rating', isGreaterThanOrEqualTo: 4.0)
          .orderBy('rating', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? '',
          'description': data['description'] ?? '',
          'rating': (data['rating']?.toDouble() ?? 0.0),
          'averagePrice': (data['averagePrice']?.toDouble() ?? 0.0),
          'cuisine': data['cuisine'] ?? '',
          'address': data['address'] ?? '',
          'latitude': (data['latitude']?.toDouble()),
          'longitude': (data['longitude']?.toDouble()),
          'imageUrl': data['imageUrl'],
        };
      }).toList();
    } catch (e) {
      // Fallback
      return [];
    }
  }

  // Gợi ý hoạt động theo ngân sách
  Future<List<Map<String, dynamic>>> suggestActivitiesByBudget(
    double remainingBudget,
    int remainingDays,
  ) async {
    try {
      final budgetPerDay = remainingBudget / remainingDays;
      final snapshot = await _firestore
          .collection('activities')
          .where('estimatedCost', isLessThanOrEqualTo: budgetPerDay * 1.2)
          .orderBy('estimatedCost')
          .orderBy('rating', descending: true)
          .limit(10)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? '',
          'description': data['description'] ?? '',
          'type': data['type'] ?? '',
          'rating': (data['rating']?.toDouble() ?? 0.0),
          'estimatedCost': (data['estimatedCost']?.toDouble() ?? 0.0),
          'estimatedDuration': data['estimatedDuration'],
          'imageUrl': data['imageUrl'],
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Gợi ý theo sở thích (có thể mở rộng)
  Future<List<Map<String, dynamic>>> suggestByPreferences({
    List<String>? interests, // ['beach', 'mountain', 'city', etc.]
    double? budget,
    int? days,
  }) async {
    // TODO: Implement preference-based suggestions
    // Có thể sử dụng user preferences từ Firestore
    return [];
  }

  // Helper: Danh sách điểm đến phổ biến
  List<Map<String, dynamic>> _getPopularDestinations() {
    return [
      {
        'id': 'hlb1',
        'name': 'Vịnh Hạ Long',
        'description': 'Di sản thế giới với hàng nghìn đảo đá vôi kỳ thú',
        'rating': 4.9,
        'averagePricePerDay': 500000.0,
      },
      {
        'id': 'pq1',
        'name': 'Phú Quốc',
        'description': 'Đảo ngọc nhiệt đới với bãi biển cát trắng tuyệt đẹp',
        'rating': 4.8,
        'averagePricePerDay': 600000.0,
      },
      {
        'id': 'dl1',
        'name': 'Đà Lạt',
        'description': 'Thành phố ngàn hoa với khí hậu mát mẻ quanh năm',
        'rating': 4.7,
        'averagePricePerDay': 400000.0,
      },
    ];
  }

  // Helper: Danh sách hoạt động mặc định
  List<Map<String, dynamic>> _getDefaultActivities() {
    return [
      {
        'id': 'act1',
        'name': 'Tham quan di tích',
        'type': 'sightseeing',
        'rating': 4.5,
        'estimatedCost': 200000.0,
      },
      {
        'id': 'act2',
        'name': 'Ăn uống đặc sản',
        'type': 'dining',
        'rating': 4.6,
        'estimatedCost': 300000.0,
      },
      {
        'id': 'act3',
        'name': 'Mua sắm',
        'type': 'shopping',
        'rating': 4.3,
        'estimatedCost': 500000.0,
      },
    ];
  }
}
