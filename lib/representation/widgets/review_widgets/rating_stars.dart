import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/textstyle_constants.dart';

/// Widget hiển thị rating stars (có thể tương tác hoặc chỉ hiển thị)
class RatingStars extends StatefulWidget {
  final double rating;
  final bool interactive;
  final ValueChanged<double>? onRatingChanged;
  final double size;
  final Color activeColor;
  final Color inactiveColor;

  const RatingStars({
    Key? key,
    required this.rating,
    this.interactive = false,
    this.onRatingChanged,
    this.size = 24,
    this.activeColor = ColorPalette.yellowColor,
    this.inactiveColor = const Color(0xFFE0E0E0),
  }) : super(key: key);

  @override
  State<RatingStars> createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
  }

  @override
  void didUpdateWidget(RatingStars oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rating != oldWidget.rating) {
      _currentRating = widget.rating;
    }
  }

  void _handleTap(int index) {
    if (!widget.interactive) return;
    
    setState(() {
      _currentRating = (index + 1).toDouble();
    });
    
    widget.onRatingChanged?.call(_currentRating);
  }

  Widget _buildStar(int index) {
    final starValue = index + 1;
    IconData iconData;
    Color color;

    if (_currentRating >= starValue) {
      iconData = Icons.star;
      color = widget.activeColor;
    } else if (_currentRating > starValue - 1 && _currentRating < starValue) {
      iconData = Icons.star_half;
      color = widget.activeColor;
    } else {
      iconData = Icons.star_border;
      color = widget.inactiveColor;
    }

    return GestureDetector(
      onTap: widget.interactive ? () => _handleTap(index) : null,
      child: Icon(
        iconData,
        size: widget.size,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) => _buildStar(index)),
    );
  }
}

/// Widget compact hiển thị rating và số lượng reviews
class CompactRating extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final double starSize;
  final TextStyle? textStyle;

  const CompactRating({
    Key? key,
    required this.rating,
    required this.reviewCount,
    this.starSize = 16,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star,
          size: starSize,
          color: ColorPalette.yellowColor,
        ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: textStyle ?? TextStyles.defaultStyle.fontHeader.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '($reviewCount)',
          style: textStyle ?? TextStyles.defaultStyle.subTitleTextColor.copyWith(
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
