import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
// import 'package:flutter_travels_apps/core/helpers/asset_helper.dart'; // <-- Không cần thiết nữa
import 'package:flutter_travels_apps/core/helpers/images_helpers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Đảm bảo đường dẫn này đúng với cấu trúc dự án của bạn
import 'package:flutter_travels_apps/services/auth_service.dart'; 
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // --- HÀM ĐĂNG NHẬP EMAIL ---
  Future<void> _signIn() async {
    if (!mounted) return;
    setState(() { _isLoading = true; });

    final authService = context.read<AuthService>();

    try {
      await authService.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      // AuthWrapper sẽ tự động điều hướng
      // (Không cần 'if (!mounted) return;' ở đây vì không có code nào chạy sau await)
    } on FirebaseAuthException catch (e) {
      if (!mounted) return; // <-- SỬA LỖI MOUNTED
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Đăng nhập thất bại"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (!mounted) return; // <-- SỬA LỖI MOUNTED
      setState(() { _isLoading = false; });
    }
  }

  // --- HÀM ĐĂNG NHẬP KHÁCH (Thêm lại) ---
  Future<void> _signInAsGuest() async {
    if (!mounted) return;
    setState(() { _isLoading = true; });

    final authService = context.read<AuthService>();

    try {
      await authService.signInAnonymously();
      // AuthWrapper sẽ tự động điều hướng
    } on FirebaseAuthException catch (e) {
      if (!mounted) return; // <-- SỬA LỖI MOUNTED
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Đăng nhập khách thất bại"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (!mounted) return; // <-- SỬA LỖI MOUNTED
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sử dụng màu nền chung của dự án
      backgroundColor: ColorPalette.backgroundScaffoldColor,
      // Dùng SingleChildScrollView để tránh lỗi khi bàn phím hiện lên
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: kMediumPadding * 1.5),
          // Canh giữa nội dung theo chiều dọc
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Logo
              Center(
                child: ImageHelper.loadFromAsset(
                  'assets/images/Splash_Logo.png', // <-- Cập nhật đường dẫn logo
                  height: 180,
                  width: 180,
                ),
              ),
              const SizedBox(height: kDefaultPadding),

              // 2. Tiêu đề
              const Text(
                'Chào mừng trở lại!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.primaryColor,
                ),
              ),
              const SizedBox(height: kDefaultPadding / 2),
              Text(
                'Đăng nhập để tiếp tục',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: kMediumPadding * 1.5),

              // 3. Form Email
              _buildTextField(
                controller: _emailController,
                hintText: 'Email',
                icon: FontAwesomeIcons.envelope,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: kDefaultPadding),

              // 4. Form Mật khẩu
              _buildTextField(
                controller: _passwordController,
                hintText: 'Mật khẩu',
                icon: FontAwesomeIcons.lock,
                isPassword: true,
              ),
              const SizedBox(height: kMediumPadding * 1.5),

              // 5. Nút Đăng nhập
              ElevatedButton(
                // Tắt nút khi đang loading
                onPressed: _isLoading ? null : _signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kDefaultPadding),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Đăng nhập",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
              ),
              const SizedBox(height: kDefaultPadding),

              // 6. Nút Đăng nhập Khách
              OutlinedButton(
                onPressed: _isLoading ? null : _signInAsGuest,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: ColorPalette.primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kDefaultPadding),
                  ),
                ),
                child: Text(
                  "Đăng nhập Khách",
                  style: TextStyle(
                    color: ColorPalette.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const SizedBox(height: kMediumPadding),

              // 7. Nút Đăng ký
              TextButton(
                onPressed: _isLoading ? null : () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RegisterScreen(),
                  ));
                },
                child: const Text(
                  "Chưa có tài khoản? Đăng ký",
                  style: TextStyle(
                    color: ColorPalette.primaryColor,
                    fontSize: 15,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper để tạo TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          icon,
          color: ColorPalette.primaryColor,
          size: 20,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kDefaultPadding),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kDefaultPadding),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kDefaultPadding),
          borderSide: const BorderSide(color: ColorPalette.primaryColor, width: 2),
        ),
      ),
    );
  }
}


