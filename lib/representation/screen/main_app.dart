import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/representation/screen/home_screen.dart';
import 'package:flutter_travels_apps/representation/screen/trip_creation_screen.dart';
import 'package:flutter_travels_apps/representation/screen/profile_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';


class MainApp extends StatefulWidget {
  const MainApp ({Key? key}) :super(key: key);

  static const routeName = 'main_app';

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp>{

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(),
          Container(color: Colors.blue,),
          TripCreationScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: ColorPalette.primaryColor,
        unselectedItemColor: ColorPalette.primaryColor.withOpacity(0.2),
        margin: EdgeInsets.symmetric(horizontal: kMediumPadding, vertical: kDefaultPadding),
        items: [
          SalomonBottomBarItem(
            icon: Icon(FontAwesomeIcons.house,
              size: kDefaultIconSize,
            ),
            title: Text('Home'),
          ),
          SalomonBottomBarItem(
            icon: Icon(FontAwesomeIcons.solidHeart,
              size: kDefaultIconSize,
            ),
            title: Text('Like'),
          ),
          SalomonBottomBarItem(
            icon: Icon(FontAwesomeIcons.map,
              size: kDefaultIconSize,
            ),
            title: Text('Kế hoạch'),
          ),
          SalomonBottomBarItem(
            icon: Icon(FontAwesomeIcons.solidUser,
              size: kDefaultIconSize,
            ),
            title: Text('Profile'),
          ),
        ],
      ),
    );
  }
}