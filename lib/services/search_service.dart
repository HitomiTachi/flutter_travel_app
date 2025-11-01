import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_travels_apps/core/helpers/local_storage_helper.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tìm kiếm toàn cục
  Future<List<Map<String, dynamic>>> globalSearch(String query) async {
    if (query.isEmpty) return [];

    final results = <Map<String, dynamic>>[];

    try {
      // Tìm trong locations
      final locationsSnapshot = await _firestore
          .collection('locations')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(10)
          .get();

      for (var doc in locationsSnapshot.docs) {
        final data = doc.data();
        results.add({
          'id': doc.id,
          'type': 'location',
          'name': data['name'] ?? '',
          'description': data['description'] ?? '',
          'imageUrl': data['imageUrl'],
          'rating': data['rating']?.toDouble() ?? 0.0,
        });
      }

      // Tìm trong hotels
      final hotelsSnapshot = await _firestore
          .collection('hotels')
          .where('hotelName', isGreaterThanOrEqualTo: query)
          .where('hotelName', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(10)
          .get();

      for (var doc in hotelsSnapshot.docs) {
        final data = doc.data();
        results.add({
          'id': doc.id,
          'type': 'hotel',
          'name': data['hotelName'] ?? '',
          'description': data['location'] ?? '',
          'imageUrl': data['hotelImage'],
          'rating': data['star']?.toDouble() ?? 0.0,
        });
      }
    } catch (e) {
      // Fallback to local search if Firestore fails
    }

    // Lưu vào lịch sử tìm kiếm
    if (results.isNotEmpty) {
      _addToSearchHistory(query);
    }

    return results;
  }

  // Gợi ý tìm kiếm
  Future<List<String>> getSearchSuggestions(String query) async {
    if (query.isEmpty) return [];

    final suggestions = <String>[];
    final history = getSearchHistory();

    // Gợi ý từ lịch sử
    for (var item in history) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        suggestions.add(item);
      }
      if (suggestions.length >= 5) break;
    }

    return suggestions;
  }

  // Lưu vào lịch sử tìm kiếm
  void addToSearchHistory(String query) {
    _addToSearchHistory(query);
  }

  // Lưu vào lịch sử tìm kiếm (private)
  void _addToSearchHistory(String query) {
    final key = 'search_history';
    final List<dynamic> history =
        (LocalStorageHelper.getValue(key) as List<dynamic>?) ?? [];

    // Xóa nếu đã tồn tại
    history.remove(query);
    // Thêm vào đầu
    history.insert(0, query);
    // Giới hạn 20 items
    if (history.length > 20) {
      history.removeRange(20, history.length);
    }

    LocalStorageHelper.setValue(key, history);
  }

  // Lấy lịch sử tìm kiếm
  List<String> getSearchHistory() {
    final key = 'search_history';
    final List<dynamic> history =
        (LocalStorageHelper.getValue(key) as List<dynamic>?) ?? [];
    return history.cast<String>();
  }

  // Xóa lịch sử tìm kiếm
  void clearSearchHistory() {
    LocalStorageHelper.setValue('search_history', <String>[]);
  }
}
