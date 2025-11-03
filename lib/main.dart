import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/helpers/local_storage_helper.dart';
import 'package:flutter_travels_apps/routes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_travels_apps/core/theme/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'representation/screen/auth_wrapper.dart'; // Import file AuthWrapper

void main() async {
  // Đảm bảo Flutter đã sẵn sàng
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Hive và LocalStorage
  await Hive.initFlutter();
  await LocalStorageHelper.initLocalStorageHelper();

  // Khởi tạo Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Lỗi khởi tạo Firebase: $e");
    // Vẫn tiếp tục chạy app, nhưng Firebase sẽ không hoạt động
  }

  // Bọc ứng dụng trong MultiProvider
  final themeProvider = ThemeProvider();
  await themeProvider.load();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        StreamProvider<User?>(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => themeProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      title: 'Travel App',
      theme: ThemeData(
        primaryColor: ColorPalette.primaryColor,
        scaffoldBackgroundColor: ColorPalette.backgroundScaffoldColor,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData.dark(useMaterial3: false),
      themeMode: themeProvider.themeMode,
      routes: routes, // Giữ nguyên bảng routes của bạn
      debugShowCheckedModeBanner: false,

      // THAY ĐỔI QUAN TRỌNG:
      // 'home' không còn là SplashScreen
      // 'home' bây giờ là AuthWrapper, nó sẽ quyết định
      // hiển thị SplashScreen, LoginScreen, hay HomeScreen
      home: AuthWrapper(),
    );
  }
}
