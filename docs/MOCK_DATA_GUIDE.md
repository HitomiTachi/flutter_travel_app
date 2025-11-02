# Mock Data Architecture

## 📂 Cấu trúc

```
mock/
├── destination_data_provider.dart  ✅ Nguồn dữ liệu destinations
├── article_data_provider.dart      ✅ Nguồn dữ liệu articles
├── README.md                       📖 Tài liệu
└── USAGE_MAP.md                    📊 Danh sách file sử dụng
```

> **Note:** Đã loại bỏ `destination_data.dart` và `article_data.dart` (deprecated)

## ✨ Cải tiến

### **Bây giờ** (Single Source of Truth - Cleaned Up)
```dart
// destination_data_provider.dart - DUY NHẤT nguồn dữ liệu
class DestinationDataProvider {
  static final List<PopularDestination> _destinations = [...]; // Private data
  
  // Getters chính
  static List<PopularDestination> getPopularDestinations() => List.from(_destinations);
  static List<PopularDestination> get popularDestinations => getPopularDestinations();
  
  // Utilities
  static List<PopularDestination> getDestinationsByIds(Set<String> ids) {...}
  static Set<String> getDefaultFavoriteIds() {...}
  static List<PopularDestination> filterByCategory(...) {...}
  static List<PopularDestination> searchDestinations(String query) {...}
  static List<PopularDestination> getDestinationsByCountry(String country) {...}
}
```

**Ưu điểm:**
- ✅ **DRY**: Dữ liệu chỉ định nghĩa 1 lần
- ✅ **Consistency**: Toàn bộ app dùng chung 1 nguồn
- ✅ **Maintainability**: Thêm/sửa destination chỉ ở 1 chỗ
- ✅ **Clean**: Loại bỏ hoàn toàn file deprecated
- ✅ **Type-safe**: Tất cả methods đều type-safe

## 🎯 Sử dụng

### Cho màn hình thông thường
```dart
// Lấy toàn bộ destinations
final destinations = DestinationDataProvider.getPopularDestinations();

// Tìm kiếm
final results = DestinationDataProvider.searchDestinations('Hạ Long');

// Lọc theo quốc gia
final vietnam = DestinationDataProvider.getDestinationsByCountry('Việt Nam');

// Top rated
final top5 = DestinationDataProvider.getTopRatedDestinations(limit: 5);
```

### Cho màn hình Favorites (like_screen.dart)
```dart
class _LikeScreenState extends State<LikeScreen> {
  late Set<String> _likedPlaceIds;

  @override
  void initState() {
    super.initState();
    // Lấy IDs mặc định
    _likedPlaceIds = DestinationDataProvider.getDefaultFavoriteIds();
  }

  // Getter tự động lấy full objects từ IDs
  List<PopularDestination> get _likedPlaces => 
      DestinationDataProvider.getDestinationsByIds(_likedPlaceIds);

  // Filter theo category
  void _applyFilter(String category) {
    final filtered = DestinationDataProvider.filterByCategory(
      _likedPlaces, 
      category
    );
  }
}
```

## 📊 So sánh trước/sau

| Aspect | Trước | Sau |
|--------|-------|-----|
| **Số file mock** | 4 files | 2 files (-50%) |
| **Định nghĩa data** | 2 nơi | 1 nơi |
| **Khả năng maintain** | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Hiệu năng** | Tốt | Tốt (giống nhau) |
| **Tính năng** | Cơ bản | +Favorites, +Filter, +Search |
| **Deprecated files** | 2 files | 0 files ✅ |

## 🚀 Tiếp theo

Khi migrate lên Firebase:
```dart
class DestinationService {
  // Provider mock sẽ thay bằng Firebase query
  Stream<List<PopularDestination>> getDestinationsStream() {
    return _firestore.collection('locations').snapshots().map(...);
  }
  
  // Các methods như getDestinationsByIds() vẫn giữ nguyên logic
  Future<List<PopularDestination>> getDestinationsByIds(Set<String> ids) async {
    // Query Firestore với whereIn
  }
}
```

## 📝 Import Guide

**Cách import đúng:**
```dart
// Destinations
import 'package:flutter_travels_apps/data/mock/destination_data_provider.dart';
final destinations = DestinationDataProvider.getPopularDestinations();

// Articles
import 'package:flutter_travels_apps/data/mock/article_data_provider.dart';
final articles = ArticleDataProvider.getFeaturedArticles();
```

**⚠️ KHÔNG CÒN:**
```dart
// ❌ Files này đã bị xóa
import 'package:flutter_travels_apps/data/mock/destination_data.dart';
import 'package:flutter_travels_apps/data/mock/article_data.dart';
```
