import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/helpers/local_storage_helper.dart';
import 'package:flutter_travels_apps/representation/screen/splash_screen.dart';
import 'package:flutter_travels_apps/routes.dart';
import 'package:hive_flutter/hive_flutter.dart';
void main() async {
  await Hive.initFlutter();
  await LocalStorageHelper.initLocalStorageHelper();
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
          primaryColor: ColorPalette.primaryColor,
          scaffoldBackgroundColor: ColorPalette.backgroundScaffoldColor,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: routes,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
