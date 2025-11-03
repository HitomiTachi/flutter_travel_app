import 'package:flutter/material.dart';
import '../../../core/constants/dismension_constants.dart';

/// Widget hiển thị hàng ảnh reviews theo chiều ngang
class ReviewImagesRow extends StatelessWidget {
  final List<String> imageUrls;
  final int maxDisplay;
  final double imageSize;
  final VoidCallback? onImageTap;

  const ReviewImagesRow({
    Key? key,
    required this.imageUrls,
    this.maxDisplay = 4,
    this.imageSize = 80,
    this.onImageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayImages = imageUrls.take(maxDisplay).toList();
    final remaining = imageUrls.length - maxDisplay;

    return SizedBox(
      height: imageSize,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: displayImages.length,
        itemBuilder: (context, index) {
          final isLast = index == displayImages.length - 1;
          final showOverlay = isLast && remaining > 0;

          return GestureDetector(
            onTap: onImageTap,
            child: Container(
              width: imageSize,
              height: imageSize,
              margin: EdgeInsets.only(
                right: index < displayImages.length - 1 ? kTopPadding : 0,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(kTopPadding),
                    child: Image.asset(
                      displayImages[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  if (showOverlay)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(kTopPadding),
                      child: Container(
                        color: Colors.black.withOpacity(0.6),
                        child: Center(
                          child: Text(
                            '+$remaining',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
