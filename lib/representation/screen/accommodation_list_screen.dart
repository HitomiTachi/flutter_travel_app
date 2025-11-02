import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/data/models/accommodation_model.dart';
import 'package:flutter_travels_apps/data/models/trip_plan_data.dart';
import 'package:flutter_travels_apps/representation/widgets/common/app_bar_container.dart';
import 'package:flutter_travels_apps/representation/widgets/hotel_boking_widgets/item_accommodation_widget.dart';

class AccommodationListScreen extends StatefulWidget {
  const AccommodationListScreen({Key? key}) : super(key: key);

  static const String routeName = '/accommodation_list_screen';

  @override
  State<AccommodationListScreen> createState() => _AccommodationListScreenState();
}

class _AccommodationListScreenState extends State<AccommodationListScreen> {
  late TripPlanData tripData;
  List<AccommodationModel> accommodations = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic> && args['tripData'] is TripPlanData) {
        tripData = args['tripData'] as TripPlanData;
      } else {
        tripData = TripPlanData();
      }
      _loadMock();
      setState(() {});
    });
  }

  void _loadMock() {
    accommodations = [
      AccommodationModel(
        id: '1',
        name: "Royal Heritage Hotel",
        type: "Khách sạn",
        location: "Trung tâm Hà Nội",
        imageUrl: AssetHelper.imgHotel1,
        rating: 4.8,
        reviewCount: 1247,
        pricePerNight: 2500000,
        amenities: ['WiFi miễn phí', 'Bể bơi', 'Spa', 'Nhà hàng'],
        description: "Khách sạn sang trọng với thiết kế cổ điển",
      ),
      AccommodationModel(
        id: '2',
        name: "Cozy Family Homestay",
        type: "Homestay",
        location: "Phố cổ Hà Nội",
        imageUrl: AssetHelper.imgHotel2,
        rating: 4.5,
        reviewCount: 523,
        pricePerNight: 800000,
        amenities: ['WiFi miễn phí', 'Bếp', 'Máy giặt'],
        description: "Homestay ấm cúng giữa lòng phố cổ",
      ),
      AccommodationModel(
        id: '3',
        name: "Sunset Beach Resort",
        type: "Resort",
        location: "Hạ Long Bay",
        imageUrl: AssetHelper.imgHotel3,
        rating: 4.9,
        reviewCount: 2156,
        pricePerNight: 3200000,
        amenities: ['Bãi biển riêng', 'Spa', 'Golf', 'Nhà hàng'],
        description: "Resort cao cấp với view biển tuyệt đẹp",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Gợi ý Nơi Lưu Trú',
      implementLeading: true,
      child: SingleChildScrollView(
        child: Column(
          children: accommodations
              .map((e) => ItemAccommodationWidget(
                    accommodationModel: e,
                    tripData: tripData,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
