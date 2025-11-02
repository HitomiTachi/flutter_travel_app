# Navigation Helper - Hướng Dẫn Nhanh

## 🎯 Vấn Đề Đã Giải Quyết

### Trước khi có NavigationHelper:
❌ Nhấn "Map" từ Home → Push screen mới → **KHÔNG CÓ bottom nav**  
❌ Nhấn "Xem thêm Địa điểm" → Push screen mới → **KHÔNG CÓ bottom nav**  
❌ Nhấn "Xem thêm Bài viết" → Push screen mới → **KHÔNG CÓ bottom nav**  

### Sau khi có NavigationHelper:
✅ Tất cả đều chuyển tab → **LUÔN CÓ bottom nav**  
✅ UX nhất quán, không bị lạc trong navigation stack  
✅ Performance tốt hơn (không tạo duplicate screens)  

---

## 📖 Cách Sử Dụng

### 1. Import
```dart
import 'package:flutter_travels_apps/core/helpers/navigation_helper.dart';
```

### 2. Chuyển Tab Đơn Giản
```dart
NavigationHelper().goToHome();     // Về trang chủ
NavigationHelper().goToMap();      // Mở bản đồ
NavigationHelper().goToProfile();  // Mở hồ sơ
```

### 3. Chuyển Tab Like (Có Arguments)
```dart
// Mở tab Địa điểm, hiển thị tất cả
NavigationHelper().goToLike(initialTab: 0, showAll: true);

// Mở tab Bài viết, hiển thị tất cả  
NavigationHelper().goToLike(initialTab: 1, showAll: true);

// Mở tab Kế hoạch, chỉ favorites
NavigationHelper().goToLike(initialTab: 2);
```

---

## 🔢 Tab Index Reference

### Tab Chính (MainApp):
- `0` = Home
- `1` = Map  
- `2` = Like
- `3` = Profile

### Tab Con (LikeScreen):
- `0` = Địa điểm
- `1` = Bài viết
- `2` = Kế hoạch

---

## ✅ Khi Nào Dùng NavigationHelper?

✅ Chuyển đến các tab chính: Home, Map, Like, Profile  
✅ Muốn giữ bottom navigation bar visible  
✅ Navigation trong cùng MainApp context  

❌ KHÔNG dùng cho:
- Detail screens (dùng `Navigator.pushNamed()`)
- Modal/Dialog
- Screens ngoài MainApp (Login, Splash, etc.)

---

## 💡 Ví Dụ Thực Tế

### Nút "Xem thêm" trong Địa điểm Phổ biến
```dart
TextButton(
  onPressed: () {
    NavigationHelper().goToLike(initialTab: 0, showAll: true);
  },
  child: Text('Xem thêm'),
)
```

### Nút "Xem thêm" trong Bài viết Nổi bật
```dart
TextButton(
  onPressed: () {
    NavigationHelper().goToLike(initialTab: 1, showAll: true);
  },
  child: Text('Xem thêm'),
)
```

### Nút "Bản đồ" trong Home Screen
```dart
onTap: () {
  NavigationHelper().goToMap();
}
```

---

## 📚 Tài Liệu Đầy Đủ

Xem chi tiết tại: `docs/NAVIGATION_HELPER_GUIDE.md`

---

**Lưu ý:** NavigationHelper sử dụng Singleton pattern - chỉ có 1 instance duy nhất trong toàn app!
