import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:flutter_travels_apps/data/models/featured_article.dart';
import 'package:flutter_travels_apps/representation/widgets/like_widgets/like_items/selectable_mark.dart';
import 'package:flutter_travels_apps/representation/widgets/like_widgets/like_items/thumbnail_widget.dart';

/// Grid card cho article items
class ArticleCard extends StatelessWidget {
  final FeaturedArticle article;
  final bool editMode;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ArticleCard({
    super.key,
    required this.article,
    required this.editMode,
    required this.selected,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      color: Colors.white,
      borderRadius: BorderRadius.circular(kItemPadding + 2),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: ThumbnailWidget(
                    imageUrl: article.imageUrl,
                    height: double.infinity,
                    width: double.infinity,
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(kTopPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          article.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.defaultStyle.semiBold.fontCaption,
                        ),
                        const SizedBox(height: kMinPadding - 1),
                        Text(
                          article.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.defaultStyle.fontCaption.copyWith(fontSize: 11).subTitleTextColor,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(Icons.person_outline, size: kDefaultIconSize - 4, color: ColorPalette.subTitleColor),
                            const SizedBox(width: kMinPadding - 1),
                            Expanded(
                              child: Text(
                                article.author,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.defaultStyle.fontCaption.copyWith(fontSize: 11).subTitleTextColor,
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
            SelectableMark(visible: editMode, selected: selected),
          ],
        ),
      ),
    );
  }
}

/// List tile cho article items
class ArticleTile extends StatelessWidget {
  final FeaturedArticle article;
  final bool editMode;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ArticleTile({
    super.key,
    required this.article,
    required this.editMode,
    required this.selected,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1.5,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ThumbnailWidget(
                imageUrl: article.imageUrl,
                height: 70,
                width: 100,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.defaultStyle.semiBold,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: kDefaultIconSize, color: ColorPalette.subTitleColor),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              article.author,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.defaultStyle.setTextSize(12).subTitleTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SelectableMark(visible: editMode, selected: selected),
            ],
          ),
        ),
      ),
    );
  }
}
