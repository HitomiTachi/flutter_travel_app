import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_travels_apps/services/auth_service.dart';

// Import các màn hình
import 'package:flutter_travels_apps/representation/screen/splash_screen.dart';
import 'login_screen.dart';
import 'package:flutter_travels_apps/representation/screen/main_app.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy AuthService từ Provider
    final authService = context.watch<AuthService>();

    return StreamBuilder<User?>(
      // Lắng nghe trực tiếp stream trạng thái đăng nhập
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // --- Trạng thái 1: Đang chờ ---
        // Khi Firebase đang kiểm tra token...
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Hiển thị SplashScreen khi đang khởi tạo Firebase
          return const SplashScreen();
        }

        // --- Trạng thái 2: Đã đăng nhập ---
        // Nếu snapshot có dữ liệu (User không null)
        if (snapshot.hasData && snapshot.data != null) {
          // --- THAY ĐỔI QUAN TRỌNG ---
          // 3. Hiển thị MainApp (có BottomNavBar) thay vì HomeScreen
          return const MainApp();
          // --- KẾT THÚC THAY ĐỔI ---
        }

        // --- Trạng thái 3: Đã đăng xuất ---
        // Nếu snapshot không có dữ liệu (User là null) hoặc có lỗi
        // Đi tới Trang đăng nhập
        return const LoginScreen();
      },
    );
  }
}
