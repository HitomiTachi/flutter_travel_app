import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// --- THÊM CÁC IMPORT CẦN THIẾT ---
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// --- KẾT THÚC IMPORT (Đã xóa các thư viện ảnh) ---

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  static const String routeName = '/personal_info_screen';

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen>
    with TickerProviderStateMixin {
  
  // --- THÊM BIẾN CHO FIREBASE ---
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // (Đã xóa Storage)

  // Dữ liệu người dùng từ Firestore
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _originalUserData; // Để dùng cho hàm "Hủy"

  // --- CẬP NHẬT: Biến cho ảnh Storage ---
  bool _isLoading = true; // Bắt đầu với trạng thái loading
  // (Đã xóa _isUploading)

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
    
    // 1. Khởi tạo controllers (rỗng)
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _bioController = TextEditingController();
    _birthdayController = TextEditingController();
    _jobController = TextEditingController();
    _nationalityController = TextEditingController();
    
    // 2. Tải dữ liệu người dùng
    _fetchUserData();

    // 3. Animation setup (giữ nguyên)
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
    // _startAnimations() sẽ được gọi trong _fetchUserData
  }

  // --- HÀM MỚI: Tải dữ liệu từ Firestore ---
  Future<void> _fetchUserData() async {
    if (_currentUser == null) {
      if (mounted) {
        setState(() { _isLoading = false; });
        _showSnackBar('Không tìm thấy người dùng. Vui lòng đăng nhập lại.', isError: true);
      }
      return;
    }

    try {
      final doc = await _firestore.collection('users').doc(_currentUser!.uid).get();
      
      if (doc.exists && doc.data() != null) {
        _userData = doc.data()!;
        _originalUserData = Map.from(_userData!); // Sao chép để dùng cho "Hủy"
        
        // --- CẬP NHẬT: Gọi hàm helper mới ---
        _applyDataToControllers(_userData);
      } else {
        _showSnackBar('Không tìm thấy dữ liệu người dùng.', isError: true);
      }
    } catch (e) {
      _showSnackBar('Lỗi tải dữ liệu: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; }); // Tải xong, tắt loading
        _startAnimations(); // Bắt đầu animation sau khi có dữ liệu
      }
    }
  }

  // --- HÀM MỚI: Gán dữ liệu vào controllers (với "Chưa cập nhật") ---
  void _applyDataToControllers(Map<String, dynamic>? data) {
    if (data == null) return;

    // Tên và Email là bắt buộc, không cần "Chưa cập nhật"
    _nameController.text = data['name'] ?? '';
    _emailController.text = data['email'] ?? '';

    // Hàm nội tuyến (inline helper) để kiểm tra null hoặc rỗng
    String getText(String? value) {
      return (value == null || value.isEmpty) ? 'Chưa cập nhật' : value;
    }

    _phoneController.text = getText(data['phone']);
    _addressController.text = getText(data['address']);
    _bioController.text = getText(data['bio']);
    _jobController.text = getText(data['job']);
    _nationalityController.text = getText(data['nationality']);

    // Xử lý Ngày sinh (Timestamp)
    if (data['birthday'] != null) {
      selectedBirthday = (data['birthday'] as Timestamp).toDate();
      _birthdayController.text = "${selectedBirthday!.day.toString().padLeft(2, '0')}/${selectedBirthday!.month.toString().padLeft(2, '0')}/${selectedBirthday!.year}";
    } else {
      selectedBirthday = null;
      _birthdayController.text = 'Chưa cập nhật'; // <-- CẬP NHẬT
    }

    // Xử lý Giới tính
    selectedGender = data['gender'] ?? 'Nam';
    // ( avatarUrl sẽ được dùng trong _buildProfileImageSection )
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
      child: _isLoading
          ? Center(child: CircularProgressIndicator(color: ColorPalette.primaryColor))
          : AnimatedBuilder(
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
                          _buildProfileImageSection(), // <-- Đã xóa nút
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

  // --- CẬP NHẬT: Profile Image Section (Đã xóa nút chỉnh sửa) ---
  Widget _buildProfileImageSection() {
    
    // Lấy avatarUrl từ _userData, nếu null hoặc rỗng thì dùng ảnh mặc định
    String? avatarUrl = _userData?['avatarUrl'];
    ImageProvider backgroundImage = (avatarUrl != null && avatarUrl.isNotEmpty)
        ? NetworkImage(avatarUrl) // <-- DÙNG NETWORKIMAGE
        : const AssetImage(AssetHelper.person) as ImageProvider;

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
        // --- Đã xóa Stack và Positioned ---
        child: Container(
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
            backgroundImage: backgroundImage, 
            onBackgroundImageError: (exception, stackTrace) {
              // Xử lý nếu URL ảnh bị lỗi
              print("Lỗi tải ảnh: $exception");
              setState(() {
                _userData?['avatarUrl'] = null; // Xóa URL hỏng
              });
            },
          ),
        ),
      ),
    );
  }


  // --- ĐÃ XÓA: Toàn bộ các hàm xử lý ảnh ---
  // (Đã xóa _changeProfileImage)
  // (Đã xóa _pickAndUploadImage)
  // (Đã xóa _buildImageSourceOption)


  // Personal Info Form (Giữ nguyên, email đã disable)
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
              enabled: false, // Tắt chỉnh sửa Email
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


  // ... (Tất cả các hàm build widget còn lại: _buildSectionHeader, _buildFormField, _buildDateField, _buildGenderField, _buildActionButtons)
  // ... (Giữ nguyên, không thay đổi)
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


  // --- METHODS (CÁC HÀM XỬ LÝ) ---

  void _toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  // _selectDate (Giữ nguyên)
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


  // --- HÀM MỚI: Helper để lưu null nếu là "Chưa cập nhật" ---
  dynamic _saveNullIfPlaceholder(String text) {
    if (text.trim() == 'Chưa cập nhật') {
      return null;
    }
    return text.trim();
  }

  // --- CẬP NHẬT: _saveChanges (Lưu vào Firestore) ---
  void _saveChanges() async {
    if (!_validateForm()) {
      return;
    }
    
    if (_currentUser == null) {
      _showSnackBar('Không thể lưu, vui lòng đăng nhập lại.', isError: true);
      return;
    }

    // Hiển thị loading (tái sử dụng _isLoading)
    setState(() { _isLoading = true; });

    try {
      // 1. Tạo Map dữ liệu để cập nhật
      final dataToSave = {
        'name': _nameController.text.trim(),
        'phone': _saveNullIfPlaceholder(_phoneController.text),
        'address': _saveNullIfPlaceholder(_addressController.text),
        'bio': _saveNullIfPlaceholder(_bioController.text),
        'job': _saveNullIfPlaceholder(_jobController.text),
        'nationality': _saveNullIfPlaceholder(_nationalityController.text),
        'birthday': selectedBirthday != null ? Timestamp.fromDate(selectedBirthday!) : null,
        'gender': selectedGender,
        // (Không có avatarUrl vì chúng ta không sửa nó)
      };

      // 2. Gửi lệnh update lên Firestore
      await _firestore.collection('users').doc(_currentUser!.uid).update(dataToSave);

      // 3. Cập nhật dữ liệu local
      _userData!.addAll(dataToSave);
      _originalUserData = Map.from(_userData!); // Cập nhật bản gốc

      // 4. Tắt chế độ edit
      setState(() {
        isEditing = false;
      });
      _showSnackBar('Cập nhật thông tin thành công!');

    } catch (e) {
      _showSnackBar('Lỗi khi lưu: $e', isError: true);
    } finally {
      // Tắt loading
      setState(() { _isLoading = false; });
    }
  }

  // --- CẬP NHẬT: _validateForm (chỉ validate SĐT nếu được nhập) ---
  bool _validateForm() {
    if (_nameController.text.trim().isEmpty) {
      _showSnackBar('Vui lòng nhập họ tên', isError: true);
      return false;
    }
    
    // Bỏ validate Email vì đã tắt
    
    // Kiểm tra xem SĐT có phải là "Chưa cập nhật" hoặc rỗng không
    String phone = _phoneController.text.trim();
    if (phone == 'Chưa cập nhật') phone = ''; // Coi như rỗng

    if (phone.isNotEmpty) { // Chỉ validate nếu người dùng đã nhập SĐT
      final phoneRegex = RegExp(r'^(\+84|0)[3|5|7|8|9][0-9]{8}$');
      if (!phoneRegex.hasMatch(phone.replaceAll(' ', ''))) {
        _showSnackBar('Số điện thoại không hợp lệ', isError: true);
        return false;
      }
    }
    
    return true;
  }

  // --- CẬP NHẬT: _cancelEdit (Reset về dữ liệu gốc từ Firestore) ---
  void _cancelEdit() {
    setState(() {
      isEditing = false;
      
      // Reset form về _originalUserData (dữ liệu tải từ Firestore)
      // _applyDataToControllers sẽ xử lý logic "Chưa cập nhật"
      _applyDataToControllers(_originalUserData);
      
      // Quan trọng: reset lại _userData
      _userData = Map.from(_originalUserData!); 
    });
  }

  // _showSnackBar (Giữ nguyên)
  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
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