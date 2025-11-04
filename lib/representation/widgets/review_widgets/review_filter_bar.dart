import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dismension_constants.dart';
import '../../../data/models/review_model.dart';

/// Widget filter bar cho reviews
class ReviewFilterBar extends StatelessWidget {
  final ReviewSortType selectedSort;
  final TripType selectedTripType;
  final double? selectedMinRating;
  final bool showVerifiedOnly;
  final ValueChanged<ReviewSortType> onSortChanged;
  final ValueChanged<TripType> onTripTypeChanged;
  final ValueChanged<double?> onMinRatingChanged;
  final ValueChanged<bool> onVerifiedChanged;

  const ReviewFilterBar({
    Key? key,
    required this.selectedSort,
    required this.selectedTripType,
    this.selectedMinRating,
    required this.showVerifiedOnly,
    required this.onSortChanged,
    required this.onTripTypeChanged,
    required this.onMinRatingChanged,
    required this.onVerifiedChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kItemPadding,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sort options
          Row(
            children: [
              const Icon(
                Icons.sort,
                size: 20,
                color: ColorPalette.primaryColor,
              ),
              const SizedBox(width: kTopPadding),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ReviewSortType.values.map((sortType) {
                      final isSelected = selectedSort == sortType;
                      return Padding(
                        padding: const EdgeInsets.only(right: kTopPadding),
                        child: ChoiceChip(
                          label: Text(sortType.label),
                          selected: isSelected,
                          onSelected: (_) => onSortChanged(sortType),
                          selectedColor: ColorPalette.primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontSize: 13,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: kItemPadding),

          // Trip type filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...TripType.values.map((tripType) {
                  final isSelected = selectedTripType == tripType;
                  return Padding(
                    padding: const EdgeInsets.only(right: kTopPadding),
                    child: FilterChip(
                      label: Text(tripType.label),
                      selected: isSelected,
                      onSelected: (_) => onTripTypeChanged(tripType),
                      selectedColor: ColorPalette.primaryColor.withOpacity(0.2),
                      checkmarkColor: ColorPalette.primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected ? ColorPalette.primaryColor : Colors.black87,
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(width: kTopPadding),
                // Rating filter
                PopupMenuButton<double?>(
                  child: Chip(
                    label: Text(
                      selectedMinRating != null
                          ? '${selectedMinRating!.toInt()}+ sao'
                          : 'Đánh giá',
                    ),
                    avatar: const Icon(Icons.star, size: 16),
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: null,
                      child: Text('Tất cả'),
                    ),
                    const PopupMenuItem(
                      value: 5.0,
                      child: Text('5 sao'),
                    ),
                    const PopupMenuItem(
                      value: 4.0,
                      child: Text('4+ sao'),
                    ),
                    const PopupMenuItem(
                      value: 3.0,
                      child: Text('3+ sao'),
                    ),
                  ],
                  onSelected: onMinRatingChanged,
                ),
                const SizedBox(width: kTopPadding),
                // Verified filter
                FilterChip(
                  label: const Text('Đã xác thực'),
                  selected: showVerifiedOnly,
                  onSelected: onVerifiedChanged,
                  selectedColor: Colors.green.withOpacity(0.2),
                  checkmarkColor: Colors.green,
                  avatar: Icon(
                    Icons.verified,
                    size: 16,
                    color: showVerifiedOnly ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
