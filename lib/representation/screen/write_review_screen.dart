import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:flutter_travels_apps/data/models/review_model.dart';
import 'package:flutter_travels_apps/services/review_service.dart';
import 'package:flutter_travels_apps/representation/widgets/common/app_bar_container.dart';
import 'package:flutter_travels_apps/representation/widgets/common/button_widget.dart';
import 'package:flutter_travels_apps/representation/widgets/review_widgets/rating_stars.dart';

/// Màn hình viết đánh giá mới
class WriteReviewScreen extends StatefulWidget {
  final String destinationId;
  final String destinationName;
  final String targetType;

  const WriteReviewScreen({
    Key? key,
    required this.destinationId,
    required this.destinationName,
    this.targetType = 'location',
  }) : super(key: key);

  static const String routeName = '/write_review';

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final ReviewService _reviewService = ReviewService();
  final _formKey = GlobalKey<FormState>();
  
  double _rating = 0.0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  TripType _selectedTripType = TripType.solo;
  bool _isRecommended = true;
  final List<String> _selectedTags = [];
  bool _isSubmitting = false;

  final List<String> _availableTags = [
    'Tuyệt vời',
    'Đáng tiền',
    'Sạch sẽ',
    'Nhân viên thân thiện',
    'Vị trí đẹp',
    'Phong cảnh đẹp',
    'Ẩm thực ngon',
    'Thích hợp gia đình',
    'Yên tĩnh',
    'Vui vẻ',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      if (_rating == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn số sao đánh giá')),
        );
        return;
      }

      setState(() => _isSubmitting = true);

      try {
        await _reviewService.createReview(
          targetId: widget.destinationId,
          targetType: widget.targetType,
          targetName: widget.destinationName,
          rating: _rating,
          comment: _contentController.text.trim(),
        );

        if (mounted) {
          Navigator.pop(context, true); // Return true để refresh danh sách
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã gửi đánh giá thành công!')),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Viết đánh giá',
      implementLeading: true,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: kMediumPadding * 2),

              // Destination name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Text(
                  widget.destinationName,
                  style: TextStyles.defaultStyle.fontHeader.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: kMediumPadding),

              // Rating section
              Container(
                padding: const EdgeInsets.all(kDefaultPadding),
                margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(kItemPadding),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Đánh giá của bạn',
                      style: TextStyles.defaultStyle.fontHeader.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: kItemPadding),
                    Center(
                      child: RatingStars(
                        rating: _rating,
                        interactive: true,
                        size: 40,
                        onRatingChanged: (rating) {
                          setState(() => _rating = rating);
                        },
                      ),
                    ),
                    if (_rating > 0) ...[
                      const SizedBox(height: kTopPadding),
                      Center(
                        child: Text(
                          _getRatingLabel(_rating),
                          style: TextStyles.defaultStyle.copyWith(
                            color: ColorPalette.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: kDefaultPadding),

              // Title field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Tiêu đề (tùy chọn)',
                    hintText: 'Tóm tắt trải nghiệm của bạn',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kItemPadding),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLength: 100,
                ),
              ),
              const SizedBox(height: kDefaultPadding),

              // Content field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: 'Nội dung đánh giá *',
                    hintText: 'Chia sẻ trải nghiệm chi tiết của bạn...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kItemPadding),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    alignLabelWithHint: true,
                  ),
                  maxLines: 6,
                  maxLength: 500,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập nội dung đánh giá';
                    }
                    if (value.trim().length < 20) {
                      return 'Nội dung phải có ít nhất 20 ký tự';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: kDefaultPadding),

              // Trip type
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loại chuyến đi',
                      style: TextStyles.defaultStyle.fontHeader.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: kItemPadding),
                    Wrap(
                      spacing: kTopPadding,
                      children: [
                        TripType.couple,
                        TripType.family,
                        TripType.friends,
                        TripType.solo,
                      ].map((tripType) {
                        final isSelected = _selectedTripType == tripType;
                        return ChoiceChip(
                          label: Text(tripType.label),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() => _selectedTripType = tripType);
                          },
                          selectedColor: ColorPalette.primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontSize: 13,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: kDefaultPadding),

              // Tags
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chọn tags (tùy chọn)',
                      style: TextStyles.defaultStyle.fontHeader.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: kItemPadding),
                    Wrap(
                      spacing: kTopPadding,
                      runSpacing: kTopPadding,
                      children: _availableTags.map((tag) {
                        final isSelected = _selectedTags.contains(tag);
                        return FilterChip(
                          label: Text(tag),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedTags.add(tag);
                              } else {
                                _selectedTags.remove(tag);
                              }
                            });
                          },
                          selectedColor: ColorPalette.primaryColor.withOpacity(0.2),
                          checkmarkColor: ColorPalette.primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected ? ColorPalette.primaryColor : Colors.black87,
                            fontSize: 12,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: kDefaultPadding),

              // Recommend switch
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Container(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(kItemPadding),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.thumb_up,
                        color: ColorPalette.primaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: kItemPadding),
                      Expanded(
                        child: Text(
                          'Tôi đề xuất địa điểm này',
                          style: TextStyles.defaultStyle.fontHeader.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Switch(
                        value: _isRecommended,
                        onChanged: (value) {
                          setState(() => _isRecommended = value);
                        },
                        activeColor: ColorPalette.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: kMediumPadding),

              // Submit button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: ButtonWidget(
                  title: _isSubmitting ? 'Đang gửi...' : 'Gửi đánh giá',
                  onTap: _isSubmitting ? null : _submitReview,
                ),
              ),
              const SizedBox(height: kMediumPadding),
            ],
          ),
        ),
      ),
    );
  }

  String _getRatingLabel(double rating) {
    if (rating >= 5) return 'Xuất sắc';
    if (rating >= 4) return 'Rất tốt';
    if (rating >= 3) return 'Tốt';
    if (rating >= 2) return 'Trung bình';
    return 'Kém';
  }
}
