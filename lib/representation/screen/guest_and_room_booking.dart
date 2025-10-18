import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:flutter_travels_apps/representation/widgets/button_widget.dart';
import 'package:flutter_travels_apps/representation/widgets/item_add_guest_and_room.dart';
class GuestAndRoomBookingScreen extends StatefulWidget {
  const GuestAndRoomBookingScreen({Key? key}) : super(key: key);


  static const String routeName = '/guest_and_room_booking_screen';
  
  @override
  State<GuestAndRoomBookingScreen> createState() => GuestAndRoomBookingState();
}


class GuestAndRoomBookingState extends State<GuestAndRoomBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Khách và Phòng',
      implementLeading: true,
      child: Column(
        children: [
          SizedBox(
            height: kMediumPadding * 1.5,
          ),
          ItemAddGuestAndRoom(
            icon: AssetHelper.icoGuest,
            innitData: 2,
            title: 'Khách',
          ),
          ItemAddGuestAndRoom(
            icon: AssetHelper.iconbed,
            innitData: 1,
            title: 'Phòng',
          ),
          ButtonWidget(
            title: 'Chọn',
            onTap: (){
              Navigator.of(context).pop();
            },
          ),
          SizedBox(
            height: kDefaultPadding,
          ),
          ButtonWidget(
            title: 'Hủy',
            onTap: (){
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}