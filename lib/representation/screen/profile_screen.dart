import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
<<<<<<< HEAD
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
=======
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/core/helpers/local_storage_helper.dart';
>>>>>>> 72ffec4 (Initial commit)
import 'package:flutter_travels_apps/representation/screen/personal_info_screen.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const String routeName = '/profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  // Dữ liệu người dùng mẫu
  final String userName = "Nguyễn Văn A";
  final String userEmail = "nguyenvana@email.com";
  final String userPhone = "+84 123 456 789";
  final String userLocation = "Hà Nội, Việt Nam";
  final int completedTrips = 12;
  final int savedPlaces = 47;
  final String memberSince = "Tháng 3, 2023";

  late AnimationController _headerAnimationController;
  late AnimationController _listAnimationController;
<<<<<<< HEAD
  late Animation<double> _headerAnimation;
  late Animation<double> _listAnimation;

=======
  late Animation<double> _listAnimation;

  // Avatar image
  File? _avatarImage;
  final ImagePicker _imagePicker = ImagePicker();

>>>>>>> 72ffec4 (Initial commit)
  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

<<<<<<< HEAD
    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    _listAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _listAnimationController,
        curve: Curves.easeOut,
      ),
    );

    _startAnimations();
  }

=======
    _listAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _listAnimationController, curve: Curves.easeOut),
    );

    _loadAvatarFromStorage();
    _startAnimations();
  }

  void _loadAvatarFromStorage() {
    final avatarPath = LocalStorageHelper.getValue('user_avatar_path');
    if (avatarPath != null && avatarPath.toString().isNotEmpty) {
      final file = File(avatarPath.toString());
      if (file.existsSync()) {
        setState(() {
          _avatarImage = file;
        });
      }
    }
  }

>>>>>>> 72ffec4 (Initial commit)
  void _startAnimations() {
    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _listAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _listAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      implementLeading: false,
      titleString: 'Hồ Sơ Cá Nhân',
      child: AnimatedBuilder(
        animation: _listAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 50 * (1 - _listAnimation.value)),
            child: Opacity(
              opacity: _listAnimation.value,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: kMediumPadding),
<<<<<<< HEAD
                    
                    // Profile Header
                    _buildProfileHeader(),
                    
                    const SizedBox(height: kMediumPadding),
                    
                    // Quick Stats
                    _buildQuickStatsSection(),
                    
                    const SizedBox(height: kMediumPadding),
                    
                    // Main Menu
                    _buildMainMenuSection(),
                    
                    const SizedBox(height: kMediumPadding),
                    
                    // Settings Menu
                    _buildSettingsMenuSection(),
                    
                    const SizedBox(height: kMediumPadding),
                    
                    // Logout Button
                    _buildLogoutSection(),
                    
=======

                    // Profile Header
                    _buildProfileHeader(),

                    const SizedBox(height: kMediumPadding),

                    // Quick Stats
                    _buildQuickStatsSection(),

                    const SizedBox(height: kMediumPadding),

                    // Main Menu
                    _buildMainMenuSection(),

                    const SizedBox(height: kMediumPadding),

                    // Settings Menu
                    _buildSettingsMenuSection(),

                    const SizedBox(height: kMediumPadding),

                    // Logout Button
                    _buildLogoutSection(),

>>>>>>> 72ffec4 (Initial commit)
                    const SizedBox(height: kMediumPadding * 3),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Profile Header Section
  Widget _buildProfileHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      padding: const EdgeInsets.all(kMediumPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildAnimatedAvatar(),
          const SizedBox(height: kMediumPadding),
          _buildUserInfo(),
          const SizedBox(height: kMediumPadding),
          _buildMemberBadge(),
        ],
      ),
    );
  }

  Widget _buildAnimatedAvatar() {
    return GestureDetector(
      onTap: _showImagePickerOptions,
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: ColorPalette.primaryColor, width: 3),
              boxShadow: [
                BoxShadow(
                  color: ColorPalette.primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipOval(
<<<<<<< HEAD
              child: Image.asset(
                AssetHelper.person,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      FontAwesomeIcons.user,
                      size: 45,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
=======
              child: _avatarImage != null
                  ? Image.file(
                      _avatarImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar();
                      },
                    )
                  : Image.asset(
                      AssetHelper.person,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar();
                      },
                    ),
>>>>>>> 72ffec4 (Initial commit)
            ),
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: ColorPalette.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                FontAwesomeIcons.camera,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        Text(
          userName,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          userEmail,
<<<<<<< HEAD
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
=======
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
>>>>>>> 72ffec4 (Initial commit)
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.locationDot,
              color: ColorPalette.primaryColor,
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              userLocation,
<<<<<<< HEAD
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
=======
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
>>>>>>> 72ffec4 (Initial commit)
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMemberBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorPalette.primaryColor.withOpacity(0.1),
            ColorPalette.primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorPalette.primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
<<<<<<< HEAD
          Icon(
            FontAwesomeIcons.crown,
            color: Colors.amber[600],
            size: 14,
          ),
=======
          Icon(FontAwesomeIcons.crown, color: Colors.amber[600], size: 14),
>>>>>>> 72ffec4 (Initial commit)
          const SizedBox(width: 8),
          Text(
            'Thành viên từ $memberSince',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      child: Row(
        children: [
<<<<<<< HEAD
          Expanded(child: _buildStatCard(
            FontAwesomeIcons.mapLocationDot,
            '$completedTrips',
            'Chuyến đi',
            Colors.green,
          )),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard(
            FontAwesomeIcons.heart,
            '$savedPlaces',
            'Yêu thích',
            Colors.red,
          )),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard(
            FontAwesomeIcons.star,
            '4.8',
            'Đánh giá',
            Colors.amber,
          )),
=======
          Expanded(
            child: _buildStatCard(
              FontAwesomeIcons.mapLocationDot,
              '$completedTrips',
              'Chuyến đi',
              Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              FontAwesomeIcons.heart,
              '$savedPlaces',
              'Yêu thích',
              Colors.red,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              FontAwesomeIcons.star,
              '4.8',
              'Đánh giá',
              Colors.amber,
            ),
          ),
>>>>>>> 72ffec4 (Initial commit)
        ],
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildStatCard(IconData icon, String value, String label, Color color) {
=======
  Widget _buildStatCard(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
>>>>>>> 72ffec4 (Initial commit)
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kTopPadding),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
<<<<<<< HEAD
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
=======
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
>>>>>>> 72ffec4 (Initial commit)
        ],
      ),
    );
  }

  // Widget _buildQuickActionsSection() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
  //     child: Row(
  //       children: [
  //         Expanded(child: _buildQuickActionButton(
  //           FontAwesomeIcons.plus,
  //           'Tạo kế hoạch',
  //           ColorPalette.primaryColor,
  //           () => _navigateToCreateTrip(),
  //         )),
  //         const SizedBox(width: 12),
  //         Expanded(child: _buildQuickActionButton(
  //           FontAwesomeIcons.magnifyingGlass,
  //           'Khám phá',
  //           Colors.orange,
  //           () => _navigateToExplore(),
  //         )),
  //       ],
  //     ),
  //   );
  // }

<<<<<<< HEAD
  Widget _buildQuickActionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(kTopPadding),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

=======
>>>>>>> 72ffec4 (Initial commit)
  Widget _buildMainMenuSection() {
    return _buildMenuCard([
      _buildModernMenuItem(
        FontAwesomeIcons.user,
        'Thông tin cá nhân',
        'Chỉnh sửa hồ sơ và thông tin liên hệ',
        Colors.blue,
        () => _navigateToPersonalInfo(),
      ),
      _buildModernMenuItem(
        FontAwesomeIcons.mapLocationDot,
        'Chuyến đi của tôi',
        'Xem lịch sử và kế hoạch chuyến đi',
        Colors.green,
        () => _navigateToMyTrips(),
      ),
      _buildModernMenuItem(
<<<<<<< HEAD
=======
        FontAwesomeIcons.wallet,
        'Quản lý ngân sách',
        'Theo dõi chi tiêu chuyến đi',
        Colors.teal,
        () => _navigateToBudget(),
      ),
      _buildModernMenuItem(
        FontAwesomeIcons.listCheck,
        'Checklist Trước Khi Đi',
        'Danh sách đồ dùng cần chuẩn bị',
        Colors.orange,
        () => _navigateToChecklist(),
      ),
      _buildModernMenuItem(
        FontAwesomeIcons.moneyBill1,
        'Đổi tiền & Máy tính',
        'Chuyển đổi tiền tệ và tính tiền tip',
        Colors.green,
        () => _navigateToCurrencyConverter(),
      ),
      _buildModernMenuItem(
>>>>>>> 72ffec4 (Initial commit)
        FontAwesomeIcons.heart,
        'Danh sách yêu thích',
        'Địa điểm và chuyến đi đã lưu',
        Colors.red,
        () => _navigateToFavorites(),
      ),
      _buildModernMenuItem(
        FontAwesomeIcons.creditCard,
        'Phương thức thanh toán',
        'Quản lý thẻ và ví điện tử',
        Colors.purple,
        () => _navigateToPaymentMethods(),
      ),
    ]);
  }

  Widget _buildSettingsMenuSection() {
    return _buildMenuCard([
      _buildModernMenuItem(
        FontAwesomeIcons.bell,
        'Thông báo',
        'Cài đặt nhận thông báo',
        Colors.orange,
        () => _navigateToNotifications(),
      ),
      _buildModernMenuItem(
        FontAwesomeIcons.gear,
        'Cài đặt',
        'Ngôn ngữ, bảo mật và quyền riêng tư',
        Colors.grey,
        () => _navigateToSettings(),
      ),
      _buildModernMenuItem(
        FontAwesomeIcons.circleQuestion,
        'Trợ giúp & Hỗ trợ',
        'FAQ, liên hệ hỗ trợ',
        Colors.cyan,
        () => _navigateToHelp(),
      ),
      _buildModernMenuItem(
        FontAwesomeIcons.circleInfo,
        'Về ứng dụng',
        'Phiên bản 1.0.0',
        Colors.indigo,
        () => _showAboutApp(),
        isLast: true,
      ),
    ]);
  }

<<<<<<< HEAD


=======
>>>>>>> 72ffec4 (Initial commit)
  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kTopPadding),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildModernMenuItem(
    IconData icon,
    String title,
    String subtitle,
    Color iconColor,
    VoidCallback onTap, {
    bool isLast = false,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: kMediumPadding,
            vertical: 8,
          ),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            subtitle,
<<<<<<< HEAD
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
=======
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
>>>>>>> 72ffec4 (Initial commit)
          ),
          trailing: Icon(
            FontAwesomeIcons.chevronRight,
            size: 14,
            color: Colors.grey[400],
          ),
          onTap: onTap,
        ),
        if (!isLast)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[100],
            indent: kMediumPadding + 44 + kMediumPadding,
            endIndent: kMediumPadding,
          ),
      ],
    );
  }

  Widget _buildLogoutSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showLogoutDialog,
          borderRadius: BorderRadius.circular(kTopPadding),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red[400]!, Colors.red[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(kTopPadding),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.rightFromBracket,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(width: 12),
                Text(
                  'Đăng xuất',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Các hàm xử lý sự kiện
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(kMediumPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
<<<<<<< HEAD
              
=======

>>>>>>> 72ffec4 (Initial commit)
              const Text(
                'Thay đổi ảnh đại diện',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
<<<<<<< HEAD
              
=======

>>>>>>> 72ffec4 (Initial commit)
              _buildImagePickerOption(
                FontAwesomeIcons.camera,
                'Chụp ảnh',
                'Sử dụng camera để chụp ảnh mới',
                Colors.blue,
                () {
                  Navigator.pop(context);
<<<<<<< HEAD
                  _showComingSoonDialog('Chụp ảnh');
                },
              ),
              
              const SizedBox(height: 12),
              
              _buildImagePickerOption(
                FontAwesomeIcons.images,
                'Chọn từ thư viện',
                'Chọn ảnh có sẵn trong thấy viện',
                Colors.green,
                () {
                  Navigator.pop(context);
                  _showComingSoonDialog('Thư viện ảnh');
                },
              ),
              
              const SizedBox(height: 12),
              
=======
                  _pickImageFromCamera();
                },
              ),

              const SizedBox(height: 12),

              _buildImagePickerOption(
                FontAwesomeIcons.images,
                'Chọn từ thư viện',
                'Chọn ảnh có sẵn trong thư viện',
                Colors.green,
                () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),

              const SizedBox(height: 12),

>>>>>>> 72ffec4 (Initial commit)
              _buildImagePickerOption(
                FontAwesomeIcons.trash,
                'Xóa ảnh hiện tại',
                'Sử dụng ảnh mặc định',
                Colors.red,
                () {
<<<<<<< HEAD
                  Navigator.pop(context);  
                  _showComingSoonDialog('Xóa ảnh');
                },
              ),
              
              const SizedBox(height: 20),
              
=======
                  Navigator.pop(context);
                  _deleteAvatar();
                },
              ),

              const SizedBox(height: 20),

>>>>>>> 72ffec4 (Initial commit)
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kTopPadding),
                    ),
                  ),
                  child: const Text(
                    'Hủy',
<<<<<<< HEAD
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600, 
                    ),
                  ),
                ),
              ),
              
=======
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

>>>>>>> 72ffec4 (Initial commit)
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePickerOption(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
<<<<<<< HEAD
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
=======
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
>>>>>>> 72ffec4 (Initial commit)
                    ),
                  ],
                ),
              ),
              Icon(
                FontAwesomeIcons.chevronRight,
                size: 14,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

<<<<<<< HEAD
  void _navigateToCreateTrip() {
    Navigator.pushNamed(context, '/trip_creation_screen');
  }

  void _navigateToExplore() {
    _showComingSoonDialog('Khám phá');
  }

=======
>>>>>>> 72ffec4 (Initial commit)
  void _navigateToPersonalInfo() {
    Navigator.pushNamed(context, PersonalInfoScreen.routeName);
  }

  void _navigateToMyTrips() {
    _showComingSoonDialog('Chuyến đi của tôi');
  }

  void _navigateToFavorites() {
    _showComingSoonDialog('Danh sách yêu thích');
  }

  void _navigateToPaymentMethods() {
    _showComingSoonDialog('Phương thức thanh toán');
  }

  void _navigateToNotifications() {
    _showComingSoonDialog('Thông báo');
  }

  void _navigateToSettings() {
<<<<<<< HEAD
    _showComingSoonDialog('Cài đặt');
=======
    Navigator.pushNamed(context, '/settings_screen');
>>>>>>> 72ffec4 (Initial commit)
  }

  void _navigateToHelp() {
    _showComingSoonDialog('Trợ giúp & Hỗ trợ');
  }

  void _showAboutApp() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Về ứng dụng'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Travel Planning App'),
              Text('Phiên bản: 1.0.0'),
              SizedBox(height: 12),
<<<<<<< HEAD
              Text('Ứng dụng giúp bạn tạo kế hoạch chuyến đi hoàn hảo với các tính năng:'),
=======
              Text(
                'Ứng dụng giúp bạn tạo kế hoạch chuyến đi hoàn hảo với các tính năng:',
              ),
>>>>>>> 72ffec4 (Initial commit)
              SizedBox(height: 8),
              Text('• Lập kế hoạch chi tiết theo ngày'),
              Text('• Tìm kiếm nơi lưu trú phù hợp'),
              Text('• Quản lý ngân sách chuyến đi'),
              Text('• Chia sẻ kế hoạch với bạn bè'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

<<<<<<< HEAD
=======
  void _navigateToBudget() {
    Navigator.pushNamed(context, '/budget_screen');
  }

  void _navigateToChecklist() {
    Navigator.pushNamed(context, '/travel_checklist_screen');
  }

  void _navigateToCurrencyConverter() {
    Navigator.pushNamed(context, '/currency_converter_screen');
  }

>>>>>>> 72ffec4 (Initial commit)
  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kTopPadding),
          ),
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  FontAwesomeIcons.rightFromBracket,
                  color: Colors.red,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Đăng xuất',
<<<<<<< HEAD
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
=======
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
>>>>>>> 72ffec4 (Initial commit)
              ),
            ],
          ),
          content: const Text(
            'Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng không?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
<<<<<<< HEAD
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
=======
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
>>>>>>> 72ffec4 (Initial commit)
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Hủy',
<<<<<<< HEAD
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
=======
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
>>>>>>> 72ffec4 (Initial commit)
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
<<<<<<< HEAD
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
=======
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
>>>>>>> 72ffec4 (Initial commit)
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Đăng xuất',
<<<<<<< HEAD
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
=======
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
>>>>>>> 72ffec4 (Initial commit)
              ),
            ),
          ],
        );
      },
    );
  }

  void _performLogout() {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      },
    );

    // Simulate logout process
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context); // Close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Đã đăng xuất thành công!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
<<<<<<< HEAD
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
=======
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
>>>>>>> 72ffec4 (Initial commit)
        ),
      );
    });
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Đang phát triển'),
<<<<<<< HEAD
          content: Text('Tính năng "$feature" sẽ được phát triển trong phiên bản tiếp theo.'),
=======
          content: Text(
            'Tính năng "$feature" sẽ được phát triển trong phiên bản tiếp theo.',
          ),
>>>>>>> 72ffec4 (Initial commit)
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
<<<<<<< HEAD
}
=======

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.grey[300],
      child: const Icon(FontAwesomeIcons.user, size: 45, color: Colors.grey),
    );
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        _saveAvatarImage(File(image.path));
      }
    } catch (e) {
      _showErrorSnackBar('Không thể mở camera. Vui lòng thử lại.');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        _saveAvatarImage(File(image.path));
      }
    } catch (e) {
      _showErrorSnackBar('Không thể mở thư viện ảnh. Vui lòng thử lại.');
    }
  }

  void _saveAvatarImage(File imageFile) {
    setState(() {
      _avatarImage = imageFile;
    });

    // Lưu path vào storage (trên web sẽ cần cách khác)
    LocalStorageHelper.setValue('user_avatar_path', imageFile.path);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Đã cập nhật ảnh đại diện thành công!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _deleteAvatar() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red),
              SizedBox(width: 8),
              Text('Xóa ảnh đại diện'),
            ],
          ),
          content: const Text(
            'Bạn có chắc chắn muốn xóa ảnh đại diện hiện tại không?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _avatarImage = null;
                });
                LocalStorageHelper.setValue('user_avatar_path', '');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Đã xóa ảnh đại diện'),
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
>>>>>>> 72ffec4 (Initial commit)
