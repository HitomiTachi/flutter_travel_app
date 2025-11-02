# 📊 Mock Data Usage Map

## Tổng quan
Hiện tại **KHÔNG CÒN FILE NÀO** sử dụng trực tiếp `DestinationData` hay `ArticleData`.  
Tất cả đã migrate sang `DestinationDataProvider` và `ArticleDataProvider`.

---

## 📁 File đang sử dụng

### 1️⃣ **DestinationDataProvider** ✅ ĐANG DÙNG

| File | Đường dẫn | Methods sử dụng |
|------|-----------|-----------------|
| **popular_destinations_widget.dart** | `lib/representation/widgets/` | `getPopularDestinations()` |
| **like_screen.dart** | `lib/representation/screen/` | `getDefaultFavoriteIds()`<br>`getDestinationsByIds()`<br>`filterByCategory()` |

**Chi tiết sử dụng:**

#### `popular_destinations_widget.dart`
```dart
import 'package:flutter_travels_apps/data/mock/destination_data_provider.dart';

class PopularDestinationsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final popularDestinations = DestinationDataProvider.getPopularDestinations();
    // Hiển thị danh sách destinations phổ biến
  }
}
```
**Mục đích:** Hiển thị danh sách điểm đến phổ biến trên home screen

---

#### `like_screen.dart`
```dart
import 'package:flutter_travels_apps/data/mock/destination_data_provider.dart';

class _LikeScreenState extends State<LikeScreen> {
  late Set<String> _likedPlaceIds;

  @override
  void initState() {
    // 1. Load IDs mặc định
    _likedPlaceIds = DestinationDataProvider.getDefaultFavoriteIds();
  }

  // 2. Lấy full objects từ IDs
  List<PopularDestination> get _likedPlaces => 
      DestinationDataProvider.getDestinationsByIds(_likedPlaceIds);

  // 3. Filter theo category (Việt Nam/Biển/Núi)
  Widget build(BuildContext context) {
    final filtered = DestinationDataProvider.filterByCategory(
      _likedPlaces, 
      chips[filterIndex]
    );
  }
}
```
**Mục đích:** Quản lý danh sách địa điểm yêu thích với filter

---

### 2️⃣ **ArticleDataProvider** ✅ ĐANG DÙNG

| File | Đường dẫn | Methods sử dụng |
|------|-----------|-----------------|
| **article_widgets.dart** | `lib/representation/widgets/` | `getFeaturedArticles()` |
| **like_screen.dart** | `lib/representation/screen/` | `getDefaultFavoriteIds()`<br>`getArticlesByIds()`<br>`filterByCategory()` |

**Chi tiết sử dụng:**

#### `article_widgets.dart`
```dart
import 'package:flutter_travels_apps/data/mock/article_data_provider.dart';

class FeaturedArticlesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final articles = ArticleDataProvider.getFeaturedArticles();
    // Hiển thị danh sách bài viết nổi bật
  }
}
```
**Mục đích:** Hiển thị danh sách bài viết featured trên home screen

---

#### `like_screen.dart`
```dart
import 'package:flutter_travels_apps/data/mock/article_data_provider.dart';

class _LikeScreenState extends State<LikeScreen> {
  late Set<String> _likedArticleIds;

  @override
  void initState() {
    // 1. Load IDs mặc định
    _likedArticleIds = ArticleDataProvider.getDefaultFavoriteIds();
  }

  // 2. Lấy full objects từ IDs
  List<FeaturedArticle> get _likedArticles => 
      ArticleDataProvider.getArticlesByIds(_likedArticleIds);

  // 3. Filter theo category (Ẩm thực)
  Widget build(BuildContext context) {
    final filtered = ArticleDataProvider.filterByCategory(
      _likedArticles, 
      chips[filterIndex]
    );
  }
}
```
**Mục đích:** Quản lý danh sách bài viết yêu thích với filter

---

### 3️⃣ **DestinationData** ❌ ĐÃ XÓA

**Status:** File đã bị xóa hoàn toàn (không còn deprecated files)

---

### 4️⃣ **ArticleData** ❌ ĐÃ XÓA

**Status:** File đã bị xóa hoàn toàn (không còn deprecated files)

---

## 📈 Thống kê sử dụng

### DestinationDataProvider
- **Tổng số file:** 2 files
- **Widgets:** 1 file (`popular_destinations_widget.dart`)
- **Screens:** 1 file (`like_screen.dart`)
- **Methods được dùng:**
  - ✅ `getPopularDestinations()` - 1 lần
  - ✅ `getDefaultFavoriteIds()` - 1 lần  
  - ✅ `getDestinationsByIds()` - 1 lần
  - ✅ `filterByCategory()` - 1 lần
  - ❌ `getDestinationsByCountry()` - CHƯA DÙNG
  - ❌ `searchDestinations()` - CHƯA DÙNG
  - ❌ `getTopRatedDestinations()` - CHƯA DÙNG

### ArticleDataProvider
- **Tổng số file:** 2 files
- **Widgets:** 1 file (`article_widgets.dart`)
- **Screens:** 1 file (`like_screen.dart`)
- **Methods được dùng:**
  - ✅ `getFeaturedArticles()` - 1 lần
  - ✅ `getDefaultFavoriteIds()` - 1 lần
  - ✅ `getArticlesByIds()` - 1 lần
  - ✅ `filterByCategory()` - 1 lần
  - ❌ `getArticlesByCategory()` - CHƯA DÙNG
  - ❌ `searchArticles()` - CHƯA DÙNG

---

## 🎯 Cơ hội tối ưu thêm

### 1. Các file có thể sử dụng nhưng chưa dùng

#### `home_screen.dart`
**Hiện tại:** Chưa rõ cách load data  
**Nên dùng:** `DestinationDataProvider.getPopularDestinations()`

#### `search_screen.dart` (nếu có)
**Hiện tại:** Chưa có  
**Nên dùng:** 
- `DestinationDataProvider.searchDestinations(query)`
- `ArticleDataProvider.searchArticles(query)`

#### `filter_screen.dart` (nếu có)
**Hiện tại:** Chưa có  
**Nên dùng:** 
- `DestinationDataProvider.getDestinationsByCountry(country)`
- `ArticleDataProvider.getArticlesByCategory(category)`

---

## 🔄 Migration Status

| Component | Old File | New File | Status |
|-----------|----------|----------|--------|
| Popular Destinations Widget | ❌ | ✅ Provider | DONE |
| Featured Articles Widget | ❌ | ✅ Provider | DONE |
| Like Screen - Destinations | ❌ | ✅ Provider | DONE |
| Like Screen - Articles | ❌ | ✅ Provider | DONE |

**Migration Progress:** 100% ✅

---

## 🚀 Kế hoạch tiếp theo

### Phase 1: Kiểm tra các screen khác
```bash
# Tìm các screen có thể dùng mock data nhưng chưa dùng
- home_screen.dart
- map_screen.dart  
- accommodation_list_screen.dart
```

### Phase 2: Thêm search/filter functionality
```dart
// Có sẵn methods nhưng chưa có UI
- searchDestinations(query)
- searchArticles(query)
- getDestinationsByCountry(country)
- getArticlesByCategory(category)
```

### Phase 3: Migrate sang Firebase
```dart
// Khi Firebase ready
DestinationDataProvider → DestinationService (Firestore)
ArticleDataProvider → ArticleService (Firestore)
```

---

## 📝 Notes

- ✅ **DestinationData** và **ArticleData** đã bị XÓA hoàn toàn
- ✅ Toàn bộ code hiện tại dùng `DestinationDataProvider` và `ArticleDataProvider`
- ✅ Không còn file deprecated, codebase sạch sẽ
- ⚠️ Nếu merge code từ nhánh cũ, cần cập nhật import statements
