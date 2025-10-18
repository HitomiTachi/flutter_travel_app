import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
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
  final double profileCompletion = 0.85;

  late AnimationController _headerAnimationController;
  late AnimationController _listAnimationController;
  late Animation<double> _headerAnimation;
  late Animation<double> _listAnimation;

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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Custom App Bar với hiệu ứng parallax
          _buildSliverAppBar(),
          
          // Profile Content
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _listAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 50 * (1 - _listAnimation.value)),
                  child: Opacity(
                    opacity: _listAnimation.value,
                    child: Column(
                      children: [
                        const SizedBox(height: kMediumPadding),
                        
                        // Profile Completion Card
                        _buildProfileCompletionCard(),
                        
                        const SizedBox(height: kMediumPadding),
                        
                        // Quick Stats
                        _buildQuickStatsSection(),
                        
                        const SizedBox(height: kMediumPadding),
                        
                        // Quick Actions
                        _buildQuickActionsSection(),
                        
                        const SizedBox(height: kMediumPadding),
                        
                        // Main Menu
                        _buildMainMenuSection(),
                        
                        const SizedBox(height: kMediumPadding),
                        
                        // Settings Menu
                        _buildSettingsMenuSection(),
                        
                        const SizedBox(height: kMediumPadding),
                        
                        // Logout Button
                        _buildLogoutSection(),
                        
                        const SizedBox(height: kMediumPadding * 3),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Sliver App Bar với hiệu ứng parallax
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 280,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: ColorPalette.primaryColor,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      flexibleSpace: FlexibleSpaceBar(
        background: AnimatedBuilder(
          animation: _headerAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * _headerAnimation.value),
              child: Opacity(
                opacity: _headerAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ColorPalette.primaryColor,
                        ColorPalette.primaryColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        // Avatar với animation
                        _buildAnimatedAvatar(),
                        const SizedBox(height: 16),
                        // User Info
                        _buildUserInfo(),
                        const SizedBox(height: 16),
                        // Member Badge
                        _buildMemberBadge(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedAvatar() {
    return GestureDetector(
      onTap: _showImagePickerOptions,
      child: Stack(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                AssetHelper.person,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      FontAwesomeIcons.user,
                      size: 40,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                FontAwesomeIcons.camera,
                size: 12,
                color: ColorPalette.primaryColor,
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
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              FontAwesomeIcons.locationDot,
              color: Colors.white70,
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              userLocation,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMemberBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            FontAwesomeIcons.crown,
            color: Colors.amber,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            'Thành viên từ $memberSince',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCompletionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      padding: const EdgeInsets.all(kMediumPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange[400]!, Colors.orange[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(kTopPadding),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                FontAwesomeIcons.chartLine,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Hoàn thiện hồ sơ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${(profileCompletion * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: profileCompletion,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'Thêm số điện thoại để hoàn thiện 100%',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
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
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label, Color color) {
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
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      child: Row(
        children: [
          Expanded(child: _buildQuickActionButton(
            FontAwesomeIcons.plus,
            'Tạo kế hoạch',
            ColorPalette.primaryColor,
            () => _navigateToCreateTrip(),
          )),
          const SizedBox(width: 12),
          Expanded(child: _buildQuickActionButton(
            FontAwesomeIcons.magnifyingGlass,
            'Khám phá',
            Colors.orange,
            () => _navigateToExplore(),
          )),
        ],
      ),
    );
  }

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
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
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
              
              const Text(
                'Thay đổi ảnh đại diện',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              
              _buildImagePickerOption(
                FontAwesomeIcons.camera,
                'Chụp ảnh',
                'Sử dụng camera để chụp ảnh mới',
                Colors.blue,
                () {
                  Navigator.pop(context);
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
              
              _buildImagePickerOption(
                FontAwesomeIcons.trash,
                'Xóa ảnh hiện tại',
                'Sử dụng ảnh mặc định',
                Colors.red,
                () {
                  Navigator.pop(context);  
                  _showComingSoonDialog('Xóa ảnh');
                },
              ),
              
              const SizedBox(height: 20),
              
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600, 
                    ),
                  ),
                ),
              ),
              
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
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
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

  void _navigateToCreateTrip() {
    Navigator.pushNamed(context, '/trip_creation_screen');
  }

  void _navigateToExplore() {
    _showComingSoonDialog('Khám phá');
  }

  void _navigateToPersonalInfo() {
    _showComingSoonDialog('Thông tin cá nhân');
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
    _showComingSoonDialog('Cài đặt');
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
              Text('Ứng dụng giúp bạn tạo kế hoạch chuyến đi hoàn hảo với các tính năng:'),
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Hủy',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Đăng xuất',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
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
          content: Text('Tính năng "$feature" sẽ được phát triển trong phiên bản tiếp theo.'),
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
}