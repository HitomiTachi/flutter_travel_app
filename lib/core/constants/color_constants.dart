// lib/constants/color_constants.dart
// ------------------------------------------------------
// 🎨 COLOR CONSTANTS & GRADIENTS
// - Chứa toàn bộ bảng màu dùng trong app
// - Dễ bảo trì, chỉ cần đổi 1 lần là áp dụng toàn app
// ------------------------------------------------------

import 'package:flutter/material.dart';

class ColorPalette {
  static const Color primaryColor = Color(0xFF6357CC); // 💜 Màu chính (tím đậm)
  static const Color secondColor = Color(0xFF8F67E8);  // 💜 Màu phụ (tím nhạt)
  static const Color yellowColor = Color(0xFFFE9C5E);  // 🧡 Accent (vàng cam)
  static const Color dividerColor = Color(0xFFE5E7EB); // 🩶 Đường chia (xám nhạt)
  
  static const Color textColor = Color(0xFF323848);    // 🖤 Màu chữ chính
  static const Color subTitleColor = Color(0xFF838383); // 🩶 Màu phụ đề
  static const Color backgroundScaffoldColor = Color(0xFFF2F2F2); // 🤍 Nền Scaffold
}

class Gradients {
  static const Gradient defaultGradientBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomLeft,
    colors: [
      ColorPalette.secondColor,
      ColorPalette.primaryColor,
    ],
  );
}
