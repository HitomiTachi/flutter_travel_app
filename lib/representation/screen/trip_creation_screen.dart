import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/extenstions/date_ext.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/representation/screen/trip_planning_screen.dart';
import 'package:flutter_travels_apps/representation/screen/detailed_trip_plan_screen.dart';
import 'package:flutter_travels_apps/representation/screen/accommodation_booking_screen.dart';
import 'package:flutter_travels_apps/representation/screen/select_date_screen.dart';
import 'package:flutter_travels_apps/data/models/trip_plan_data.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:flutter_travels_apps/representation/widgets/button_widget.dart';
import 'package:flutter_travels_apps/representation/widgets/item_booking_widget.dart';

class TripCreationScreen extends StatefulWidget {
  const TripCreationScreen({Key? key}) : super(key: key);

  static const String routeName = '/trip_creation_screen';
  
  @override
  State<TripCreationScreen> createState() => _TripCreationScreenState();
}

class _TripCreationScreenState extends State<TripCreationScreen> {
  late TripPlanData tripData;

  @override
  void initState() {
    super.initState();
    tripData = TripPlanData();
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Tạo Kế Hoạch Chuyến Đi',
      implementLeading: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: kMediumPadding * 2),
            
            // Chọn điểm đến
            ItemBookingWidget(
              icons: AssetHelper.iconlocation, 
              title: "Điểm Đến", 
              description: tripData.destination,
              onTap: () {
                _showDestinationPicker();
              },
            ),
            
            const SizedBox(height: kMediumPadding),
            
            // Chọn thời gian
            ItemBookingWidget(
              icons: AssetHelper.iconcalendar,
              title: "Thời Gian Du Lịch",
              description: tripData.dateRange,
              onTap: () async {
                final result = await Navigator.of(context).pushNamed(SelectDateScreen.routeName);
                if (result != null && (result as List<DateTime?>).any((element) => element != null)) {
                  setState(() {
                    tripData = tripData.copyWith(
                      startDate: result[0]?.getStartDate ?? tripData.startDate,
                      endDate: result[1]?.getEndDate ?? tripData.endDate,
                    );
                  });
                }
              },
            ),
            
            const SizedBox(height: kMediumPadding),
            
            // Chi tiết kế hoạch
            ItemBookingWidget(
              icons: AssetHelper.iconbed, 
              title: "Chi Tiết Kế Hoạch", 
              description: tripData.planSummary,
              onTap: () async {
                final result = await Navigator.of(context).pushNamed(
                  TripPlanningScreen.routeName,
                  arguments: tripData,
                );
                if (result != null && result is TripPlanData) {
                  setState(() {
                    tripData = result;
                  });
                }
              },
            ),
            
            const SizedBox(height: kMediumPadding),
            
            // Hiển thị thông tin tổng hợp
            _buildTripSummaryCard(),
            
            const SizedBox(height: kMediumPadding),
            
            // Chọn nơi lưu trú
            ItemBookingWidget(
              icons: AssetHelper.iconbed,
              title: "Chọn Nơi Lưu Trú", 
              description: 'Khách sạn, Homestay, Resort...',
              onTap: () async {
                final result = await Navigator.of(context).pushNamed(
                  AccommodationBookingScreen.routeName,
                  arguments: tripData,
                );
                if (result != null && result is TripPlanData) {
                  setState(() {
                    tripData = result;
                  });
                }
              },
            ),
            
            const SizedBox(height: kMediumPadding),
            
            // Tạo kế hoạch chi tiết
            ButtonWidget(
              title: "Tạo Kế Hoạch Chi Tiết", 
              onTap: () {
                Navigator.of(context).pushNamed(
                  DetailedTripPlanScreen.routeName,
                  arguments: tripData,
                );
              }
            ),
            
            const SizedBox(height: kDefaultPadding),
            
            // Các tùy chọn bổ sung
            _buildAdditionalOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildTripSummaryCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      padding: const EdgeInsets.all(kMediumPadding),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(kTopPadding),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blue[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Tóm tắt chuyến đi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  Icons.location_on,
                  'Điểm đến',
                  tripData.destination,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryItem(
                  Icons.calendar_today,
                  'Thời gian',
                  '${tripData.totalDays} ngày',
                  Colors.orange,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  Icons.people,
                  'Số người',
                  '${tripData.travelers} người',
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryItem(
                  Icons.place,
                  'Địa điểm tham quan',
                  '${tripData.destinations} điểm',
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalOptions() {
    return Container(
      padding: const EdgeInsets.all(kMediumPadding),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(kTopPadding),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tùy chọn bổ sung:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: kDefaultPadding),
          
          CheckboxListTile(
            title: const Text('Bao gồm phương tiện di chuyển'),
            value: tripData.includeTransport,
            onChanged: (bool? value) {
              setState(() {
                tripData = tripData.copyWith(includeTransport: value ?? true);
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          
          CheckboxListTile(
            title: const Text('Gợi ý nhà hàng địa phương'),
            value: tripData.includeRestaurants,
            onChanged: (bool? value) {
              setState(() {
                tripData = tripData.copyWith(includeRestaurants: value ?? true);
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          
          CheckboxListTile(
            title: const Text('Bao gồm hoạt động giải trí'),
            value: tripData.includeEntertainment,
            onChanged: (bool? value) {
              setState(() {
                tripData = tripData.copyWith(includeEntertainment: value ?? false);
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
      ),
    );
  }

  void _showDestinationPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(kMediumPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Chọn điểm đến',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: kMediumPadding),
              
              ...[
                'Hà Nội, Việt Nam',
                'TP. Hồ Chí Minh, Việt Nam',
                'Đà Nẵng, Việt Nam',
                'Hội An, Việt Nam',
                'Sapa, Việt Nam',
                'Phú Quốc, Việt Nam',
              ].map((dest) => ListTile(
                title: Text(dest),
                onTap: () {
                  setState(() {
                    tripData = tripData.copyWith(destination: dest);
                  });
                  Navigator.pop(context);
                },
              )).toList(),
            ],
          ),
        );
      },
    );
  }
}