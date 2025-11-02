import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/data/models/trip_plan_data.dart';
import 'package:flutter_travels_apps/representation/screen/accommodation_list_screen.dart';
import 'package:flutter_travels_apps/representation/widgets/common/app_bar_container.dart';

class AccommodationBookingScreen extends StatefulWidget {
  const AccommodationBookingScreen({Key? key}) : super(key: key);

  static const String routeName = '/accommodation_booking_screen';

  @override
  State<AccommodationBookingScreen> createState() =>
      _AccommodationBookingScreenState();
}

class _AccommodationBookingScreenState
    extends State<AccommodationBookingScreen> {
  late TripPlanData tripData;
  String selectedAccommodationType = 'Tất cả';
  String selectedBudgetRange = 'Mọi mức giá';
  bool _didNavigate = false; // tránh điều hướng lặp nếu build lại

  @override
  void initState() {
    super.initState();

    // Điều hướng sau khi khung hình đầu tiên render để có context hợp lệ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args is TripPlanData) {
        tripData = args;
      } else {
        tripData = TripPlanData();
      }

      // 👉 Vào thẳng danh sách nơi lưu trú, bỏ màn trung gian
      if (!_didNavigate) {
        _didNavigate = true;
        Navigator.of(context).pushReplacementNamed(
          AccommodationListScreen.routeName,
          arguments: {
            'tripData': tripData,
            'accommodationType': selectedAccommodationType,
            'budgetRange': selectedBudgetRange,
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Hiển thị loader rất ngắn trước khi chuyển màn
    return AppBarContainerWidget(
      titleString: 'Gợi ý Nơi Lưu Trú',
      implementLeading: true,
      child: SizedBox(
        height: kDefaultPadding * 10,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
