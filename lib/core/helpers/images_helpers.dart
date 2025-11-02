import 'package:flutter/material.dart';

class ImageHelper {
  static Widget loadFromAsset(
    String imageFilePath, {
    double? width,
    double? height,
    BorderRadius? radius,
    BoxFit? fit,
    Color? tintColor,
    Alignment? alignment,
  }) {
    return ClipRRect(
      borderRadius: radius ?? BorderRadius.zero,
      child: Image.asset(
        imageFilePath,
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
        color: tintColor,
        alignment: alignment ?? Alignment.center,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: radius ?? BorderRadius.zero,
            ),
            child: Icon(
              Icons.image_not_supported_outlined,
              size: (width != null && height != null) ? (width < height ? width : height) * 0.5 : 24,
              color: Colors.grey.shade400,
            ),
          );
        },
      ),
    );
  }
}
