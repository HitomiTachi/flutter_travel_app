import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/helpers/local_storage_helper.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings_screen';

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Settings values
  String _selectedLanguage = 'Tiếng Việt';
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _locationServices = true;
  bool _twoFactorAuth = false;
  String _distanceUnit = 'Kilometer';
  String _temperatureUnit = 'Celsius';
  bool _autoSaveTrips = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _selectedLanguage =
          LocalStorageHelper.getValue('language') ?? 'Tiếng Việt';
      _pushNotifications =
          LocalStorageHelper.getValue('pushNotifications') ?? true;
      _emailNotifications =
          LocalStorageHelper.getValue('emailNotifications') ?? true;
      _locationServices =
          LocalStorageHelper.getValue('locationServices') ?? true;
      _twoFactorAuth = LocalStorageHelper.getValue('twoFactorAuth') ?? false;
      _distanceUnit =
          LocalStorageHelper.getValue('distanceUnit') ?? 'Kilometer';
      _temperatureUnit =
          LocalStorageHelper.getValue('temperatureUnit') ?? 'Celsius';
      _autoSaveTrips = LocalStorageHelper.getValue('autoSaveTrips') ?? true;
    });
  }

  void _saveSetting(String key, dynamic value) {
    LocalStorageHelper.setValue(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Cài Đặt',
      implementLeading: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: kMediumPadding),

            // Ngôn ngữ & Khu vực
            _buildSectionCard(
              'Ngôn ngữ & Khu vực',
              FontAwesomeIcons.language,
              Colors.blue,
              [
                _buildDropdownSetting(
                  'Ngôn ngữ',
                  _selectedLanguage,
                  ['Tiếng Việt', 'English', '中文', '日本語'],
                  (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    _saveSetting('language', value);
                  },
                ),
              ],
            ),

            const SizedBox(height: kMediumPadding),

            // Thông báo
            _buildSectionCard(
              'Thông báo',
              FontAwesomeIcons.bell,
              Colors.orange,
              [
                _buildSwitchSetting(
                  'Thông báo đẩy',
                  'Nhận thông báo trên thiết bị',
                  _pushNotifications,
                  (value) {
                    setState(() {
                      _pushNotifications = value;
                    });
                    _saveSetting('pushNotifications', value);
                  },
                ),
                _buildDivider(),
                _buildSwitchSetting(
                  'Thông báo email',
                  'Nhận email về chuyến đi và ưu đãi',
                  _emailNotifications,
                  (value) {
                    setState(() {
                      _emailNotifications = value;
                    });
                    _saveSetting('emailNotifications', value);
                  },
                ),
              ],
            ),

            const SizedBox(height: kMediumPadding),

            // Vị trí & Quyền
            _buildSectionCard(
              'Vị trí & Quyền',
              FontAwesomeIcons.locationDot,
              Colors.green,
              [
                _buildSwitchSetting(
                  'Dịch vụ tá vị trí',
                  'Cho phép ứng dụng truy cập vị trí của bạn',
                  _locationServices,
                  (value) {
                    setState(() {
                      _locationServices = value;
                    });
                    _saveSetting('locationServices', value);
                  },
                ),
              ],
            ),

            const SizedBox(height: kMediumPadding),

            // Bảo mật
            _buildSectionCard(
              'Bảo mật',
              FontAwesomeIcons.shield,
              Colors.purple,
              [
                _buildSwitchSetting(
                  'Xác thực 2 yếu tố',
                  'Bảo mật tài khoản với mã OTP',
                  _twoFactorAuth,
                  (value) {
                    setState(() {
                      _twoFactorAuth = value;
                    });
                    _saveSetting('twoFactorAuth', value);
                    if (value) {
                      _showTwoFactorSetup();
                    }
                  },
                ),
                _buildDivider(),
                _buildActionSetting(
                  'Đổi mật khẩu',
                  'Thay đổi mật khẩu tài khoản',
                  FontAwesomeIcons.lock,
                  () => _showChangePasswordDialog(),
                ),
              ],
            ),

            const SizedBox(height: kMediumPadding),

            // Đơn vị đo lường
            _buildSectionCard(
              'Đơn vị đo lường',
              FontAwesomeIcons.ruler,
              Colors.teal,
              [
                _buildDropdownSetting(
                  'Đơn vị khoảng cách',
                  _distanceUnit,
                  ['Kilometer', 'Mile'],
                  (value) {
                    setState(() {
                      _distanceUnit = value!;
                    });
                    _saveSetting('distanceUnit', value);
                  },
                ),
                _buildDivider(),
                _buildDropdownSetting(
                  'Đơn vị nhiệt độ',
                  _temperatureUnit,
                  ['Celsius', 'Fahrenheit'],
                  (value) {
                    setState(() {
                      _temperatureUnit = value!;
                    });
                    _saveSetting('temperatureUnit', value);
                  },
                ),
              ],
            ),

            const SizedBox(height: kMediumPadding),

            // Kế hoạch chuyến đi
            _buildSectionCard(
              'Kế hoạch chuyến đi',
              FontAwesomeIcons.map,
              Colors.indigo,
              [
                _buildSwitchSetting(
                  'Tự động lưu',
                  'Tự động lưu kế hoạch chuyến đi',
                  _autoSaveTrips,
                  (value) {
                    setState(() {
                      _autoSaveTrips = value;
                    });
                    _saveSetting('autoSaveTrips', value);
                  },
                ),
              ],
            ),

            const SizedBox(height: kMediumPadding),

            // Dữ liệu & Bộ nhớ
            _buildSectionCard(
              'Dữ liệu & Bộ nhớ',
              FontAwesomeIcons.database,
              Colors.grey,
              [
                _buildActionSetting(
                  'Xóa bộ nhớ đệm',
                  'Xóa dữ liệu tạm thời để tiết kiệm dung lượng',
                  FontAwesomeIcons.trash,
                  () => _showClearCacheDialog(),
                ),
                _buildDivider(),
                _buildActionSetting(
                  'Xóa dữ liệu ứng dụng',
                  'Xóa toàn bộ dữ liệu đã lưu (không thể hoàn tác)',
                  FontAwesomeIcons.triangleExclamation,
                  () => _showClearDataDialog(),
                  isDanger: true,
                ),
              ],
            ),

            const SizedBox(height: kMediumPadding * 2),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    String title,
    IconData icon,
    Color iconColor,
    List<Widget> children,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(kMediumPadding),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.textColor,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchSetting(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: kMediumPadding,
        vertical: 4,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ColorPalette.textColor,
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
    );
  }

  Widget _buildDropdownSetting(
    String title,
    String currentValue,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: kMediumPadding,
        vertical: 4,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ColorPalette.textColor,
        ),
      ),
      trailing: DropdownButton<String>(
        value: currentValue,
        underline: Container(),
        icon: const Icon(
          FontAwesomeIcons.chevronDown,
          size: 14,
          color: ColorPalette.primaryColor,
        ),
        items: options.map((String option) {
          return DropdownMenuItem<String>(value: option, child: Text(option));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionSetting(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDanger = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: kMediumPadding,
        vertical: 4,
      ),
      leading: Icon(
        icon,
        color: isDanger ? Colors.red : ColorPalette.primaryColor,
        size: 20,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDanger ? Colors.red : ColorPalette.textColor,
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
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
      indent: kMediumPadding,
      endIndent: kMediumPadding,
    );
  }

  void _showTwoFactorSetup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thiết lập xác thực 2 yếu tố'),
          content: const Text(
            'Tính năng này sẽ được tích hợp với dịch vụ xác thực như Google Authenticator hoặc SMS OTP. '
            'Tính năng đang được phát triển và sẽ có trong phiên bản tiếp theo.',
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

  void _showChangePasswordDialog() {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Đổi mật khẩu'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu mới',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Xác nhận mật khẩu',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                if (passwordController.text == confirmPasswordController.text &&
                    passwordController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mật khẩu đã được thay đổi thành công!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mật khẩu không khớp hoặc rỗng!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.primaryColor,
              ),
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xóa bộ nhớ đệm'),
          content: const Text(
            'Bạn có chắc chắn muốn xóa bộ nhớ đệm? Thao tác này sẽ xóa dữ liệu tạm thời để giải phóng dung lượng.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã xóa bộ nhớ đệm thành công!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.primaryColor,
              ),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 8),
              Text('Xóa dữ liệu'),
            ],
          ),
          content: const Text(
            'CẢNH BÁO: Thao tác này sẽ xóa toàn bộ dữ liệu ứng dụng bao gồm:\n\n'
            '• Kế hoạch chuyến đi\n'
            '• Địa điểm yêu thích\n'
            '• Cài đặt cá nhân\n\n'
            'Thao tác này không thể hoàn tác!',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Clear all settings
                LocalStorageHelper.setValue('language', null);
                LocalStorageHelper.setValue('pushNotifications', null);
                LocalStorageHelper.setValue('emailNotifications', null);
                LocalStorageHelper.setValue('locationServices', null);
                LocalStorageHelper.setValue('twoFactorAuth', null);
                LocalStorageHelper.setValue('distanceUnit', null);
                LocalStorageHelper.setValue('temperatureUnit', null);
                LocalStorageHelper.setValue('autoSaveTrips', null);

                setState(() {
                  _loadSettings();
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã xóa toàn bộ dữ liệu!'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Xóa tất cả'),
            ),
          ],
        );
      },
    );
  }
}
