import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/core/helpers/images_helpers.dart';
import 'package:flutter_travels_apps/core/helpers/navigation_helper.dart';
import 'package:flutter_travels_apps/representation/widgets/common/app_bar_container.dart';
import 'package:flutter_travels_apps/representation/widgets/homescreen_widgets/popular_destinations_widget.dart';
import 'package:flutter_travels_apps/representation/widgets/homescreen_widgets/article_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_travels_apps/representation/screen/global_search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'User';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Lấy thông tin từ Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        
        if (userDoc.exists) {
          final data = userDoc.data();
          setState(() {
            _userName = data?['name'] ?? (user.isAnonymous ? 'Khách' : 'User');
            _isLoading = false;
          });
        } else {
          setState(() {
            _userName = user.isAnonymous ? 'Khách' : 'User';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _userName = 'Khách';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _userName = 'User';
        _isLoading = false;
      });
    }
  }
  Widget _buildItemCategory(
    Widget icon,
    Color color,
    Function() onTap,
    String title,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 60,
              padding: EdgeInsets.symmetric(vertical: kMediumPadding),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(kItemPadding),
              ),
              child: Center(child: icon),
            ),
            SizedBox(height: kDefaultPadding / 2),
            Container(
              height: 32,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xin Chào!',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                  SizedBox(height: 4),
                  if (_isLoading)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  else
                    Text(
                      _userName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                // TODO: Navigate to notifications
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Chức năng thông báo sẽ được phát triển'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.2),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  FontAwesomeIcons.bell,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                // Sử dụng NavigationHelper để chuyển tab thay vì push screen mới
                NavigationHelper().goToProfile();
              },
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: ImageHelper.loadFromAsset(
                      AssetHelper.person,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      child: Column(
        children: [
          // Search TextField - Là một phần của AppBarContainerWidget (cố định)
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                GlobalSearchScreen.routeName,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kItemPadding),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Màu bóng dịu
                    blurRadius: 8, // Độ mờ
                    spreadRadius: 1, // Độ lan
                    offset: const Offset(0, 3), // Hướng bóng xuống dưới
                  ),
                ],
              ),
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm điểm đến ...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(kTopPadding),
                    child: Icon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: Colors.black,
                      size: kDefaultPadding,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(kItemPadding)),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(kItemPadding)),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: kItemPadding),
                ),
              ),
            ),
          ),

          // Content có thể cuộn - Categories và widgets khác
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: kDefaultPadding),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildItemCategory(
                          ImageHelper.loadFromAsset(
                            AssetHelper.iconlocation,
                            width: kBottomBarIconSize,
                            height: kBottomBarIconSize,
                          ),
                          Colors.blue,
                          () {
                            Navigator.of(
                              context,
                            ).pushNamed('/trip_plans_list_screen');
                          },
                          'Kế hoạch\nchuyến đi',
                        ),
                      ),
                      SizedBox(width: kDefaultPadding),
                      Expanded(
                        child: _buildItemCategory(
                          ImageHelper.loadFromAsset(
                            AssetHelper.icoMap,
                            width: kBottomBarIconSize,
                            height: kBottomBarIconSize,
                          ),
                          Colors.green,
                          () {
                            // Sử dụng NavigationHelper để chuyển tab thay vì push screen mới
                            NavigationHelper().goToMap();
                          },
                          'Bản đồ',
                        ),
                      ),
                      SizedBox(width: kDefaultPadding),
                      Expanded(
                        child: _buildItemCategory(
                          ImageHelper.loadFromAsset(
                            AssetHelper.allservices,
                            width: kBottomBarIconSize,
                            height: kBottomBarIconSize,
                          ),
                          Colors.orange,
                          () {},
                          'Tất cả dịch vụ',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: kTopPadding),
                  // Popular Destinations Section
                  PopularDestinationsWidget(),
                  SizedBox(height: kTopPadding),
                  // Featured Articles Section
                  FeaturedArticlesWidget(),
                  SizedBox(height: kTopPadding),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
