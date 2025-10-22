import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/helpers/accommodation_selection_helper.dart';
import 'package:flutter_travels_apps/representation/screen/home_screen.dart';
import 'package:flutter_travels_apps/representation/screen/like_screen.dart';
import 'package:flutter_travels_apps/representation/screen/map_screen.dart';
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

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {

  int _currentIndex = 0;
  int _tripCreationRefreshKey = 0;

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
            _tripCreationRefreshKey++; // Refresh TripCreationScreen
          });
          AccommodationSelectionHelper.markNavigationHandled(); // Đánh dấu đã xử lý
        }
      });
    }
  }

  @override
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
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            // Trigger refresh cho TripCreationScreen nếu tab được chọn là tab 2
            if (index == 2) {
              _tripCreationRefreshKey++;
            }
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
            title: Text('Hồ sơ'),
          ),
        ],
      ),
    );
  }
}