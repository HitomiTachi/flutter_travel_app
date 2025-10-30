import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_travels_apps/services/auth_service.dart'; 
// Thêm các import cho giao diện
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/helpers/images_helpers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // THÊM MỚI: Controller cho Tên
  final _nameController = TextEditingController(); 
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    if (!mounted) return;
    setState(() { _isLoading = true; });

    final authService = context.read<AuthService>();

    try {
      // THAY ĐỔI: Truyền thêm _nameController.text
      await authService.registerWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(), // *** Thêm tham số name ***
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return; // <-- SỬA LỖI MOUNTED
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Đăng ký thất bại"),
          backgroundColor: Colors.red, // Thêm màu cho dễ thấy
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
      backgroundColor: ColorPalette.backgroundScaffoldColor,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: kMediumPadding * 1.5),
          // Dùng constraints để đảm bảo nội dung canh giữa ngay cả khi
          // bàn phím không che hết
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Logo
              Center(
                child: ImageHelper.loadFromAsset(
                  'assets/images/Splash_Logo.png', 
                  height: 150, // Nhỏ hơn một chút so với login
                  width: 150,
                ),
              ),
              const SizedBox(height: kDefaultPadding),

              // 2. Tiêu đề
              const Text(
                'Tạo tài khoản', // <-- Đổi tiêu đề
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.primaryColor,
                ),
              ),
              const SizedBox(height: kDefaultPadding / 2),
              Text(
                'Bắt đầu hành trình của bạn', // <-- Đổi phụ đề
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: kMediumPadding * 1.5),

              // 3. Form Tên
              _buildTextField(
                controller: _nameController,
                hintText: 'Tên hiển thị',
                icon: FontAwesomeIcons.user,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: kDefaultPadding),

              // 4. Form Email
              _buildTextField(
                controller: _emailController,
                hintText: 'Email',
                icon: FontAwesomeIcons.envelope,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: kDefaultPadding),

              // 5. Form Mật khẩu
              _buildTextField(
                controller: _passwordController,
                hintText: 'Mật khẩu (tối thiểu 6 ký tự)',
                icon: FontAwesomeIcons.lock,
                isPassword: true,
              ),
              const SizedBox(height: kMediumPadding * 1.5),
              
              // 6. Nút Đăng ký
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
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
                        "Đăng ký",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
              ),
              const SizedBox(height: kMediumPadding),

              // 7. Nút Quay lại Đăng nhập
              TextButton(
                onPressed: _isLoading ? null : () {
                  Navigator.of(context).pop(); // Quay lại màn hình trước
                },
                child: const Text(
                  "Đã có tài khoản? Đăng nhập",
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
