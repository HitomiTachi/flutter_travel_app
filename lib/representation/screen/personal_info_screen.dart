import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  static const String routeName = '/personal_info_screen';

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen>
    with TickerProviderStateMixin {
  
  // Controllers cho form
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _bioController;
  late TextEditingController _birthdayController;
  late TextEditingController _jobController;
  late TextEditingController _nationalityController;
  
  // Dữ liệu người dùng
  String selectedGender = 'Nam';
  DateTime? selectedBirthday;
  bool isEditing = false;
  
  // Animation controllers
  late AnimationController _fadeAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Khởi tạo controllers
    _nameController = TextEditingController(text: "Nguyễn Văn A");
    _emailController = TextEditingController(text: "nguyenvana@email.com");
    _phoneController = TextEditingController(text: "+84 123 456 789");
    _addressController = TextEditingController(text: "123 Nguyễn Trãi, Quận 1, TP.HCM");
    _bioController = TextEditingController(text: "Yêu thích du lịch và khám phá những điều mới mẻ");
    _birthdayController = TextEditingController(text: "15/03/1990");
    _jobController = TextEditingController(text: "Kỹ sư phần mềm");
    _nationalityController = TextEditingController(text: "Việt Nam");
    selectedBirthday = DateTime(1990, 3, 15);
    
    // Animation setup
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _startAnimations();
  }

  void _startAnimations() {
    _fadeAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    _birthdayController.dispose();
    _jobController.dispose();
    _nationalityController.dispose();
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      implementLeading: true,
      titleString: 'Thông Tin Cá Nhân',
      implementTraling: true,
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: kMediumPadding),
                    _buildEditButton(),
                    const SizedBox(height: kMediumPadding),
                    _buildProfileImageSection(),
                    const SizedBox(height: kMediumPadding),
                    _buildPersonalInfoForm(),
                    const SizedBox(height: kMediumPadding),
                    if (isEditing) _buildActionButtons(),
                    const SizedBox(height: kMediumPadding * 2),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Edit Button
  Widget _buildEditButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: _toggleEditMode,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isEditing ? Colors.green : ColorPalette.primaryColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isEditing ? Icons.save : Icons.edit,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                isEditing ? 'Lưu' : 'Chỉnh sửa',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Profile Image Section
  Widget _buildProfileImageSection() {
    return Container(
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
      child: Center(
        child: Stack(
          children: [
            Container(
              width: 120,
              height: 120,
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
              child: CircleAvatar(
                radius: 57,
                backgroundColor: Colors.grey[300],
                backgroundImage: AssetImage(AssetHelper.person),
              ),
            ),
            if (isEditing)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: ColorPalette.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    onPressed: _changeProfileImage,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Personal Info Form
  Widget _buildPersonalInfoForm() {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kMediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Thông Tin Cơ Bản', FontAwesomeIcons.user),
            const SizedBox(height: kMediumPadding),
            
            _buildFormField(
              'Họ và Tên',
              _nameController,
              FontAwesomeIcons.userTag,
              enabled: isEditing,
            ),
            const SizedBox(height: kMediumPadding),
            
            _buildFormField(
              'Email',
              _emailController,
              FontAwesomeIcons.envelope,
              enabled: isEditing,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: kMediumPadding),
            
            _buildFormField(
              'Số Điện Thoại',
              _phoneController,
              FontAwesomeIcons.phone,
              enabled: isEditing,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: kMediumPadding),
            
            _buildDateField(),
            const SizedBox(height: kMediumPadding),
            
            _buildGenderField(),
            const SizedBox(height: kMediumPadding),
            
            _buildFormField(
              'Nghề Nghiệp',
              _jobController,
              FontAwesomeIcons.briefcase,
              enabled: isEditing,
            ),
            const SizedBox(height: kMediumPadding),
            
            _buildFormField(
              'Quốc Tịch',
              _nationalityController,
              FontAwesomeIcons.flag,
              enabled: isEditing,
            ),
            const SizedBox(height: kMediumPadding),
            
            _buildFormField(
              'Địa Chỉ',
              _addressController,
              FontAwesomeIcons.locationDot,
              enabled: isEditing,
              maxLines: 2,
            ),
            const SizedBox(height: kMediumPadding),
            
            _buildFormField(
              'Giới Thiệu Bản Thân',
              _bioController,
              FontAwesomeIcons.quoteLeft,
              enabled: isEditing,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  // Section Header
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ColorPalette.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: ColorPalette.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  // Form Field
  Widget _buildFormField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool enabled = true,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: 16,
            color: enabled ? Colors.black87 : Colors.grey[600],
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: enabled ? ColorPalette.primaryColor : Colors.grey[400],
              size: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: ColorPalette.primaryColor, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  // Date Field
  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ngày Sinh',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _birthdayController,
          enabled: isEditing,
          readOnly: true,
          onTap: isEditing ? _selectDate : null,
          style: TextStyle(
            fontSize: 16,
            color: isEditing ? Colors.black87 : Colors.grey[600],
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              FontAwesomeIcons.calendar,
              color: isEditing ? ColorPalette.primaryColor : Colors.grey[400],
              size: 20,
            ),
            suffixIcon: isEditing ? const Icon(Icons.arrow_drop_down) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: ColorPalette.primaryColor, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            filled: true,
            fillColor: isEditing ? Colors.white : Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  // Gender Field
  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Giới Tính',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
            color: isEditing ? Colors.white : Colors.grey[50],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedGender,
              isExpanded: true,
              icon: Icon(
                Icons.arrow_drop_down,
                color: isEditing ? ColorPalette.primaryColor : Colors.grey[400],
              ),
              items: ['Nam', 'Nữ', 'Khác'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.venusMars,
                        color: isEditing ? ColorPalette.primaryColor : Colors.grey[400],
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 16,
                          color: isEditing ? Colors.black87 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: isEditing ? (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedGender = newValue;
                  });
                }
              } : null,
            ),
          ),
        ),
      ],
    );
  }

  // Action Buttons
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalette.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.save, size: 20),
                SizedBox(width: 8),
                Text(
                  'Lưu Thay Đổi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _cancelEdit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cancel, size: 20),
                SizedBox(width: 8),
                Text(
                  'Hủy',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Methods
  void _toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedBirthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorPalette.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != selectedBirthday) {
      setState(() {
        selectedBirthday = picked;
        _birthdayController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  void _changeProfileImage() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(kMediumPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Thay Đổi Ảnh Đại Diện',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: kMediumPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageSourceOption(
                    FontAwesomeIcons.camera,
                    'Chụp Ảnh',
                    () {
                      Navigator.pop(context);
                      // Implement camera functionality
                    },
                  ),
                  _buildImageSourceOption(
                    FontAwesomeIcons.image,
                    'Chọn Từ Thư Viện',
                    () {
                      Navigator.pop(context);
                      // Implement gallery functionality
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: ColorPalette.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              icon,
              color: ColorPalette.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    if (!_validateForm()) {
      return;
    }

    // Save changes
    setState(() {
      isEditing = false;
    });
    
    _showSnackBar('Cập nhật thông tin thành công!');
  }

  // Form validation
  bool _validateForm() {
    if (_nameController.text.trim().isEmpty) {
      _showSnackBar('Vui lòng nhập họ tên', isError: true);
      return false;
    }
    
    if (_emailController.text.trim().isEmpty) {
      _showSnackBar('Vui lòng nhập email', isError: true);
      return false;
    }
    
    // Email validation regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_emailController.text.trim())) {
      _showSnackBar('Email không hợp lệ', isError: true);
      return false;
    }
    
    if (_phoneController.text.trim().isEmpty) {
      _showSnackBar('Vui lòng nhập số điện thoại', isError: true);
      return false;
    }
    
    // Phone validation (Vietnamese phone format)
    final phoneRegex = RegExp(r'^(\+84|0)[3|5|7|8|9][0-9]{8}$');
    if (!phoneRegex.hasMatch(_phoneController.text.trim().replaceAll(' ', ''))) {
      _showSnackBar('Số điện thoại không hợp lệ', isError: true);
      return false;
    }
    
    return true;
  }

  void _cancelEdit() {
    setState(() {
      isEditing = false;
      // Reset form to original values
      _nameController.text = "Nguyễn Văn A";
      _emailController.text = "nguyenvana@email.com";
      _phoneController.text = "+84 123 456 789";
      _addressController.text = "123 Nguyễn Trãi, Quận 1, TP.HCM";
      _bioController.text = "Yêu thích du lịch và khám phá những điều mới mẻ";
      _birthdayController.text = "15/03/1990";
      _jobController.text = "Kỹ sư phần mềm";
      _nationalityController.text = "Việt Nam";
      selectedBirthday = DateTime(1990, 3, 15);
      selectedGender = 'Nam';
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}