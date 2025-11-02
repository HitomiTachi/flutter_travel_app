import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/representation/screen/personal_info_screen.dart';
import 'package:flutter_travels_apps/representation/screen/settings_screen.dart';
import 'package:flutter_travels_apps/representation/widgets/common/app_bar_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// --- CẬP NHẬT: Thêm các import cần thiết ---
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_travels_apps/services/auth_service.dart';
// --- KẾT THÚC CẬP NHẬT ---

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const String routeName = '/profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  // --- CẬP NHẬT: Xóa dữ liệu mẫu ---
  // (Đã xóa userName, userEmail, v.v.)

  // --- CẬP NHẬT: Thêm biến Firebase ---
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy currentUser mỗi lần cần thiết thay vì khởi tạo một lần
  User? get _currentUser => FirebaseAuth.instance.currentUser;

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
      CurvedAnimation(parent: _listAnimationController, curve: Curves.easeOut),
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

  // --- CẬP NHẬT: Hàm helper để định dạng ngày (xử lý cả String và Timestamp) ---
  String _formatJoinDate(dynamic joinDateValue) {
    if (joinDateValue == null) {
      return 'N/A';
    }

    DateTime date;

    // Xử lý nếu là Timestamp
    if (joinDateValue is Timestamp) {
      date = joinDateValue.toDate();
    }
    // Xử lý nếu là String (dữ liệu cũ)
    else if (joinDateValue is String) {
      try {
        // Thử parse ISO string format
        date = DateTime.parse(joinDateValue);
      } catch (e) {
        // Nếu parse thất bại, trả về giá trị mặc định
        return 'N/A';
      }
    }
    // Xử lý nếu là DateTime
    else if (joinDateValue is DateTime) {
      date = joinDateValue;
    } else {
      return 'N/A';
    }

    // Định dạng đơn giản: "Tháng 3, 2023"
    const monthNames = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      '11',
      '12',
    ];
    return 'Tháng ${monthNames[date.month - 1]}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      implementLeading: false,
      titleString: 'Hồ Sơ Cá Nhân',
      // --- CẬP NHẬT: Sử dụng StreamBuilder để tải dữ liệu ---
      child: StreamBuilder<DocumentSnapshot>(
        // --- SỬA LỖI: .onSnapshot() -> .snapshots() ---
        stream: _currentUser != null
            ? _firestore.collection('users').doc(_currentUser!.uid).snapshots()
            : null,
        // --- KẾT THÚC SỬA LỖI ---
        builder: (context, snapshot) {
          // Kiểm tra nếu chưa có user đăng nhập
          if (_currentUser == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Chưa đăng nhập',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Vui lòng đăng nhập để xem hồ sơ',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Xử lý lỗi
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Lỗi: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data == null ||
              !snapshot.data!.exists) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_search, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Không tìm thấy dữ liệu người dùng.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Dữ liệu có thể chưa được tạo trong Firestore.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Lấy dữ liệu người dùng từ snapshot
          final userData = snapshot.data!.data() as Map<String, dynamic>;

          // Debug: In ra console để kiểm tra
          debugPrint('Profile Screen - User Data: $userData');

          return AnimatedBuilder(
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

                        // Profile Header
                        _buildProfileHeader(userData),

                        const SizedBox(height: kMediumPadding),

                        // Quick Stats
                        _buildQuickStatsSection(userData),

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
                ),
              );
            },
          );
        },
      ),
    );
  }

  // --- CẬP NHẬT: Truyền 'userData' vào ---
  Widget _buildProfileHeader(Map<String, dynamic> userData) {
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
          _buildAnimatedAvatar(userData), // <-- CẬP NHẬT
          const SizedBox(height: kMediumPadding),
          _buildUserInfo(userData), // <-- CẬP NHẬT
          const SizedBox(height: kMediumPadding),
          _buildMemberBadge(userData), // <-- CẬP NHẬT
        ],
      ),
    );
  }

  // --- CẬP NHẬT: Tải ảnh từ URL và KHÔI PHỤC nút camera ---
  Widget _buildAnimatedAvatar(Map<String, dynamic> userData) {
    final String? avatarUrl = userData['avatarUrl'];
    final ImageProvider backgroundImage =
        (avatarUrl != null && avatarUrl.isNotEmpty)
        ? NetworkImage(avatarUrl)
        : const AssetImage(AssetHelper.person) as ImageProvider;

    return GestureDetector(
      // <-- KHÔI PHỤC GestureDetector
      onTap: _showImagePickerOptions, // <-- KHÔI PHỤC onTap
      child: Stack(
        // <-- KHÔI PHỤC Stack
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
              child: Image(
                image: backgroundImage,
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
            ),
          ),
          Positioned(
            // <-- KHÔI PHỤC Nút camera
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

  // --- CẬP NHẬT: Lấy Tên, Email, Địa chỉ từ 'userData' ---
  Widget _buildUserInfo(Map<String, dynamic> userData) {
    return Column(
      children: [
        Text(
          userData['name'] ?? 'Chưa cập nhật', // <-- CẬP NHẬT
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          userData['email'] ?? '', // <-- CẬP NHẬT
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
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
              // Dùng logic "Chưa cập nhật"
              (userData['address'] != null &&
                      (userData['address'] as String).isNotEmpty)
                  ? userData['address']
                  : 'Chưa cập nhật địa chỉ', // <-- CẬP NHẬT
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  // --- CẬP NHẬT: Lấy ngày tham gia từ 'userData' ---
  Widget _buildMemberBadge(Map<String, dynamic> userData) {
    final String joinDateString = _formatJoinDate(
      userData['joinDate'],
    ); // <-- CẬP NHẬT

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
          Icon(FontAwesomeIcons.crown, color: Colors.amber[600], size: 14),
          const SizedBox(width: 8),
          Text(
            'Thành viên từ $joinDateString', // <-- CẬP NHẬT
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

  // --- CẬP NHẬT: Lấy số liệu 'favoritePlaceIds' ---
  Widget _buildQuickStatsSection(Map<String, dynamic> userData) {
    // Đếm số lượng 'favoritePlaceIds'
    final int savedPlacesCount =
        (userData['favoritePlaceIds'] as List?)?.length ?? 0;
    // (Giả sử 'completedTrips' và 'rating' chưa có, ta tạm ẩn)
    // final int completedTripsCount = userData['completedTrips'] ?? 0;
    // final String rating = userData['rating']?.toString() ?? 'N/A';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              FontAwesomeIcons.mapLocationDot,
              '0', // <-- Tạm ẩn
              'Chuyến đi',
              Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              FontAwesomeIcons.heart,
              '$savedPlacesCount', // <-- CẬP NHẬT
              'Yêu thích',
              Colors.red,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              FontAwesomeIcons.star,
              'N/A', // <-- Tạm ẩn
              'Đánh giá',
              Colors.amber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
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
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  // ... (Các widget _buildQuickActionsSection, _buildQuickActionButton không thay đổi) ...
  // ... (Các widget _buildMainMenuSection, _buildSettingsMenuSection, _buildMenuCard, _buildModernMenuItem không thay đổi) ...

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
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
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

  // --- CẬP NHẬT: KHÔI PHỤC _showImagePickerOptions ---
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

  // --- CẬP NHẬT: KHÔI PHỤC _buildImagePickerOption ---
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
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

  // ... (Các hàm _navigateTo... và _show...Dialog giữ nguyên) ...

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
    Navigator.of(context).pushNamed(SettingsScreen.routeName);
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
              Text(
                'Ứng dụng giúp bạn tạo kế hoạch chuyến đi hoàn hảo với các tính năng:',
              ),
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Hủy',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // --- CẬP NHẬT: Không cần pop, gọi thẳng _performLogout ---
                _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Đăng xuất',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  // --- CẬP NHẬT: Hàm _performLogout gọi AuthService ---
  void _performLogout() async {
    // Lấy AuthService từ Provider
    final authService = context.read<AuthService>();

    // 1. Đóng dialog xác nhận
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }

    // 2. Hiển thị dialog loading
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

    try {
      // 3. Gọi hàm đăng xuất
      await authService.signOut();

      // 4. Kiểm tra 'mounted'
      if (!mounted) return;

      // 5. Đóng dialog loading
      if (Navigator.of(context).canPop()) {
        Navigator.pop(context);
      }
      // AuthWrapper sẽ tự động điều hướng sang LoginScreen
    } catch (e) {
      // 6. Nếu có lỗi, đóng loading và báo lỗi
      if (!mounted) return;
      if (Navigator.of(context).canPop()) {
        Navigator.pop(context); // Đóng loading
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đăng xuất thất bại: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Đang phát triển'),
          content: Text(
            'Tính năng "$feature" sẽ được phát triển trong phiên bản tiếp theo.',
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
}
