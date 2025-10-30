import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/helpers/accommodation_selection_helper.dart';
import 'package:flutter_travels_apps/representation/screen/home_screen.dart';
import 'package:flutter_travels_apps/representation/screen/like_screen.dart';
import 'package:flutter_travels_apps/representation/screen/map_screen.dart';
<<<<<<< HEAD
import 'package:flutter_travels_apps/representation/screen/trip_creation_screen.dart';
=======
>>>>>>> 72ffec4 (Initial commit)
import 'package:flutter_travels_apps/representation/screen/profile_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

<<<<<<< HEAD

class MainApp extends StatefulWidget {
  const MainApp ({Key? key}) :super(key: key);
=======
class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);
>>>>>>> 72ffec4 (Initial commit)

  static const routeName = 'main_app';

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
<<<<<<< HEAD

  int _currentIndex = 0;
  int _tripCreationRefreshKey = 0;
=======
  int _currentIndex = 0;
>>>>>>> 72ffec4 (Initial commit)

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Lắng nghe khi user quay về từ accommodation details
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForAccommodationSelection();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _checkForAccommodationSelection();
    }
  }

  void _checkForAccommodationSelection() {
    // Kiểm tra nếu có accommodation được chọn và cần navigate về trip creation
    if (AccommodationSelectionHelper.shouldNavigateToTripCreation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _currentIndex = 2; // Chuyển về tab kế hoạch
<<<<<<< HEAD
            _tripCreationRefreshKey++; // Refresh TripCreationScreen
=======
>>>>>>> 72ffec4 (Initial commit)
          });
          AccommodationSelectionHelper.markNavigationHandled(); // Đánh dấu đã xử lý
        }
      });
    }
  }

  @override
<<<<<<< HEAD
  Widget build(BuildContext context){
    // Kiểm tra accommodation selection mỗi lần build
    _checkForAccommodationSelection();
    
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(),
          MapScreen(),
          LikeScreen(),
          // TripCreationScreen(key: ValueKey(_tripCreationRefreshKey)),
          ProfileScreen(),
        ],
=======
  Widget build(BuildContext context) {
    // Kiểm tra accommodation selection mỗi lần build
    _checkForAccommodationSelection();

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [HomeScreen(), MapScreen(), LikeScreen(), ProfileScreen()],
>>>>>>> 72ffec4 (Initial commit)
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
<<<<<<< HEAD
            // Trigger refresh cho TripCreationScreen nếu tab được chọn là tab 2
            if (index == 2) {
              _tripCreationRefreshKey++;
            }
=======
>>>>>>> 72ffec4 (Initial commit)
          });
        },
        selectedItemColor: ColorPalette.primaryColor,
        unselectedItemColor: ColorPalette.primaryColor.withOpacity(0.2),
<<<<<<< HEAD
        margin: EdgeInsets.symmetric(horizontal: kMediumPadding, vertical: kDefaultPadding),
        items: [
          SalomonBottomBarItem(
            icon: Icon(FontAwesomeIcons.house,
              size: kDefaultIconSize,
            ),
            title: Text('Trang chủ'),
          ),
          SalomonBottomBarItem(
            icon: Icon(FontAwesomeIcons.map,
              size: kDefaultIconSize,
            ),
            title: Text('Bản đồ'),
          ),
          SalomonBottomBarItem(
            icon: Icon(FontAwesomeIcons.solidHeart,
              size: kDefaultIconSize,
            ),
            title: Text('Khám phá'),
          ),
          SalomonBottomBarItem(
            icon: Icon(FontAwesomeIcons.solidUser,
              size: kDefaultIconSize,
            ),
=======
        margin: EdgeInsets.symmetric(
          horizontal: kMediumPadding,
          vertical: kDefaultPadding,
        ),
        items: [
          SalomonBottomBarItem(
            icon: Icon(FontAwesomeIcons.house, size: kDefaultIconSize),
            title: Text('Trang chủ'),
          ),
          SalomonBottomBarItem(
            icon: Icon(FontAwesomeIcons.map, size: kDefaultIconSize),
            title: Text('Bản đồ'),
          ),
          SalomonBottomBarItem(
            icon: Icon(FontAwesomeIcons.solidHeart, size: kDefaultIconSize),
            title: Text('Khám phá'),
          ),
          SalomonBottomBarItem(
            icon: Icon(FontAwesomeIcons.solidUser, size: kDefaultIconSize),
>>>>>>> 72ffec4 (Initial commit)
            title: Text('Hồ sơ'),
          ),
        ],
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 72ffec4 (Initial commit)
