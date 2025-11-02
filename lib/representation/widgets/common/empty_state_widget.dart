import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';

/// Empty state widget chung
class EmptyStateWidget extends StatelessWidget {
  final String title;
  
  const EmptyStateWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: ColorPalette.subTitleColor.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyles.defaultStyle.subTitleTextColor,
          ),
        ],
      ),
    );
  }
}
