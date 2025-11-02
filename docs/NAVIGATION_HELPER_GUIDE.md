# Hướng Dẫn Sử Dụng NavigationHelper

## Vấn Đề Đã Giải Quyết

### Vấn Đề 1: Navigation Map từ Home Screen
**Trước đây:**
- Khi nhấn nút Map từ Home Screen → Push một MapScreen mới → **KHÔNG CÓ bottom navigation bar**
- Khi nhấn nút Map từ Bottom Nav → Chuyển tab trong IndexedStack → **CÓ bottom navigation bar**

**Bây giờ:**
- Cả hai cách đều **chuyển tab** trong MainApp → **LUÔN CÓ bottom navigation bar**

### Vấn Đề 2: Navigation "Xem thêm" từ Địa điểm/Bài viết Phổ biến
**Trước đây:**
- Nhấn "Xem thêm" từ Home → Push LikeScreen mới → **KHÔNG CÓ bottom nav**
- Nhấn tab Like từ Bottom Nav → Chuyển tab → **CÓ bottom nav**

**Bây giờ:**
- Nhấn "Xem thêm" → **Chuyển tab Like** với arguments (initialTab, showAll) → **LUÔN CÓ bottom nav**
- Navigation thống nhất và nhất quán trong toàn bộ app

## Cách Hoạt Động

### 1. NavigationHelper (Singleton Pattern)

`NavigationHelper` là một class quản lý việc chuyển tab trong MainApp với hỗ trợ arguments:

```dart
// Chuyển tab đơn giản
NavigationHelper().goToMap();      // Chuyển đến tab Map
NavigationHelper().goToHome();     // Chuyển đến tab Home
NavigationHelper().goToProfile();  // Chuyển đến tab Profile

// Chuyển tab Like với arguments
NavigationHelper().goToLike();     // Chuyển đến tab Like (default)
NavigationHelper().goToLike(
  initialTab: 0,    // Tab con: 0=Địa điểm, 1=Bài viết, 2=Kế hoạch
  showAll: true,    // Hiển thị tất cả thay vì chỉ favorites
);
```

### 2. Cấu Trúc Tab Index

**Tab chính (MainApp):**
```dart
0 = Home Tab
1 = Map Tab
2 = Like Tab
3 = Profile Tab
```

**Tab con trong LikeScreen:**
```dart
0 = Địa điểm
1 = Bài viết
2 = Kế hoạch chuyến đi
```

## Cách Sử Dụng Trong Code

### 1. Navigation Đơn Giản (Không Arguments)

```dart
import 'package:flutter_travels_apps/core/helpers/navigation_helper.dart';

// Trong một GestureDetector hoặc Button
onTap: () {
  NavigationHelper().goToMap(); // Chuyển đến tab Map
}
```

### 2. Navigation Với Arguments (LikeScreen)

```dart
// Ví dụ: Từ nút "Xem thêm" của Địa điểm Phổ biến
TextButton(
  onPressed: () {
    NavigationHelper().goToLike(
      initialTab: 0,    // Mở tab Địa điểm
      showAll: true,    // Hiển thị tất cả địa điểm
    );
  },
  child: Text('Xem thêm'),
)

// Ví dụ: Từ nút "Xem thêm" của Bài viết Phổ biến
TextButton(
  onPressed: () {
    NavigationHelper().goToLike(
      initialTab: 1,    // Mở tab Bài viết
      showAll: true,    // Hiển thị tất cả bài viết
    );
  },
  child: Text('Xem thêm'),
)
```

### Ví Dụ Thực Tế

#### 1. Trong HomeScreen - Nút Map

```dart
_buildItemCategory(
  ImageHelper.loadFromAsset(AssetHelper.icoMap, ...),
  Colors.green,
  () {
    NavigationHelper().goToMap(); // ✅ Chuyển tab thay vì push screen
  },
  'Bản đồ',
)
```

#### 2. Trong PopularDestinationsWidget - Nút "Xem thêm"

```dart
TextButton(
  onPressed: () {
    NavigationHelper().goToLike(initialTab: 0, showAll: true);
    // ✅ Chuyển đến tab Like, mở tab con Địa điểm, hiển thị tất cả
  },
  child: Text('Xem thêm'),
)
```

#### 3. Trong FeaturedArticlesWidget - Nút "Xem thêm"

```dart
TextButton(
  onPressed: () {
    NavigationHelper().goToLike(initialTab: 1, showAll: true);
    // ✅ Chuyển đến tab Like, mở tab con Bài viết, hiển thị tất cả
  },
  child: Text('Xem thêm'),
)
```

**Thay vì cách cũ:**

```dart
// ❌ KHÔNG DÙNG NỮA - Push screen mới, mất bottom nav
onTap: () {
  Navigator.pushNamed(
    context, 
    '/map_screen',  // hoặc LikeScreen.routeName
    arguments: {...},
  );
}
```

## Lợi Ích

### 1. **Thống Nhất UI/UX**
   - Bottom navigation bar luôn hiển thị
   - User có thể dễ dàng chuyển đổi giữa các screen
   - Không bị "lạc" trong navigation stack

### 2. **Dễ Bảo Trì**
   - Tập trung logic navigation ở một nơi
   - Thay đổi tab index chỉ cần sửa ở `NavigationHelper`
   - Không cần import screen class trong widgets

### 3. **Tránh Lỗi**
   - Không tạo duplicate screens
   - Không bị mất state khi chuyển tab
   - Arguments được truyền đúng cách

### 4. **Dễ Mở Rộng**
   - Thêm tab mới chỉ cần thêm constant và method
   - Thêm arguments mới cho screen dễ dàng
   - Không cần sửa nhiều nơi

### 5. **Performance**
   - Sử dụng IndexedStack - giữ state của tất cả tabs
   - Không tạo mới screen mỗi lần navigation
   - Smooth transitions giữa các tabs

## Khi Nào Nên Dùng

### ✅ Sử Dụng NavigationHelper Khi:
- Muốn chuyển đến một trong các tab chính (Home, Map, Like, Profile)
- Muốn giữ bottom navigation bar visible
- Navigation trong cùng một context của MainApp

### ❌ KHÔNG Sử Dụng NavigationHelper Khi:
- Mở screen chi tiết (detail screen) - dùng `Navigator.pushNamed()`
- Mở modal/dialog
- Navigation đến screen ngoài MainApp (Login, Onboarding, etc.)

## Ví Dụ Áp Dụng Thêm

### 1. Từ Profile Screen chuyển về Home

```dart
ElevatedButton(
  onPressed: () {
    NavigationHelper().goToHome();
  },
  child: Text('Về Trang Chủ'),
)
```

### 2. Từ Detail Screen chuyển đến tab Like với filter

```dart
// Sau khi xem chi tiết một destination, muốn xem thêm địa điểm khác
ElevatedButton(
  onPressed: () {
    Navigator.pop(context); // Đóng detail screen
    NavigationHelper().goToLike(
      initialTab: 0,    // Tab Địa điểm
      showAll: true,    // Xem tất cả
    );
  },
  child: Text('Khám phá thêm địa điểm'),
)
```

### 3. Từ Search Screen khi tìm thấy kết quả

```dart
// User tìm kiếm "bài viết về Phú Quốc"
// Chuyển đến Like tab hiển thị tất cả bài viết
IconButton(
  icon: Icon(Icons.article),
  onPressed: () {
    NavigationHelper().goToLike(
      initialTab: 1,    // Tab Bài viết
      showAll: true,
    );
  },
)
```

### 4. Kết hợp với Navigation thông thường

```dart
// Mở detail screen TRƯỚC
Navigator.pushNamed(context, '/destination_detail');

// Từ detail screen, có thể quay về và chuyển tab
ElevatedButton(
  onPressed: () {
    Navigator.pop(context);              // Đóng detail
    NavigationHelper().goToMap();        // Chuyển tab Map
  },
  child: Text('Xem trên bản đồ'),
)
```

## Lưu Ý Kỹ Thuật

### 1. Singleton Pattern
- Chỉ có một instance duy nhất trong toàn app
- Truy cập qua `NavigationHelper()`

### 2. Callback Registration
- MainApp đăng ký callback trong `initState()`
- Callback nhận 2 tham số: `(int index, Map<String, dynamic>? arguments)`
- Hủy đăng ký trong `dispose()`

### 3. State Management
- Sử dụng `setState()` trong MainApp để cập nhật UI
- IndexedStack giữ state của tất cả tabs
- ValueKey để force rebuild khi có arguments mới

### 4. Arguments Handling
- LikeScreen nhận arguments qua 2 cách:
  1. Từ widget constructor (khi dùng NavigationHelper)
  2. Từ ModalRoute (khi dùng Navigator.pushNamed - backward compatible)
- Priority: Widget arguments > Route arguments

### 5. Mounted Check
- Luôn kiểm tra `mounted` trước khi gọi `setState()`
- Tránh lỗi khi widget đã bị dispose

## Troubleshooting

### 1. NavigationHelper không hoạt động?

**Nguyên nhân:** MainApp chưa đăng ký callback

**Giải pháp:** Đảm bảo trong `main_app.dart`:

```dart
@override
void initState() {
  super.initState();
  NavigationHelper().registerTabChangeCallback((index, arguments) {
    if (mounted) {
      setState(() {
        _currentIndex = index;
        
        // Xử lý arguments nếu có
        if (index == NavigationHelper.likeTab && arguments != null) {
          _likeScreenArguments = arguments;
          _likeScreenRefreshKey++;
        }
      });
    }
  });
}

@override
void dispose() {
  NavigationHelper().unregisterTabChangeCallback();
  super.dispose();
}
```

### 2. Arguments không được apply?

**Nguyên nhân:** LikeScreen không nhận arguments từ widget

**Giải pháp:** Đảm bảo LikeScreen được khởi tạo đúng:

```dart
// Trong MainApp build method
LikeScreen(
  key: ValueKey(_likeScreenRefreshKey),
  arguments: _likeScreenArguments,
),
```

### 3. Tab chuyển nhưng không đúng nội dung?

**Nguyên nhân:** initialTab không được set đúng

**Giải pháp:** Kiểm tra `didChangeDependencies()` trong LikeScreen:

```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  
  // Priority: widget arguments > route arguments
  Map<String, dynamic>? args = widget.arguments;
  if (args == null) {
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
  }
  
  if (args != null) {
    if (args['initialTab'] != null) {
      _tabController.index = args['initialTab'];
    }
    if (args['showAll'] == true) {
      _showAll = true;
    }
  }
}
```

### 4. Bottom nav hiển thị nhưng không thể click?

**Nguyên nhân:** IndexedStack không được config đúng

**Giải pháp:** Kiểm tra onTap handler:

```dart
bottomNavigationBar: SalomonBottomBar(
  currentIndex: _currentIndex,
  onTap: (index) {
    setState(() {
      _currentIndex = index;
      // Reset arguments khi click trực tiếp tab
      if (index == NavigationHelper.likeTab) {
        _likeScreenArguments = null;
        _likeScreenRefreshKey++;
      }
    });
  },
  // ...
)
```

## Kiến Trúc & Flow

### Flow Diagram

```
User Action (Nhấn "Xem thêm")
         ↓
NavigationHelper().goToLike(initialTab: 0, showAll: true)
         ↓
Callback trong MainApp được gọi
         ↓
setState() → Update _currentIndex, _likeScreenArguments, _likeScreenRefreshKey
         ↓
IndexedStack hiển thị LikeScreen với ValueKey mới
         ↓
LikeScreen rebuild với arguments mới
         ↓
didChangeDependencies() → Apply initialTab & showAll
         ↓
TabController.index = 0, _showAll = true
         ↓
UI hiển thị đúng tab con với tất cả items
```

### Kiến Trúc Code

```
NavigationHelper (Singleton)
    ↓ registerCallback
MainApp (StatefulWidget)
    ├── Manages _currentIndex
    ├── Manages screen arguments
    └── IndexedStack
          ├── HomeScreen
          ├── MapScreen
          ├── LikeScreen (with arguments)
          └── ProfileScreen

Widgets (PopularDestinationsWidget, FeaturedArticlesWidget)
    ↓ NavigationHelper().goToLike()
    → Trigger tab change with arguments
```

## API Reference

### NavigationHelper Methods

```dart
// Chuyển đến tab chỉ định với arguments (low-level)
void navigateToTab(int tabIndex, {Map<String, dynamic>? arguments})

// Chuyển đến tab Home
void goToHome()

// Chuyển đến tab Map  
void goToMap()

// Chuyển đến tab Like với optional arguments
void goToLike({int? initialTab, bool? showAll})
// - initialTab: 0=Địa điểm, 1=Bài viết, 2=Kế hoạch (default: không set)
// - showAll: true=Hiển thị tất cả, false/null=Chỉ favorites (default: không set)

// Chuyển đến tab Profile
void goToProfile()

// Đăng ký callback (chỉ dùng trong MainApp)
void registerTabChangeCallback(Function(int, Map<String, dynamic>?) callback)

// Hủy đăng ký callback (chỉ dùng trong MainApp)
void unregisterTabChangeCallback()
```

### NavigationHelper Constants

```dart
static const int homeTab = 0;
static const int mapTab = 1;
static const int likeTab = 2;
static const int profileTab = 3;
```

### LikeScreen Arguments

```dart
{
  'initialTab': int,    // Optional: 0, 1, or 2
  'showAll': bool,      // Optional: true or false
}
```

## Kết Luận

`NavigationHelper` giúp bạn:
- ✅ Navigation nhất quán trong app
- ✅ Code dễ đọc, dễ maintain
- ✅ Tránh duplicate screens
- ✅ UX tốt hơn với bottom nav luôn hiển thị
- ✅ Hỗ trợ arguments cho các screen phức tạp
- ✅ Dễ dàng mở rộng thêm tính năng

**Best Practice:** 
- Luôn dùng `NavigationHelper` khi muốn chuyển giữa các tab chính trong MainApp
- Dùng `Navigator.pushNamed()` cho detail screens hoặc modal screens
- Truyền arguments qua NavigationHelper thay vì route parameters khi có thể
