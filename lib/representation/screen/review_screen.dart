import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:flutter_travels_apps/services/review_service.dart';
import 'package:flutter_travels_apps/services/image_service.dart';
import 'package:flutter_travels_apps/data/models/review_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class ReviewScreen extends StatefulWidget {
  final String targetId;
  final String targetType;
  final String targetName;

  const ReviewScreen({
    super.key,
    required this.targetId,
    required this.targetType,
    required this.targetName,
  });

  static const String routeName = '/review_screen';

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final ReviewService _reviewService = ReviewService();
  final ImageService _imageService = ImageService();
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0.0;
  List<File> _selectedImages = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final images = await _imageService.pickMultipleImages(maxImages: 5);
    setState(() {
      _selectedImages = images;
    });
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitReview() async {
    if (_rating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn số sao đánh giá')),
      );
      return;
    }

    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Vui lòng nhập nhận xét')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      List<String> imageUrls = [];

      // Upload images if any
      if (_selectedImages.isNotEmpty) {
        for (var imageFile in _selectedImages) {
          final url = await _imageService.uploadReviewImage(
            imageFile,
            'temp_${DateTime.now().millisecondsSinceEpoch}',
          );
          if (url != null) imageUrls.add(url);
        }
      }

      // Create review
      await _reviewService.createReview(
        targetId: widget.targetId,
        targetType: widget.targetType,
        targetName: widget.targetName,
        rating: _rating,
        comment: _commentController.text.trim(),
        imageUrls: imageUrls,
      );

      // Reset form
      setState(() {
        _rating = 0.0;
        _commentController.clear();
        _selectedImages = [];
        _isSubmitting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đánh giá đã được gửi thành công!')),
        );
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return AppBarContainerWidget(
      titleString: 'Đánh giá',
      child: Column(
        children: [
          // Write review section
          if (user != null)
            Card(
              margin: EdgeInsets.all(kDefaultPadding),
              child: Padding(
                padding: EdgeInsets.all(kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (user.isAnonymous)
                      Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.only(bottom: kDefaultPadding),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.orange.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.orange,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Bạn đang sử dụng tài khoản khách. Đăng ký để lưu đánh giá!',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Text(
                      'Viết đánh giá',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.textColor,
                      ),
                    ),
                    SizedBox(height: kItemPadding),
                    Text(
                      widget.targetName,
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorPalette.subTitleColor,
                      ),
                    ),
                    SizedBox(height: kDefaultPadding),
                    // Rating
                    RatingBar.builder(
                      initialRating: _rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 40,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) =>
                          Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {
                        setState(() => _rating = rating);
                      },
                    ),
                    SizedBox(height: kDefaultPadding),
                    // Comment
                    TextField(
                      controller: _commentController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Chia sẻ trải nghiệm của bạn...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: ColorPalette.backgroundScaffoldColor,
                      ),
                    ),
                    SizedBox(height: kDefaultPadding),
                    // Image picker
                    if (_selectedImages.isEmpty)
                      OutlinedButton.icon(
                        onPressed: _pickImages,
                        icon: Icon(Icons.add_photo_alternate),
                        label: Text('Thêm ảnh (tối đa 5)'),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ..._selectedImages.asMap().entries.map((entry) {
                                final index = entry.key;
                                final file = entry.value;
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        file,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () => _removeImage(index),
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              if (_selectedImages.length < 5)
                                GestureDetector(
                                  onTap: _pickImages,
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: ColorPalette.dividerColor,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.add),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    SizedBox(height: kDefaultPadding),
                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitReview,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isSubmitting
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'Gửi đánh giá',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (user == null)
            // Thông báo khi chưa đăng nhập
            Card(
              margin: EdgeInsets.all(kDefaultPadding),
              child: Padding(
                padding: EdgeInsets.all(kDefaultPadding),
                child: Column(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 48,
                      color: ColorPalette.subTitleColor,
                    ),
                    SizedBox(height: kDefaultPadding),
                    Text(
                      'Vui lòng đăng nhập để viết đánh giá',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.textColor,
                      ),
                    ),
                    SizedBox(height: kItemPadding),
                    Text(
                      'Đăng nhập để chia sẻ trải nghiệm của bạn',
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorPalette.subTitleColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

          // Reviews list
          Expanded(
            child: StreamBuilder<List<ReviewModel>>(
              stream: _reviewService.getReviewsStream(
                targetId: widget.targetId,
                targetType: widget.targetType,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                }

                final reviews = snapshot.data ?? [];

                if (reviews.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.reviews,
                          size: 64,
                          color: ColorPalette.subTitleColor,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Chưa có đánh giá nào',
                          style: TextStyle(color: ColorPalette.subTitleColor),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(kDefaultPadding),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    return _buildReviewItem(reviews[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(ReviewModel review) {
    final user = FirebaseAuth.instance.currentUser;
    final isOwnReview = user?.uid == review.userId;
    final isHelpful = user != null && review.helpfulUserIds.contains(user.uid);

    return Card(
      margin: EdgeInsets.only(bottom: kDefaultPadding),
      child: Padding(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: review.userAvatarUrl != null
                      ? CachedNetworkImageProvider(review.userAvatarUrl!)
                      : null,
                  child: review.userAvatarUrl == null
                      ? Icon(Icons.person)
                      : null,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.textColor,
                        ),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(review.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorPalette.subTitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // Rating
                RatingBar.builder(
                  initialRating: review.rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 16,
                  ignoreGestures: true,
                  itemBuilder: (context, _) =>
                      Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (_) {},
                ),
              ],
            ),
            SizedBox(height: kDefaultPadding),
            // Comment
            Text(
              review.comment,
              style: TextStyle(fontSize: 14, color: ColorPalette.textColor),
            ),
            // Images
            if (review.imageUrls.isNotEmpty) ...[
              SizedBox(height: kDefaultPadding),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: review.imageUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: review.imageUrls[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 100,
                            height: 100,
                            color: ColorPalette.dividerColor,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 100,
                            height: 100,
                            color: ColorPalette.dividerColor,
                            child: Icon(Icons.image),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            SizedBox(height: kDefaultPadding),
            // Actions
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isHelpful ? Icons.thumb_up : Icons.thumb_up_outlined,
                    color: isHelpful
                        ? ColorPalette.primaryColor
                        : ColorPalette.subTitleColor,
                  ),
                  onPressed: user != null
                      ? () async {
                          try {
                            await _reviewService.toggleHelpful(review.id);
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Lỗi: ${e.toString()}')),
                              );
                            }
                          }
                        }
                      : null,
                ),
                Text(
                  '${review.helpfulCount} hữu ích',
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorPalette.subTitleColor,
                  ),
                ),
                Spacer(),
                if (isOwnReview)
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text('Chỉnh sửa'),
                        onTap: () {
                          // TODO: Implement edit review
                        },
                      ),
                      PopupMenuItem(
                        child: Text('Xóa', style: TextStyle(color: Colors.red)),
                        onTap: () async {
                          try {
                            await _reviewService.deleteReview(review.id);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Đã xóa đánh giá')),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Lỗi: ${e.toString()}')),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
              ],
            ),
            if (review.isEdited)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  '(Đã chỉnh sửa)',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: ColorPalette.subTitleColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
