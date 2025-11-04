import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dismension_constants.dart';
import '../../../core/constants/textstyle_constants.dart';
import 'rating_stars.dart';

/// Widget hiển thị tổng quan rating của địa điểm
class ReviewSummaryWidget extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution;
  final double recommendedPercentage;
  final VoidCallback? onViewAllPressed;

  const ReviewSummaryWidget({
    Key? key,
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
    required this.recommendedPercentage,
    this.onViewAllPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kDefaultPadding),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Đánh giá & Nhận xét',
                style: TextStyles.defaultStyle.fontHeader.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (onViewAllPressed != null)
                TextButton(
                  onPressed: onViewAllPressed,
                  child: Text(
                    'Xem tất cả',
                    style: TextStyles.defaultStyle.copyWith(
                      color: ColorPalette.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: kDefaultPadding),

          // Rating overview
          Row(
            children: [
              // Số rating lớn
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    averageRating.toStringAsFixed(1),
                    style: TextStyles.defaultStyle.fontHeader.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RatingStars(
                    rating: averageRating,
                    size: 20,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$totalReviews đánh giá',
                    style: TextStyles.defaultStyle.subTitleTextColor.copyWith(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: kMediumPadding),

              // Rating bars
              Expanded(
                child: Column(
                  children: List.generate(5, (index) {
                    final stars = 5 - index;
                    final count = ratingDistribution[stars] ?? 0;
                    final percentage = totalReviews > 0 ? count / totalReviews : 0.0;
                    
                    return _buildRatingBar(stars, percentage, count);
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: kDefaultPadding),

          // Recommended percentage
          Container(
            padding: const EdgeInsets.all(kItemPadding),
            decoration: BoxDecoration(
              color: ColorPalette.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(kItemPadding),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.thumb_up,
                  color: ColorPalette.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: kTopPadding),
                Text(
                  '${recommendedPercentage.toStringAsFixed(0)}% khách hàng đề xuất địa điểm này',
                  style: TextStyles.defaultStyle.copyWith(
                    color: ColorPalette.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int stars, double percentage, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kMinPadding),
      child: Row(
        children: [
          Text(
            '$stars',
            style: TextStyles.defaultStyle.copyWith(fontSize: 13),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.star,
            size: 14,
            color: ColorPalette.yellowColor,
          ),
          const SizedBox(width: kTopPadding),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  ColorPalette.yellowColor,
                ),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: kTopPadding),
          SizedBox(
            width: 30,
            child: Text(
              '$count',
              style: TextStyles.defaultStyle.subTitleTextColor.copyWith(
                fontSize: 12,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
