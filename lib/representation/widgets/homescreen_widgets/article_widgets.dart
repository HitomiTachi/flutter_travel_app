import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:flutter_travels_apps/core/helpers/navigation_helper.dart';
import 'package:flutter_travels_apps/data/models/featured_article.dart';
import 'package:flutter_travels_apps/data/mock/article_data_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ============================================================================
// ĐÁNH GIÁ NỔI BẬT (Thay thế "Bài viết nổi bật")
// ============================================================================
class FeaturedArticlesWidget extends StatelessWidget {
  const FeaturedArticlesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final articles = ArticleDataProvider.getFeaturedArticles();
    final displayedArticles = articles.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Đánh giá nổi bật',
                style: TextStyles.defaultStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.textColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Điều hướng tab “Bài viết” như trước
                  NavigationHelper().goToLike(initialTab: 1, showAll: true);
                },
                child: Text(
                  'Xem thêm',
                  style: TextStyles.defaultStyle.copyWith(
                    color: ColorPalette.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: kMediumPadding),

        // Horizontal Reviews ListView - trượt ngang giống Điểm đến phổ biến
        SizedBox(
          height: 340,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            itemCount: displayedArticles.length,
            itemBuilder: (context, index) {
              final article = displayedArticles[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < displayedArticles.length - 1 ? kDefaultPadding : 0,
                ),
                child: SizedBox(
                  width: 300,
                  child: _ReviewCard(article: article),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// REVIEW CARD WIDGET – dạng card đánh giá du lịch
// ============================================================================
class _ReviewCard extends StatelessWidget {
  final FeaturedArticle article;

  const _ReviewCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: ColorPalette.primaryColor.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kItemPadding),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kItemPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ảnh nền review - Giảm chiều cao
            Stack(
              children: [
                Image.asset(
                  article.imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // overlay nhẹ
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
                // rating + vị trí
                Positioned(
                  left: kDefaultPadding,
                  bottom: kDefaultPadding,
                  right: kDefaultPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                article.category,
                                style: TextStyles.defaultStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.star,
                                color: Colors.orange, size: 14),
                            SizedBox(width: 3),
                            Text(
                              "4.9",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Nội dung dưới ảnh - Tối ưu padding và spacing
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Avatar + Tên người đánh giá
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: AssetImage(article.imageUrl),
                      ),
                      const SizedBox(width: kDefaultPadding / 2),
                      Expanded(
                        child: Text(
                          article.author,
                          style: TextStyles.defaultStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(FontAwesomeIcons.solidHeart,
                              color: ColorPalette.yellowColor, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            article.likes.toString(),
                            style: TextStyles.defaultStyle.copyWith(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: kDefaultPadding / 2),

                  // Tiêu đề + mô tả ngắn
                  Text(
                    article.title,
                    style: TextStyles.defaultStyle.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.textColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    article.subtitle,
                    style: TextStyles.defaultStyle.copyWith(
                      color: Colors.grey[600],
                      fontSize: 12,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: kDefaultPadding / 2),

                  // Nút xem chi tiết
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: ColorPalette.primaryColor,
                        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        NavigationHelper().goToLike(
                            initialTab: 1, showAll: true);
                      },
                      icon: const Icon(Icons.arrow_forward_ios, size: 12),
                      label: const Text(
                        "Xem chi tiết",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
