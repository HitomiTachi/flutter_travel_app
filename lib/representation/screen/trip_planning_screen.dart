import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:flutter_travels_apps/representation/widgets/button_widget.dart';
import 'package:flutter_travels_apps/representation/widgets/item_add_trip_component.dart';
import 'package:flutter_travels_apps/data/models/trip_plan_data.dart';

class TripPlanningScreen extends StatefulWidget {
  const TripPlanningScreen({Key? key}) : super(key: key);

  static const String routeName = '/trip_planning_screen';
  
  @override
  State<TripPlanningScreen> createState() => _TripPlanningScreenState();
}

class _TripPlanningScreenState extends State<TripPlanningScreen> {
  late TripPlanData tripData;
  int travelers = 2;
  int destinations = 1;
  int activities = 3;

  @override
  void initState() {
    super.initState();
    // Nhận dữ liệu từ màn hình trước
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is TripPlanData) {
        setState(() {
          tripData = args;
          travelers = tripData.travelers;
          destinations = tripData.destinations;
          activities = tripData.activitiesPerDay;
        });
      } else {
        tripData = TripPlanData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Kế Hoạch Chuyến Đi',
      implementLeading: true,
      child: Column(
        children: [
          const SizedBox(height: kMediumPadding * 1.5),
          
          // Số người tham gia
          ItemAddTripComponent(
            icon: AssetHelper.icoGuest,
            innitData: travelers,
            title: 'Số người tham gia',
            minValue: 1,
            maxValue: 20,
            onValueChanged: (value) {
              setState(() {
                travelers = value;
              });
            },
          ),
          
          // Số địa điểm muốn thăm
          ItemAddTripComponent(
            icon: AssetHelper.iconlocation,
            innitData: destinations,
            title: 'Địa điểm tham quan',
            minValue: 1,
            maxValue: 10,
            onValueChanged: (value) {
              setState(() {
                destinations = value;
              });
            },
          ),
          
          // // Số hoạt động mỗi ngày
          // ItemAddTripComponent(
          //   icon: AssetHelper.iconcalendar,
          //   innitData: activities,
          //   title: 'Hoạt động/ngày',
          //   minValue: 1,
          //   maxValue: 8,
          //   onValueChanged: (value) {
          //     setState(() {
          //       activities = value;
          //     });
          //   },
          // ),
          
          // // Số ngày du lịch
          // ItemAddTripComponent(
          //   icon: AssetHelper.iconbed, // Tạm dùng icon này, có thể thay bằng icon lịch khác
          //   innitData: days,
          //   title: 'Số ngày du lịch',
          //   minValue: 1,
          //   maxValue: 30,
          //   onValueChanged: (value) {
          //     setState(() {
          //       days = value;
          //     });
          //   },
          // ),
          
          // Số hoạt động mỗi ngày
          ItemAddTripComponent(
            icon: AssetHelper.iconcalendar,
            innitData: activities,
            title: 'Hoạt động/ngày',
            minValue: 1,
            maxValue: 8,
            onValueChanged: (value) {
              setState(() {
                activities = value;
              });
            },
          ),
          
          // Số ngày sẽ được tự động tính từ thời gian chọn ở màn hình trước
          
          const Spacer(),
          
          // Nút tạo kế hoạch
          ButtonWidget(
            title: 'Tạo Kế Hoạch',
            onTap: () {
              // Cập nhật dữ liệu và trả về
              tripData = tripData.copyWith(
                travelers: travelers,
                destinations: destinations,
                activitiesPerDay: activities,
              );
              Navigator.of(context).pop(tripData);
            },
          ),
          
          const SizedBox(height: kDefaultPadding),
          
          ButtonWidget(
            title: 'Hủy',
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }


}