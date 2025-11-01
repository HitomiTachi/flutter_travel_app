import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_travels_apps/services/auth_service.dart';
import 'package:flutter_travels_apps/core/theme/theme_provider.dart';
import 'package:flutter_travels_apps/representation/screen/personal_info_screen.dart';
import 'package:flutter_travels_apps/core/helpers/local_storage_helper.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings_screen';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _locationServicesEnabled = true;
  String _selectedLanguage = 'Tiếng Việt';
  String _themeMode = 'Hệ thống';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: ColorPalette.backgroundScaffoldColor,
      body: AppBarContainerWidget(
        titleString: 'Cài đặt',
        implementLeading: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: kMediumPadding),

              // Tài khoản
              _buildSettingsSection(
                title: 'Tài khoản',
                children: [
                  _buildSettingItem(
                    icon: FontAwesomeIcons.user,
                    title: 'Thông tin tài khoản',
                    subtitle: user?.email ?? 'Chưa đăng nhập',
                    iconColor: ColorPalette.primaryColor,
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushNamed(PersonalInfoScreen.routeName);
                    },
                  ),
                  _buildSettingItem(
                    icon: FontAwesomeIcons.shield,
                    title: 'Bảo mật',
                    subtitle: 'Đổi mật khẩu, xác thực 2 bước',
                    iconColor: Colors.green,
                    onTap: () {
                      _showSecuritySettings();
                    },
                    isLast: true,
                  ),
                ],
              ),

              const SizedBox(height: kMediumPadding),

              // Ngôn ngữ và hiển thị
              _buildSettingsSection(
                title: 'Ngôn ngữ & Hiển thị',
                children: [
                  _buildSettingItem(
                    icon: FontAwesomeIcons.language,
                    title: 'Ngôn ngữ',
                    subtitle: _selectedLanguage,
                    iconColor: Colors.blue,
                    trailing: Text(
                      _selectedLanguage,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    onTap: () {
                      _showLanguageDialog();
                    },
                  ),
                  _buildSettingItem(
                    icon: FontAwesomeIcons.palette,
                    title: 'Giao diện',
                    subtitle: 'Chế độ sáng/tối',
                    iconColor: Colors.purple,
                    trailing: Text(
                      _themeMode,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    onTap: () {
                      _showThemeDialog();
                    },
                    isLast: true,
                  ),
                ],
              ),

              const SizedBox(height: kMediumPadding),

              // Quyền riêng tư
              _buildSettingsSection(
                title: 'Quyền riêng tư',
                children: [
                  _buildSwitchItem(
                    icon: FontAwesomeIcons.bell,
                    title: 'Thông báo đẩy',
                    subtitle: 'Nhận thông báo từ ứng dụng',
                    iconColor: Colors.orange,
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                      LocalStorageHelper.setValue(
                        'settings_notifications_enabled',
                        value,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            value ? 'Đã bật thông báo' : 'Đã tắt thông báo',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  _buildSwitchItem(
                    icon: FontAwesomeIcons.locationDot,
                    title: 'Dịch vụ vị trí',
                    subtitle: 'Cho phép ứng dụng truy cập vị trí',
                    iconColor: Colors.red,
                    value: _locationServicesEnabled,
                    onChanged: (value) {
                      setState(() {
                        _locationServicesEnabled = value;
                      });
                      LocalStorageHelper.setValue(
                        'settings_location_enabled',
                        value,
                      );
                      if (value) {
                        Permission.location.request();
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            value
                                ? 'Đã bật dịch vụ vị trí'
                                : 'Đã tắt dịch vụ vị trí',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    isLast: true,
                  ),
                ],
              ),

              const SizedBox(height: kMediumPadding),

              // Dữ liệu và lưu trữ
              _buildSettingsSection(
                title: 'Dữ liệu & Lưu trữ',
                children: [
                  _buildSettingItem(
                    icon: FontAwesomeIcons.database,
                    title: 'Xóa bộ nhớ đệm',
                    subtitle: 'Giải phóng dung lượng lưu trữ',
                    iconColor: Colors.teal,
                    onTap: () {
                      _clearCache();
                    },
                  ),
                  _buildSettingItem(
                    icon: FontAwesomeIcons.download,
                    title: 'Dữ liệu đã tải xuống',
                    subtitle: 'Quản lý dữ liệu offline',
                    iconColor: Colors.indigo,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tính năng đang phát triển'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    isLast: true,
                  ),
                ],
              ),

              const SizedBox(height: kMediumPadding),

              // Giới thiệu
              _buildSettingsSection(
                title: 'Giới thiệu',
                children: [
                  _buildSettingItem(
                    icon: FontAwesomeIcons.circleInfo,
                    title: 'Về ứng dụng',
                    subtitle: 'Phiên bản 1.0.0',
                    iconColor: Colors.cyan,
                    onTap: () {
                      _showAboutDialog();
                    },
                  ),
                  _buildSettingItem(
                    icon: FontAwesomeIcons.fileContract,
                    title: 'Điều khoản sử dụng',
                    subtitle: 'Chính sách và điều khoản',
                    iconColor: Colors.grey,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tính năng đang phát triển'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  _buildSettingItem(
                    icon: FontAwesomeIcons.shieldHalved,
                    title: 'Chính sách bảo mật',
                    subtitle: 'Quyền riêng tư và bảo mật',
                    iconColor: Colors.blueGrey,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tính năng đang phát triển'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    isLast: true,
                  ),
                ],
              ),

              const SizedBox(height: kMediumPadding),

              // Đăng xuất
              if (user != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kMediumPadding,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showLogoutDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kTopPadding),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.arrowRightFromBracket,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Đăng xuất',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: kMediumPadding * 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ColorPalette.subTitleColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(kTopPadding),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
    Widget? trailing,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: ListTile(
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
            trailing:
                trailing ??
                Icon(
                  FontAwesomeIcons.chevronRight,
                  size: 14,
                  color: Colors.grey[400],
                ),
            onTap: onTap,
          ),
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

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: ListTile(
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
            trailing: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: ColorPalette.primaryColor,
            ),
          ),
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

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chọn ngôn ngữ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Tiếng Việt'),
                value: 'Tiếng Việt',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã chọn Tiếng Việt'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              RadioListTile<String>(
                title: const Text('English'),
                value: 'English',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Selected English'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
          ],
        );
      },
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final themeProvider = context.read<ThemeProvider>();
        return AlertDialog(
          title: const Text('Chọn giao diện'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Hệ thống'),
                value: 'Hệ thống',
                groupValue: _themeMode,
                onChanged: (value) {
                  setState(() {
                    _themeMode = value!;
                  });
                  themeProvider.setMode(AppThemeMode.system);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã chọn giao diện theo hệ thống'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              RadioListTile<String>(
                title: const Text('Sáng'),
                value: 'Sáng',
                groupValue: _themeMode,
                onChanged: (value) {
                  setState(() {
                    _themeMode = value!;
                  });
                  themeProvider.setMode(AppThemeMode.light);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã chọn giao diện sáng'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              RadioListTile<String>(
                title: const Text('Tối'),
                value: 'Tối',
                groupValue: _themeMode,
                onChanged: (value) {
                  setState(() {
                    _themeMode = value!;
                  });
                  themeProvider.setMode(AppThemeMode.dark);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã chọn giao diện tối'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
          ],
        );
      },
    );
  }

  void _showSecuritySettings() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Bảo mật'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tính năng bảo mật:'),
              SizedBox(height: 12),
              Text('• Đổi mật khẩu'),
              Text('• Xác thực 2 bước (2FA)'),
              Text('• Quản lý thiết bị đăng nhập'),
              Text('• Lịch sử hoạt động'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tính năng đang phát triển'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Mở cài đặt'),
            ),
          ],
        );
      },
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xóa bộ nhớ đệm'),
          content: const Text(
            'Bạn có chắc chắn muốn xóa bộ nhớ đệm? '
            'Hành động này có thể mất một chút thời gian.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Giả lập xóa cache
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã xóa bộ nhớ đệm thành công'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Về ứng dụng'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Travel Planning App',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Phiên bản: 1.0.0'),
              SizedBox(height: 12),
              Text('Ứng dụng lập kế hoạch du lịch với các tính năng:'),
              SizedBox(height: 8),
              Text('• Tìm kiếm địa điểm'),
              Text('• Đặt khách sạn'),
              Text('• Lập kế hoạch chuyến đi'),
              Text('• Xem bản đồ'),
              Text('• Quản lý yêu thích'),
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
      builder: (context) {
        return AlertDialog(
          title: const Text('Đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                final authService = context.read<AuthService>();
                await authService.signOut();
                if (mounted) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/', (route) => false);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    );
  }
}
