import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/extensions/date_ext.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/representation/screen/guest_and_room_booking.dart';
import 'package:flutter_travels_apps/representation/screen/hotel_screen.dart';
import 'package:flutter_travels_apps/representation/screen/select_date_screen.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:flutter_travels_apps/representation/widgets/button_widget.dart';
import 'package:flutter_travels_apps/representation/widgets/item_booking_widget.dart';

class HotelBookingScreen extends StatefulWidget {
  const HotelBookingScreen({Key? key}) : super(key: key);

  static const String routeName = '/hotel_booking_screen';
  @override
  State<HotelBookingScreen> createState() => _HotelBookingScreenState();
}

class _HotelBookingScreenState extends State<HotelBookingScreen> {

  String? dateSellected;


  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Đặt Phòng Khách Sạn',
      implementLeading: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: kMediumPadding * 2,
            ),
            ItemBookingWidget(icons: AssetHelper.iconlocation, 
            title: "Địa Điểm", 
            description: 'Quốc Tế Đà Nẵng, Việt Nam',
            onTap: (){},),
                        SizedBox(
              height: kMediumPadding,
            ),
            StatefulBuilder(
              builder: (context, setState) {
                return ItemBookingWidget(icons: AssetHelper.iconcalendar,
                  title: "Đặt lịch",
                  description: dateSellected ?? '13 Feb - 20 Feb 2025',
                  onTap: () async {
                  final result = await Navigator.of(context).pushNamed(SelectDateScreen.routeName);
                  if (result != null && (result as List<DateTime?>).any((element) => element != null)) {
                    dateSellected = '${result[0]?.getStartDate} - ${result[1]?.getEndDate}';
                    setState(() {
                    });
                  }
                },);
              }
            ),
                        SizedBox(
              height: kMediumPadding,
            ),
            ItemBookingWidget(icons: AssetHelper.iconbed, 
            title: "Đặt Phòng", 
            description: '2 Người, 1 Phòng',
            onTap: (){
              Navigator.of(context).pushNamed(GuestAndRoomBookingScreen.routeName);
            },),
            SizedBox(
              height: kMediumPadding,
            ),
            ButtonWidget(title: "Tìm Kiếm", onTap: (){
              Navigator.of(context).pushNamed(HotelScreen.routeName);
            })
          ],),
      ),
    );
  }
}