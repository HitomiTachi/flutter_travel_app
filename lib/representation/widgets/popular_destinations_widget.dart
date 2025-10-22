import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:flutter_travels_apps/data/models/destination_data.dart';
import 'package:flutter_travels_apps/representation/widgets/item_destination_widget.dart';

class PopularDestinationsWidget extends StatelessWidget {
  const PopularDestinationsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final popularDestinations = DestinationData.popularDestinations;
    
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tính năng đang phát triển'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
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
            itemCount: popularDestinations.length,
            itemBuilder: (context, index) {
              final destination = popularDestinations[index];
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