import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:flutter_travels_apps/data/models/popular_destination.dart';
import 'package:flutter_travels_apps/representation/widgets/like_widgets/like_items/selectable_mark.dart';
import 'package:flutter_travels_apps/representation/widgets/like_widgets/like_items/thumbnail_widget.dart';

/// Grid card cho destination items
class PlaceCard extends StatelessWidget {
  final PopularDestination destination;
  final bool editMode;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const PlaceCard({
    Key? key,
    required this.destination,
    required this.editMode,
    required this.selected,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ThumbnailWidget(
                  imageUrl: destination.imageUrl,
                  height: 120,
                  width: double.infinity,
                  borderRadius: BorderRadius.zero,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              destination.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.defaultStyle.semiBold,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 14, color: ColorPalette.subTitleColor),
                                const SizedBox(width: 4),
                                Text(
                                  destination.country,
                                  style: TextStyles.defaultStyle.setTextSize(12).subTitleTextColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.star, color: ColorPalette.yellowColor, size: kDefaultIconSize),
                      const SizedBox(width: 4),
                      Text('${destination.rating}', style: TextStyles.defaultStyle.semiBold),
                    ],
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

/// List tile cho destination items
class PlaceTile extends StatelessWidget {
  final PopularDestination destination;
  final bool editMode;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const PlaceTile({
    Key? key,
    required this.destination,
    required this.editMode,
    required this.selected,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

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
                imageUrl: destination.imageUrl,
                height: 70,
                width: 100,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.defaultStyle.semiBold,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      destination.country,
                      style: TextStyles.defaultStyle.setTextSize(12).subTitleTextColor,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, color: ColorPalette.yellowColor, size: kDefaultIconSize),
                        const SizedBox(width: 4),
                        Text('${destination.rating}', style: TextStyles.defaultStyle.semiBold),
                      ],
                    ),
                  ],
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
