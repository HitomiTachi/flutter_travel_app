# Hướng Dẫn Giải Quyết Lỗi INSTALL_FAILED_INSUFFICIENT_STORAGE

## Lỗi
```
Error: ADB exited with exit code 1
adb.exe: failed to install ...: Failure [INSTALL_FAILED_INSUFFICIENT_STORAGE: Failed to override installation location]
```

Lỗi này xảy ra khi Android emulator không có đủ dung lượng lưu trữ để cài đặt ứng dụng.

## Cách Giải Quyết

### Cách 1: Chạy Script Tự Động (Khuyến nghị)

1. Mở PowerShell trong thư mục dự án
2. Chạy script:
```powershell
.\fix_storage_issue.ps1
```

Script này sẽ tự động:
- Gỡ cài đặt ứng dụng cũ (nếu có)
- Xóa cache
- Kiểm tra dung lượng còn lại

Sau đó chạy lại:
```powershell
flutter run
```

### Cách 2: Gỡ Cài Đặt Thủ Công

1. Tìm đường dẫn adb.exe trong Android SDK:
   - Thường là: `%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe`
   - Hoặc: `%ANDROID_HOME%\platform-tools\adb.exe`

2. Mở Command Prompt hoặc PowerShell và chạy:
```powershell
adb shell pm uninstall com.example.flutter_travels_apps
```

3. Sau đó chạy lại ứng dụng:
```powershell
flutter run
```

### Cách 3: Tăng Dung Lượng Emulator

1. Mở **Android Studio**
2. Vào **Tools > Device Manager** (hoặc AVD Manager)
3. Chọn emulator bạn đang dùng, click **Edit** (biểu tượng bút chì)
4. Click **Show Advanced Settings**
5. Tăng **Internal Storage** lên ít nhất **4096 MB** (4 GB)
6. Click **Finish**
7. Cold Boot lại emulator (Wipe Data nếu cần)

### Cách 4: Xóa Dữ Liệu Emulator

**Lưu ý:** Cách này sẽ xóa tất cả dữ liệu trên emulator!

1. Trong Android Studio > AVD Manager
2. Chọn emulator > **Wipe Data**
3. Khởi động lại emulator

### Cách 5: Xóa Các Ứng Dụng Khác Trên Emulator

1. Mở emulator
2. Vào **Settings > Apps**
3. Gỡ cài đặt các ứng dụng không cần thiết để giải phóng dung lượng

### Cách 6: Tạo Emulator Mới Với Dung Lượng Lớn Hơn

1. Android Studio > AVD Manager
2. Click **Create Device**
3. Chọn device profile
4. Trong phần **Show Advanced Settings**:
   - Internal Storage: **4096 MB** trở lên
   - SD Card: **512 MB** (tùy chọn)
5. Hoàn tất và chạy emulator mới

## Kiểm Tra Dung Lượng Còn Lại

Sau khi chạy script hoặc gỡ cài đặt, bạn có thể kiểm tra dung lượng:

```powershell
adb shell df /data
```

Hoặc:

```powershell
adb shell pm list packages | findstr travel
```

## Lưu Ý

- Thường xuyên dọn dẹp build cache bằng: `flutter clean`
- Khuyến nghị tối thiểu: **2 GB** dung lượng trống cho development
- Nếu vẫn gặp lỗi, thử tạo emulator mới với dung lượng lớn hơn

## Liên Hệ

Nếu vẫn gặp vấn đề sau khi thử các cách trên, hãy:
1. Kiểm tra log chi tiết: `flutter run -v`
2. Xem dung lượng ổ cứng máy tính còn đủ không
3. Thử trên thiết bị thật thay vì emulator

