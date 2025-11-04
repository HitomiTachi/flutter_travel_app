import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dismension_constants.dart';
import '../../../core/constants/textstyle_constants.dart';
import '../../../data/models/review_model.dart';
import 'rating_stars.dart';
import 'review_images_row.dart';

/// Widget hiển thị một review card
class ReviewCard extends StatelessWidget {
  final ReviewModel review;
  final VoidCallback? onHelpfulYes;
  final VoidCallback? onHelpfulNo;
  final bool showFullContent;
  final VoidCallback? onTap;

  const ReviewCard({
    Key? key,
    required this.review,
    this.onHelpfulYes,
    this.onHelpfulNo,
    this.showFullContent = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: kDefaultPadding),
        padding: const EdgeInsets.all(kDefaultPadding),
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
            // User info row
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 20,
                  backgroundColor: ColorPalette.primaryColor.withOpacity(0.1),
                  backgroundImage: review.userAvatarUrl != null
                      ? AssetImage(review.userAvatarUrl!)
                      : null,
                  child: review.userAvatarUrl == null
                      ? Text(
                          review.userName[0].toUpperCase(),
                          style: TextStyles.defaultStyle.copyWith(
                            color: ColorPalette.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: kItemPadding),
                
                // Name and info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            review.userName,
                            style: TextStyles.defaultStyle.fontHeader.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          if (review.isVerified) ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Đã đến',
                                style: TextStyles.defaultStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            review.formattedDate,
                            style: TextStyles.defaultStyle.subTitleTextColor.copyWith(
                              fontSize: 12,
                            ),
                          ),
                          if (review.userCountry != null) ...[
                            Text(
                              ' • ',
                              style: TextStyles.defaultStyle.subTitleTextColor.copyWith(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              review.userCountry!,
                              style: TextStyles.defaultStyle.subTitleTextColor.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Rating
                RatingStars(
                  rating: review.rating,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: kItemPadding),

            // Trip type chip
            Wrap(
              spacing: kTopPadding,
              children: [
                _buildChip(review.tripTypeLabel, Icons.people),
                if (review.isRecommended)
                  _buildChip('Đề xuất', Icons.thumb_up, isHighlight: true),
              ],
            ),
            const SizedBox(height: kItemPadding),

            // Title
            if (review.title.isNotEmpty) ...[
              Text(
                review.title,
                style: TextStyles.defaultStyle.fontHeader.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                maxLines: showFullContent ? null : 2,
                overflow: showFullContent ? null : TextOverflow.ellipsis,
              ),
              const SizedBox(height: kTopPadding),
            ],

            // Content
            Text(
              review.comment,
              style: TextStyles.defaultStyle.copyWith(
                fontSize: 14,
                height: 1.5,
              ),
              maxLines: showFullContent ? null : 3,
              overflow: showFullContent ? null : TextOverflow.ellipsis,
            ),
            
            // Images
            if (review.imageUrls.isNotEmpty) ...[
              const SizedBox(height: kItemPadding),
              ReviewImagesRow(
                imageUrls: review.imageUrls,
                maxDisplay: 4,
              ),
            ],
            
            // Tags
            if (review.tags.isNotEmpty) ...[
              const SizedBox(height: kItemPadding),
              Wrap(
                spacing: kTopPadding,
                runSpacing: kTopPadding,
                children: review.tags.map((tag) => _buildTag(tag)).toList(),
              ),
            ],
            const SizedBox(height: kItemPadding),

            // Helpful section
            Row(
              children: [
                Text(
                  'Hữu ích?',
                  style: TextStyles.defaultStyle.subTitleTextColor.copyWith(
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: kItemPadding),
                _buildHelpfulButton(
                  Icons.thumb_up_outlined,
                  review.helpfulYes,
                  onHelpfulYes,
                ),
                const SizedBox(width: kTopPadding),
                _buildHelpfulButton(
                  Icons.thumb_down_outlined,
                  review.helpfulNo,
                  onHelpfulNo,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, IconData icon, {bool isHighlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kTopPadding,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isHighlight
            ? ColorPalette.primaryColor.withOpacity(0.1)
            : Colors.grey[200],
        borderRadius: BorderRadius.circular(kMinPadding),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isHighlight ? ColorPalette.primaryColor : Colors.grey[700],
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyles.defaultStyle.copyWith(
              fontSize: 12,
              color: isHighlight ? ColorPalette.primaryColor : Colors.grey[700],
              fontWeight: isHighlight ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kTopPadding,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: ColorPalette.primaryColor),
        borderRadius: BorderRadius.circular(kMinPadding),
      ),
      child: Text(
        tag,
        style: TextStyles.defaultStyle.copyWith(
          fontSize: 12,
          color: ColorPalette.primaryColor,
        ),
      ),
    );
  }

  Widget _buildHelpfulButton(IconData icon, int count, VoidCallback? onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(kMinPadding),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kTopPadding,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(kMinPadding),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              count.toString(),
              style: TextStyles.defaultStyle.copyWith(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
