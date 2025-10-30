import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:flutter/foundation.dart' show kIsWeb;
>>>>>>> 72ffec4 (Initial commit)
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/helpers/local_storage_helper.dart';
import 'package:flutter_travels_apps/representation/screen/splash_screen.dart';
import 'package:flutter_travels_apps/routes.dart';
import 'package:hive_flutter/hive_flutter.dart';
<<<<<<< HEAD
void main() async {
  await Hive.initFlutter();
  await LocalStorageHelper.initLocalStorageHelper();
=======
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase cho web
  if (kIsWeb) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      debugPrint('Firebase initialization error: $e');
    }
  }

  // Khởi tạo Hive (có thể không hoạt động tốt trên web, nên chỉ init khi không phải web)
  if (!kIsWeb) {
    await Hive.initFlutter();
  }

  await LocalStorageHelper.initLocalStorageHelper();

  // Thiết lập orientation portrait cho mobile
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

>>>>>>> 72ffec4 (Initial commit)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel App',
      theme: ThemeData(
<<<<<<< HEAD
          primaryColor: ColorPalette.primaryColor,
          scaffoldBackgroundColor: ColorPalette.backgroundScaffoldColor,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
=======
        primaryColor: ColorPalette.primaryColor,
        scaffoldBackgroundColor: ColorPalette.backgroundScaffoldColor,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
>>>>>>> 72ffec4 (Initial commit)
      ),
      routes: routes,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
