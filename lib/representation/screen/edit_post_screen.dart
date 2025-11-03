import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/data/models/post_model.dart';
import 'package:flutter_travels_apps/services/post_service.dart';
import 'package:flutter_travels_apps/representation/widgets/common/app_bar_container.dart';

class EditPostScreen extends StatefulWidget {
  final PostModel post;

  const EditPostScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  static const String routeName = '/edit_post_screen';

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _locationNameController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  final PostService _postService = PostService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.post.description ?? '');
    _locationNameController = TextEditingController(text: widget.post.locationName ?? '');
    _latitudeController = TextEditingController(
      text: widget.post.location?.latitude.toString() ?? ''
    );
    _longitudeController = TextEditingController(
      text: widget.post.location?.longitude.toString() ?? ''
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationNameController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _updatePost() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);

    try {
      double? latitude = double.tryParse(_latitudeController.text);
      double? longitude = double.tryParse(_longitudeController.text);

      await _postService.updatePost(
        postId: widget.post.id,
        description: _descriptionController.text,
        locationName: _locationNameController.text,
        location: (latitude != null && longitude != null) 
            ? GeoPoint(latitude, longitude)
            : null,
      );

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã cập nhật bài viết thành công')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }



  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Chỉnh sửa bài viết',
      implementLeading: true,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(kMediumPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Default Image
                    const Text(
                      'Ảnh',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: const DecorationImage(
                          image: AssetImage(PostService.defaultImagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: kMediumPadding),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Mô tả',
                        hintText: 'Chia sẻ trải nghiệm của bạn...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: kMediumPadding),

                    // Location
                    TextFormField(
                      controller: _locationNameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên địa điểm',
                        hintText: 'Nhập tên địa điểm...',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên địa điểm';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: kMediumPadding),

                    // Location Coordinates
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _latitudeController,
                            decoration: const InputDecoration(
                              labelText: 'Vĩ độ',
                              hintText: 'Ví dụ: 10.762622',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) return null;
                              if (double.tryParse(value) == null) {
                                return 'Vui lòng nhập số hợp lệ';
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
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) return null;
                              if (double.tryParse(value) == null) {
                                return 'Vui lòng nhập số hợp lệ';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: kMediumPadding),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updatePost,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cập nhật',
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
}