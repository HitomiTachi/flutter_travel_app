import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/core/helpers/images_helpers.dart';
import 'package:flutter_travels_apps/representation/widgets/common/button_widget.dart';
import 'package:flutter_travels_apps/representation/widgets/common/dashline_widget.dart';
import 'package:flutter_travels_apps/representation/screen/accommodation_details_screen.dart';
import 'package:flutter_travels_apps/data/models/accommodation_model.dart';
import 'package:flutter_travels_apps/data/models/trip_plan_data.dart';

class ItemAccommodationWidget extends StatelessWidget {
  const ItemAccommodationWidget({
    Key? key,
    required this.accommodationModel,
    required this.tripData,
  }) : super(key: key);

  final AccommodationModel accommodationModel;
  final TripPlanData tripData;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultPadding),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(bottom: kMediumPadding),
      child: Column(
        children: [
          // Ảnh lớn, bo góc trên trái + dưới phải như Hotel
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(right: kDefaultPadding),
            child: ImageHelper.loadFromAsset(
              accommodationModel.imageUrl,
              radius: const BorderRadius.only(
                topLeft: Radius.circular(kDefaultPadding),
                bottomRight: Radius.circular(kDefaultPadding),
              ),
            ),
          ),

          // Nội dung
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: kDefaultPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên nơi lưu trú
                Text(
                  accommodationModel.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: kDefaultPadding),

                // Dòng vị trí (icon location + location + khoảng cách giả lập nếu cần)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: ImageHelper.loadFromAsset(AssetHelper.iconlocation),
                    ),
                    const SizedBox(width: kMinPadding),
                    Text(
                      accommodationModel.location,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: kMinPadding),
                    Expanded(
                      child: Text(
                        // Nếu có field khoảng cách thì thay bằng field thật;
                        // ở đây mô phỏng “gần trung tâm”
                        'gần trung tâm',
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

                const SizedBox(height: kDefaultPadding),

                // Dòng sao + reviews (icoStar)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: ImageHelper.loadFromAsset(AssetHelper.icoStar),
                    ),
                    const SizedBox(width: kMinPadding),
                    Text(
                      accommodationModel.rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.amber[700],
                      ),
                    ),
                    const SizedBox(width: kMinPadding),
                    Text(
                      '(${accommodationModel.reviewCount} reviews)',
                      style: TextStyle(
                        color: ColorPalette.subTitleColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: kDefaultPadding),
                const DashlineWidget(),
                const SizedBox(height: kDefaultPadding),

                // Giá + nút bên phải (giống Hotel)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // formattedPrice là VNĐ; bạn có thể đổi sang $ nếu muốn
                          Text(
                            accommodationModel.formattedPrice,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: ColorPalette.primaryColor,
                            ),
                          ),
                          const SizedBox(height: kMinPadding),
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
                        title: 'Xem chi tiết',
                        onTap: () => _addToTripPlan(context),
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

  void _addToTripPlan(BuildContext context) {
    // Điều hướng đến trang chi tiết accommodation
    Navigator.of(context).pushNamed(
      AccommodationDetailsScreen.routeName,
      arguments: {
        'accommodationModel': accommodationModel,
        'tripData': tripData,
      },
    );
  }
}
