import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:flutter_travels_apps/data/models/trip_plan_list_model.dart';
import 'package:flutter_travels_apps/representation/widgets/like_widgets/like_items/selectable_mark.dart';
import 'package:flutter_travels_apps/representation/widgets/like_widgets/like_items/thumbnail_widget.dart';

/// Card cho trip plan items
class TripCard extends StatelessWidget {
  final TripPlan item;
  final bool editMode;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const TripCard({
    super.key,
    required this.item,
    required this.editMode,
    required this.selected,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  ThumbnailWidget(
                    imageUrl: item.imageUrl,
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
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.defaultStyle.semiBold,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.destination,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.defaultStyle.setTextSize(12).subTitleTextColor,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14, color: ColorPalette.subTitleColor),
                            const SizedBox(width: 4),
                            Text(
                              item.duration,
                              style: TextStyles.defaultStyle.setTextSize(12).subTitleTextColor,
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.place, size: 14, color: ColorPalette.subTitleColor),
                            const SizedBox(width: 4),
                            Text(
                              '${item.activities} hoạt động',
                              style: TextStyles.defaultStyle.setTextSize(12).subTitleTextColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SelectableMark(visible: editMode, selected: selected),
          ],
        ),
      ),
    );
  }
}
