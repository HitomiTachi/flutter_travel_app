import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/data/models/hotel_model.dart';
import 'package:flutter_travels_apps/representation/widgets/common/app_bar_container.dart';
import 'package:flutter_travels_apps/representation/widgets/hotel_boking_widgets/item_hotel_widget.dart';

class HotelScreen extends StatefulWidget {
  const HotelScreen({super.key});


  static const String routeName = '/hotel_screen';
  @override
  State<HotelScreen> createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {

  List<HotelModel> listHotel = [
  HotelModel(
    hotelImage: AssetHelper.imgHotel1,
    hotelName: "Royal Pain Heritage",
    location: "Purwokerto, Jateng",
    awayKilometer: "364",
    star: 4.5,
    numberOfReview: 3241,
    price: 143,
  ),
  HotelModel(
    hotelImage: AssetHelper.imgHotel2,
    hotelName: "Grand Mahkota Palace",
    location: "Yogyakarta, DIY",
    awayKilometer: "287",
    star: 4.8,
    numberOfReview: 2156,
    price: 189,
  ),
  HotelModel(
    hotelImage: AssetHelper.imgHotel3,
    hotelName: "Tugu Malang Resort",
    location: "Malang, Jatim",
    awayKilometer: "432",
    star: 4.3,
    numberOfReview: 1875,
    price: 167,
  ),
];


  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Khách Sạn',
      implementLeading: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...listHotel.map((e) => ItemHotelWidget(hotelModel: e)),
          ],
        ),
      )
    );
  }
}