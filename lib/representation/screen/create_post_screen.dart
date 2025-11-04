import 'dart:io'; // Cần thiết để làm việc với 'File' (cho chức năng chọn ảnh)
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/services/post_service.dart';
import 'package:flutter_travels_apps/representation/widgets/common/app_bar_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // (Bạn có import nhưng chưa dùng, mình vẫn giữ lại)
import 'package:image_picker/image_picker.dart'; // Gói thư viện để chọn ảnh

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  static const String routeName = '/create_post_screen';

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  // --- BIẾN VÀ CONTROLLERS QUẢN LÝ TRẠNG THÁI ---

  // GlobalKey để định danh và quản lý trạng thái của Form
  final _formKey = GlobalKey<FormState>();

  // Bộ điều khiển (controller) cho các ô nhập liệu (TextFormField)
  final _descriptionController = TextEditingController();
  final _locationNameController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  // Service xử lý logic nghiệp vụ (ví dụ: gọi API, tương tác Firebase)
  final PostService _postService = PostService();

  // Danh sách để lưu trữ các file ảnh người dùng đã chọn
  final List<File> _selectedImages = [];

  // Biến cờ (flag) để kiểm soát việc hiển thị vòng xoay "loading"
  bool _isLoading = false;

  // --- VÒNG ĐỜI WIDGET (LIFECYCLE) ---

  @override
  void dispose() {
    // Hàm này được gọi khi widget bị hủy (thoát khỏi màn hình)
    // Cần "dọn dẹp" các controller để tránh rò rỉ bộ nhớ
    _descriptionController.dispose();
    _locationNameController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  // --- HÀM XỬ LÝ LOGIC (LOGIC HANDLERS) ---

  /// Hàm xử lý logic chọn nhiều ảnh từ thư viện
  Future<void> _pickImages() async {
    try {
      final ImagePicker picker = ImagePicker();
      // Mở thư viện ảnh và cho phép chọn nhiều ảnh
      final List<XFile> images = await picker.pickMultiImage();

      if (images.isNotEmpty) {
        // Nếu người dùng có chọn ảnh
        setState(() {
          // Cập nhật lại state để hiển thị ảnh
          // Chuyển đổi từ XFile (của image_picker) sang File (của dart:io)
          _selectedImages.addAll(images.map((x) => File(x.path)));
        });
      }
    } catch (e) {
      // Xử lý nếu có lỗi (ví dụ: người dùng không cấp quyền)
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi chọn ảnh: $e')),
      );
    }
  }

  /// Hàm xử lý logic tạo bài viết mới
  Future<void> _createPost() async {
    // Bước 1: Kiểm tra xem Form (các ô nhập liệu) có hợp lệ không
    if (!_formKey.currentState!.validate()) return; // Nếu không, dừng lại

    // Bước 2: Hiển thị vòng xoay loading
    setState(() => _isLoading = true);

    try {
      // Bước 3: Chuyển đổi dữ liệu (từ text sang số)
      double? latitude = double.tryParse(_latitudeController.text);
      double? longitude = double.tryParse(_longitudeController.text);

      // Bước 4: Gọi service để thực hiện logic tạo post
      // (Lưu ý: Code này chưa xử lý upload ảnh, chỉ upload thông tin text)
      await _postService.createPost(
        description: _descriptionController.text,
        locationName: _locationNameController.text,
        location: (latitude != null && longitude != null)
            ? GeoPoint(latitude, longitude) // Nếu có cả 2, tạo GeoPoint
            : null, // Nếu thiếu 1 trong 2, gửi null
      );

      // Bước 5: Xử lý sau khi thành công
      if (!mounted) return; // Kiểm tra nếu widget còn tồn tại
      Navigator.pop(context); // Quay lại màn hình trước
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã đăng bài viết thành công')),
      );
    } catch (e) {
      // Bước 6: Xử lý nếu có lỗi xảy ra
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    } finally {
      // Bước 7: Luôn luôn tắt loading (dù thành công hay thất bại)
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // --- GIAO DIỆN (UI) ---

  @override
  Widget build(BuildContext context) {
    // Lấy theme text của ứng dụng để sử dụng cho tiêu đề
    final textTheme = Theme.of(context).textTheme;

    return AppBarContainerWidget(
      titleString: 'Tạo bài viết mới',
      implementLeading: true, // Hiển thị nút Back
      // Kiểm tra biến _isLoading
      child: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Nếu đang loading, hiển thị vòng xoay
          : SingleChildScrollView(
              // Nếu không, hiển thị nội dung
              // SingleChildScrollView cho phép cuộn khi bàn phím hiện lên
              padding: const EdgeInsets.all(kMediumPadding),
              child: Form(
                key: _formKey, // Gắn key cho Form
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Nhóm 1: Chọn Ảnh ---
                    Text(
                      'Ảnh bài viết',
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: kMediumPadding),
                    _buildImageSelection(), // Gọi widget chọn ảnh
                    const SizedBox(height: kMediumPadding * 1.5),

                    // --- Nhóm 2: Chi tiết bài viết ---
                    Text(
                      'Chi tiết bài viết',
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: kMediumPadding),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Mô tả',
                        hintText: 'Chia sẻ trải nghiệm của bạn...',
                        border: OutlineInputBorder(),
                        alignLabelWithHint:
                            true, // Căn label lên trên cho ô maxLines
                      ),
                      maxLines: 5, // Cho phép nhập nhiều dòng
                      validator: (value) {
                        // Logic kiểm tra
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mô tả';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: kMediumPadding * 1.5),

                    // --- Nhóm 3: Thông tin địa điểm ---
                    Text(
                      'Thông tin địa điểm',
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: kMediumPadding),
                    TextFormField(
                      controller: _locationNameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên địa điểm',
                        hintText: 'Nhập tên địa điểm...',
                        border: OutlineInputBorder(),
                        prefixIcon:
                            Icon(Icons.location_pin), // Thêm icon địa điểm
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên địa điểm';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: kMediumPadding),
                    _buildMapPreview(), // Gọi widget nhập Vĩ độ, Kinh độ
                    const SizedBox(height: kMediumPadding * 2),

                    // --- Nút Submit ---
                    SizedBox(
                      width: double.infinity, // Nút rộng hết cỡ
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.post_add), // Thêm icon đăng bài
                        onPressed: _createPost, // Gọi hàm logic khi nhấn
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        label: const Text(
                          'Đăng bài',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  /// Widget con: Xây dựng khu vực chọn ảnh (danh sách cuộn ngang)
  Widget _buildImageSelection() {
    return Container(
      height: 120, // Chiều cao cố định
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Cuộn ngang
        // Số lượng item = số ảnh đã chọn + 1 (cho nút "Thêm")
        itemCount: _selectedImages.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // Mục đầu tiên luôn là nút "Thêm ảnh"
            return _buildAddImageButton();
          }
          // Các mục sau là ảnh đã chọn (index - 1 vì item 0 là nút thêm)
          return _buildImagePreview(_selectedImages[index - 1], index - 1);
        },
      ),
    );
  }

  /// Widget con: Nút "Thêm ảnh" (ô vuông dấu cộng)
  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: _pickImages, // Gọi hàm chọn ảnh khi nhấn
      child: Container(
        width: 100, // Kích thước ô
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.add_photo_alternate,
          size: 40,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  /// Widget con: Hiển thị ảnh xem trước (thumbnail) và nút X để xóa
  Widget _buildImagePreview(File image, int index) {
    return Stack(
      // Dùng Stack để đè nút X lên trên ảnh
      clipBehavior: Clip.none, // Cho phép nút X tràn ra ngoài
      children: [
        Container(
          width: 100,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(image), // Hiển thị ảnh từ File
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Nút X (nằm ở góc trên bên phải)
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              // Xóa ảnh khỏi danh sách khi nhấn nút X
              setState(() {
                _selectedImages.removeAt(index);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Widget con: Xây dựng 2 ô nhập Vĩ độ và Kinh độ (giống edit_screen)
  Widget _buildMapPreview() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _latitudeController,
            decoration: const InputDecoration(
              labelText: 'Vĩ độ',
              hintText: 'Ví dụ: 10.762622',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.map_outlined), // Thêm icon
            ),
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true), // Bàn phím số
            validator: (value) {
              if (value == null || value.isEmpty) return null; // Không bắt buộc
              if (double.tryParse(value) == null) {
                return 'Vui lòng nhập số hợp lệ'; // Nhưng nếu nhập, phải là số
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: kMediumPadding),
        Expanded(
          child: TextFormField(
            controller: _longitudeController,
            decoration: const InputDecoration(
              labelText: 'Kinh độ',
              hintText: 'Ví dụ: 106.660172',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.map), // Thêm icon
            ),
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true), // Bàn phím số
            validator: (value) {
              if (value == null || value.isEmpty) return null; // Không bắt buộc
              if (double.tryParse(value) == null) {
                return 'Vui lòng nhập số hợp lệ'; // Nhưng nếu nhập, phải là số
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}