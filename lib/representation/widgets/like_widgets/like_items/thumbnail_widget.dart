import 'package:flutter/material.dart';

/// Widget thumbnail chung cho các item cards
class ThumbnailWidget extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final BorderRadiusGeometry borderRadius;

  const ThumbnailWidget({
    Key? key,
    required this.imageUrl,
    required this.height,
    required this.width,
    required this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.asset(imageUrl, height: height, width: width, fit: BoxFit.cover),
    );
  }
}
