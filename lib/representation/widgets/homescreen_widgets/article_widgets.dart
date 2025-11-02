import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:flutter_travels_apps/core/helpers/navigation_helper.dart';
import 'package:flutter_travels_apps/data/models/featured_article.dart';
import 'package:flutter_travels_apps/data/mock/article_data_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ============================================================================
// FEATURED ARTICLES CONTAINER WIDGET
// ============================================================================
class FeaturedArticlesWidget extends StatelessWidget {
  const FeaturedArticlesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final articles = ArticleDataProvider.getFeaturedArticles();
    // Show up to 10 articles on home screen
    final displayedArticles = articles.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bài viết nổi bật',
                style: TextStyles.defaultStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.textColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Sử dụng NavigationHelper để chuyển tab thay vì push screen mới
                  // Tab 1 = Bài viết, showAll = true để hiển thị tất cả
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
        SizedBox(height: kMediumPadding),

        // Large Featured Article
        if (displayedArticles.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: ItemLargeArticleWidget(article: displayedArticles[0]),
          ),
        SizedBox(height: kMediumPadding),

        // Compact Articles Grid
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Row(
            children: [
              if (displayedArticles.length > 1)
                Expanded(child: ItemCompactArticleWidget(article: displayedArticles[1])),
              if (displayedArticles.length > 2) SizedBox(width: kMediumPadding),
              if (displayedArticles.length > 2)
                Expanded(child: ItemCompactArticleWidget(article: displayedArticles[2])),
            ],
          ),
        ),
        SizedBox(height: kMediumPadding),

        // Horizontal Articles List
        Column(
          children: [
            for (var i = 3; i < displayedArticles.length; i++) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: ItemHorizontalArticleWidget(article: displayedArticles[i]),
              ),
              SizedBox(height: kMediumPadding),
            ],
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// LARGE ARTICLE WIDGET - For featured/highlighted articles
// ============================================================================
class ItemLargeArticleWidget extends StatelessWidget {
  final FeaturedArticle article;

  const ItemLargeArticleWidget({Key? key, required this.article})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      shadowColor: ColorPalette.primaryColor.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kTopPadding * 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kTopPadding * 2),
        child: Container(
          height: 300,
          child: Stack(
            children: [
              // Background Image
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(article.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      ColorPalette.primaryColor.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
              // Category Badge
              Positioned(
                top: kMediumPadding,
                left: kMediumPadding,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: kTopPadding,
                    vertical: kMinPadding,
                  ),
                  decoration: BoxDecoration(
                    color: ColorPalette.secondColor,
                    borderRadius: BorderRadius.circular(kMediumPadding),
                  ),
                  child: Text(
                    article.category,
                    style: TextStyles.defaultStyle.copyWith(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Content
              Positioned(
                bottom: kMediumPadding,
                left: kMediumPadding,
                right: kMediumPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      article.title,
                      style: TextStyles.defaultStyle.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: kMinPadding),
                    Text(
                      article.subtitle,
                      style: TextStyles.defaultStyle.copyWith(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: kTopPadding),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: Colors.white70,
                          size: kDefaultIconSize - 4,
                        ),
                        SizedBox(width: kMinPadding),
                        Text(
                          article.author,
                          style: TextStyles.defaultStyle.copyWith(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          FontAwesomeIcons.heart,
                          color: ColorPalette.yellowColor,
                          size: kDefaultIconSize - 4,
                        ),
                        SizedBox(width: kMinPadding),
                        Text(
                          article.likes.toString(),
                          style: TextStyles.defaultStyle.copyWith(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// COMPACT ARTICLE WIDGET - For grid layout
// ============================================================================
class ItemCompactArticleWidget extends StatelessWidget {
  final FeaturedArticle article;

  const ItemCompactArticleWidget({Key? key, required this.article})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: ColorPalette.primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kMediumPadding),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kMediumPadding),
        child: Container(
          height: 140,
          child: Stack(
            children: [
              // Background Image
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(article.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      ColorPalette.primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              // Category Badge
              Positioned(
                top: kTopPadding,
                left: kTopPadding,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: kTopPadding,
                    vertical: kMinPadding,
                  ),
                  decoration: BoxDecoration(
                    color: ColorPalette.secondColor,
                    borderRadius: BorderRadius.circular(kMediumPadding),
                  ),
                  child: Text(
                    article.category,
                    style: TextStyles.defaultStyle.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Content
              Positioned(
                bottom: kTopPadding,
                left: kTopPadding,
                right: kTopPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      article.title,
                      style: TextStyles.defaultStyle.copyWith(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: kMinPadding),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: Colors.white70,
                          size: kDefaultIconSize - 6,
                        ),
                        SizedBox(width: kMinPadding),
                        Text(
                          article.author,
                          style: TextStyles.defaultStyle.copyWith(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          FontAwesomeIcons.heart,
                          color: ColorPalette.yellowColor,
                          size: kDefaultIconSize - 6,
                        ),
                        SizedBox(width: kMinPadding),
                        Text(
                          article.likes.toString(),
                          style: TextStyles.defaultStyle.copyWith(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// HORIZONTAL ARTICLE WIDGET - For list layout
// ============================================================================
class ItemHorizontalArticleWidget extends StatelessWidget {
  final FeaturedArticle article;

  const ItemHorizontalArticleWidget({Key? key, required this.article})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: ColorPalette.primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kMediumPadding),
      ),
      child: Container(
        constraints: BoxConstraints(minHeight: 110, maxHeight: 130),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Section
            Container(
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(kMediumPadding),
                  bottomLeft: Radius.circular(kMediumPadding),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(article.imageUrl, fit: BoxFit.cover),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            ColorPalette.primaryColor.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                    // Category Badge
                    Positioned(
                      top: kTopPadding,
                      left: kTopPadding,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: kTopPadding,
                          vertical: kMinPadding / 2,
                        ),
                        decoration: BoxDecoration(
                          color: ColorPalette.secondColor,
                          borderRadius: BorderRadius.circular(kMediumPadding),
                        ),
                        child: Text(
                          article.category,
                          style: TextStyles.defaultStyle.copyWith(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content Section
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(kMediumPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          article.title,
                          style: TextStyles.defaultStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          article.subtitle,
                          style: TextStyles.defaultStyle.copyWith(
                            color: Colors.grey[600],
                            fontSize: 11,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    // Stats Row
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: Colors.grey[500],
                          size: kDefaultIconSize - 6,
                        ),
                        SizedBox(width: kMinPadding),
                        Text(
                          article.author,
                          style: TextStyles.defaultStyle.copyWith(
                            color: Colors.grey[500],
                            fontSize: 10,
                          ),
                        ),
                        SizedBox(width: kMediumPadding),
                        Icon(
                          FontAwesomeIcons.heart,
                          color: ColorPalette.yellowColor,
                          size: kDefaultIconSize - 6,
                        ),
                        SizedBox(width: kMinPadding),
                        Text(
                          article.likes.toString(),
                          style: TextStyles.defaultStyle.copyWith(
                            color: Colors.grey[500],
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
