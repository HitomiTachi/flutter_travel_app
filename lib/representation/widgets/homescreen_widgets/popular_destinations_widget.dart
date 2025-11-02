import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:flutter_travels_apps/core/helpers/navigation_helper.dart';
import 'package:flutter_travels_apps/data/mock/destination_data_provider.dart';
import 'package:flutter_travels_apps/representation/widgets/homescreen_widgets/item_destination_widget.dart';

class PopularDestinationsWidget extends StatelessWidget {
  const PopularDestinationsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  final popularDestinations = DestinationDataProvider.getPopularDestinations();
  // Only show up to 10 items on home screen
  final visibleDestinations = popularDestinations.take(10).toList();
    
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
                'Điểm Đến Phổ Biến',
                style: TextStyles.defaultStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.textColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Sử dụng NavigationHelper để chuyển tab thay vì push screen mới
                  // Tab 0 = Địa điểm, showAll = true để hiển thị tất cả
                  NavigationHelper().goToLike(initialTab: 0, showAll: true);
                },
                child: Text(
                  'Xem thêm',
                  style: TextStyles.defaultStyle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ColorPalette.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: kMediumPadding),
        // Horizontal Destinations ListView
        Container(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            itemCount: visibleDestinations.length,
            itemBuilder: (context, index) {
              final destination = visibleDestinations[index];
              return ItemDestinationWidget(
                destination: destination, 
                index: index
              );
            },
          ),
        ),
      ],
    );
  }
}