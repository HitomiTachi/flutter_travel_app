// lib/representation/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/core/helpers/images_helpers.dart';
import 'package:flutter_travels_apps/core/helpers/local_storage_helper.dart';
import 'package:flutter_travels_apps/representation/screen/intro_screen.dart';
import 'package:flutter_travels_apps/representation/screen/main_app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String routeName = '/splash_screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    representation();
  }

  void representation() async{
    final ignoreIntroScreen = LocalStorageHelper.getValue('ignoreIntroScreen') as bool?;
    await Future.delayed(const Duration(microseconds: 2000));
    if(ignoreIntroScreen != null && ignoreIntroScreen){
      Navigator.of(context).pushNamed(MainApp.routeName);
    }else{
      LocalStorageHelper.setValue('ignoreIntroScreen', true);
      Navigator.of(context).pushNamed(IntroScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Nền splash (phủ full màn hình)
          Positioned.fill(
            child: ImageHelper.loadFromAsset(
              AssetHelper.imageBackGroundSplash,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
          // Hình tròn/logo ở giữa
          Positioned.fill(
            child: Center(
              child: ImageHelper.loadFromAsset(
                AssetHelper.imageCircleSplash,
                width: 220,
                height: 220,
                fit: BoxFit.contain,
                radius: BorderRadius.circular(999),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
