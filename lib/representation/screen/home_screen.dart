import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/core/helpers/images_helpers.dart';
import 'package:flutter_travels_apps/core/helpers/navigation_helper.dart';
import 'package:flutter_travels_apps/representation/widgets/common/app_bar_container.dart';
import 'package:flutter_travels_apps/representation/widgets/homescreen_widgets/popular_destinations_widget.dart';
import 'package:flutter_travels_apps/representation/widgets/homescreen_widgets/article_widgets.dart';
import 'package:flutter_travels_apps/data/mock/destination_data_provider.dart';
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

  // ============================================================
  // METHOD HỖ TRỢ CHO "ĐỊA ĐIỂM YÊU THÍCH"
  // ============================================================
  Widget _buildFavoriteDestinationItem({
    required String imageUrl,
    required String name,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: ImageHelper.loadFromAsset(
                imageUrl,
                fit: BoxFit.cover,
                width: 70,
                height: 70,
              ),
            ),
          ),
          SizedBox(height: kTopPadding),
          SizedBox(
            width: 80,
            child: Text(
              name,
              style: TextStyles.defaultStyle.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: ColorPalette.textColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesSection() {
    // Lấy danh sách yêu thích từ data provider (tạm thời lấy top 5)
    final favoriteDestinations = DestinationDataProvider.getTopRatedDestinations(limit: 5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Địa điểm yêu thích',
                style: TextStyles.defaultStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.textColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  NavigationHelper().goToLike(initialTab: 0, showAll: true);
                },
                child: Text(
                  'Xem tất cả',
                  style: TextStyles.defaultStyle.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: ColorPalette.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: kDefaultPadding),

        // Kiểm tra nếu không có địa điểm yêu thích
        if (favoriteDestinations.isEmpty)
          // Empty state
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(kMediumPadding),
              decoration: BoxDecoration(
                color: ColorPalette.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(kItemPadding),
                border: Border.all(
                  color: ColorPalette.primaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    FontAwesomeIcons.heart,
                    size: 40,
                    color: ColorPalette.primaryColor.withOpacity(0.5),
                  ),
                  SizedBox(height: kDefaultPadding),
                  Text(
                    'Hãy khám phá địa điểm yêu thích',
                    style: TextStyles.defaultStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ColorPalette.textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: kTopPadding),
                  Text(
                    'Lưu những địa điểm bạn muốn ghé thăm\nvào danh sách yêu thích',
                    style: TextStyles.defaultStyle.copyWith(
                      fontSize: 13,
                      color: ColorPalette.subTitleColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: kDefaultPadding),
                  ElevatedButton.icon(
                    onPressed: () {
                      NavigationHelper().goToLike(initialTab: 0);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: kMediumPadding,
                        vertical: kDefaultPadding / 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kItemPadding),
                      ),
                    ),
                    icon: Icon(FontAwesomeIcons.compass, size: 16),
                    label: Text(
                      'Khám phá ngay',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          // Hiển thị danh sách địa điểm yêu thích dạng hình tròn
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              itemCount: favoriteDestinations.length,
              itemBuilder: (context, index) {
                final destination = favoriteDestinations[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < favoriteDestinations.length - 1 ? kMediumPadding : 0,
                  ),
                  child: _buildFavoriteDestinationItem(
                    imageUrl: destination.imageUrl,
                    name: destination.name,
                    onTap: () {
                      NavigationHelper().goToLike(initialTab: 0);
                    },
                  ),
                );
              },
            ),
          ),
      ],
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
            Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/notification_screen');
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
                // Badge for unread count
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Center(
                      child: Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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

          // Content có thể cuộn - Các widget chính
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: kDefaultPadding),
              child: Column(
                children: [
                  // ============================================================
                  // ĐỊA ĐIỂM YÊU THÍCH
                  // ============================================================
                  _buildFavoritesSection(),
                  SizedBox(height: kMediumPadding),
                  
                  // Popular Destinations Section
                  PopularDestinationsWidget(),
                  SizedBox(height: kMediumPadding),
                  
                  // Featured Articles Section → Hiển thị "Đánh giá nổi bật"
                  FeaturedArticlesWidget(),
                  SizedBox(height: kMediumPadding),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}