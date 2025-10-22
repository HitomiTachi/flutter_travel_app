import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:flutter_travels_apps/data/models/popular_destination.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ItemDestinationWidget extends StatelessWidget {
  final PopularDestination destination;
  final int index;

  const ItemDestinationWidget({
    Key? key,
    required this.destination,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: EdgeInsets.only(right: kDefaultPadding),
      child: Card(
        elevation: 12,
        shadowColor: ColorPalette.primaryColor.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kTopPadding * 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(kTopPadding * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Stack(
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(destination.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Gradient Overlay
                  Container(
                    height: 180,
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
                  // Popular Badge
                  if (destination.isPopular)
                    Positioned(
                      top: kMediumPadding,
                      right: kMediumPadding,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: kItemPadding,
                          vertical: kMinPadding,
                        ),
                        decoration: BoxDecoration(
                          color: ColorPalette.yellowColor,
                          borderRadius: BorderRadius.circular(kTopPadding * 2),
                          boxShadow: [
                            BoxShadow(
                              color: ColorPalette.yellowColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'Phổ biến',
                          style: TextStyles.defaultStyle.copyWith(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  // Rating Badge
                  Positioned(
                    bottom: kMediumPadding,
                    left: kMediumPadding,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: kItemPadding,
                        vertical: kMinPadding,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(kTopPadding),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            FontAwesomeIcons.star,
                            color: ColorPalette.yellowColor,
                            size: kDefaultIconSize - 4,
                          ),
                          SizedBox(width: kMinPadding),
                          Text(
                            destination.rating.toString(),
                            style: TextStyles.defaultStyle.copyWith(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Content Section
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        destination.name,
                        style: TextStyles.defaultStyle.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: kMinPadding),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.locationDot,
                            color: ColorPalette.subTitleColor,
                            size: kDefaultIconSize - 4,
                          ),
                          SizedBox(width: kMinPadding),
                          Expanded(
                            child: Text(
                              destination.country,
                              style: TextStyles.defaultStyle.copyWith(
                                fontSize: 13,
                                color: ColorPalette.subTitleColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: kTopPadding),
                      Expanded(
                        child: Text(
                          destination.description,
                          style: TextStyles.defaultStyle.copyWith(
                            fontSize: 12,
                            color: ColorPalette.subTitleColor,
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: kTopPadding),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.users,
                            color: ColorPalette.primaryColor,
                            size: kDefaultIconSize - 6,
                          ),
                          SizedBox(width: kMinPadding),
                          Text(
                            '${destination.reviewCount}+ đánh giá',
                            style: TextStyles.defaultStyle.copyWith(
                              fontSize: 11,
                              color: ColorPalette.primaryColor,
                              fontWeight: FontWeight.w500,
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
      ),
    );
  }
}