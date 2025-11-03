import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/core/helpers/images_helpers.dart';
import 'package:flutter_travels_apps/data/models/hotel_model.dart';
import 'package:flutter_travels_apps/representation/widgets/common/button_widget.dart';
import 'package:flutter_travels_apps/representation/widgets/common/dashline_widget.dart';

class ItemHotelWidget extends StatelessWidget {
  const ItemHotelWidget({super.key, required this.hotelModel});

  final HotelModel hotelModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultPadding),
        color: Colors.white,
      ),
      margin: EdgeInsets.only(
        bottom: kMediumPadding,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              right: kDefaultPadding,
            ),
            child: ImageHelper.loadFromAsset(
              hotelModel.hotelImage,
              radius: BorderRadius.only(
                topLeft: Radius.circular(kDefaultPadding),
                bottomRight: Radius.circular(kDefaultPadding),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: kDefaultPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotelModel.hotelName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ), // Text
                SizedBox(
                  height: kDefaultPadding,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: ImageHelper.loadFromAsset(AssetHelper.iconlocation),
                    ),
                    SizedBox(
                      width: kMinPadding,
                    ),
                    Text(
                      hotelModel.location,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: kMinPadding),
                    Expanded(
                      child: Text(
                        '${hotelModel.awayKilometer} km cách điểm đến',
                        style: TextStyle(
                          color: ColorPalette.subTitleColor,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                    SizedBox(
                  height: kDefaultPadding,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: ImageHelper.loadFromAsset(AssetHelper.icoStar),
                    ),
                    SizedBox(
                      width: kMinPadding,
                    ),
                    Text(
                      hotelModel.star.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.amber[700],
                      ),
                    ),
                    SizedBox(width: kMinPadding),
                    Text(
                      '(${hotelModel.numberOfReview} reviews)',
                      style: TextStyle(
                        color: ColorPalette.subTitleColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                  SizedBox(height: kDefaultPadding),
                  DashlineWidget(),
                  SizedBox(height: kDefaultPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${hotelModel.price}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: ColorPalette.primaryColor,
                              ),
                            ),
                            SizedBox(
                              height: kMinPadding,
                            ),
                            Text(
                              '/đêm',
                              style: TextStyle(
                                color: ColorPalette.subTitleColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ButtonWidget(
                          title: 'Đặt phòng',
                          onTap: () {
                            // TODO: Navigate to booking screen
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Chức năng đang phát triển')),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
