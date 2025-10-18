import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/extenstions/date_ext.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/representation/screen/accommodation_details_screen.dart';
import 'package:flutter_travels_apps/representation/screen/accommodation_list_screen.dart';
import 'package:flutter_travels_apps/representation/screen/select_date_screen.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:flutter_travels_apps/representation/widgets/button_widget.dart';
import 'package:flutter_travels_apps/representation/widgets/item_booking_widget.dart';
import 'package:flutter_travels_apps/data/models/trip_plan_data.dart';

class AccommodationBookingScreen extends StatefulWidget {
  const AccommodationBookingScreen({Key? key}) : super(key: key);

  static const String routeName = '/accommodation_booking_screen';
  
  @override
  State<AccommodationBookingScreen> createState() => _AccommodationBookingScreenState();
}

class _AccommodationBookingScreenState extends State<AccommodationBookingScreen> {
  late TripPlanData tripData;
  String selectedAccommodationType = 'Tất cả';
  String selectedBudgetRange = 'Mọi mức giá';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is TripPlanData) {
        setState(() {
          tripData = args;
        });
      } else {
        tripData = TripPlanData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Chọn Nơi Lưu Trú',
      implementLeading: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: kMediumPadding * 2),
            
            // Thông tin chuyến đi
            _buildTripInfoCard(),
            
            const SizedBox(height: kMediumPadding),
            
            // Chọn địa điểm
            ItemBookingWidget(
              icons: AssetHelper.iconlocation, 
              title: "Địa Điểm", 
              description: tripData.destination,
              onTap: () {
                _showDestinationPicker();
              },
            ),
            
            const SizedBox(height: kMediumPadding),
            
            // Thời gian lưu trú
            ItemBookingWidget(
              icons: AssetHelper.iconcalendar,
              title: "Thời Gian Lưu Trú",
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
            
            // Chi tiết lưu trú (khách và phòng)
            ItemBookingWidget(
              icons: AssetHelper.icoGuest, 
              title: "Chi Tiết Lưu Trú", 
              description: '${tripData.travelers} Khách, ${(tripData.travelers / 2).ceil()} Phòng',
              onTap: () async {
                final result = await Navigator.of(context).pushNamed(
                  AccommodationDetailsScreen.routeName,
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
            
            // Loại lưu trú
            ItemBookingWidget(
              icons: AssetHelper.iconbed, 
              title: "Loại Lưu Trú", 
              description: selectedAccommodationType,
              onTap: () {
                _showAccommodationTypePicker();
              },
            ),
            
            const SizedBox(height: kMediumPadding),
            
            // Ngân sách
            ItemBookingWidget(
              icons: AssetHelper.iconcalendar, // Tạm dùng icon này
              title: "Ngân Sách", 
              description: selectedBudgetRange,
              onTap: () {
                _showBudgetPicker();
              },
            ),
            
            const SizedBox(height: kMediumPadding * 2),
            
            // Nút tìm kiếm
            ButtonWidget(
              title: "Tìm Nơi Lưu Trú", 
              onTap: () {
                Navigator.of(context).pushNamed(
                  AccommodationListScreen.routeName,
                  arguments: {
                    'tripData': tripData,
                    'accommodationType': selectedAccommodationType,
                    'budgetRange': selectedBudgetRange,
                  },
                );
              }
            ),
            
            const SizedBox(height: kDefaultPadding),
            
            // Nút bỏ qua
            ButtonWidget(
              title: "Bỏ Qua Bước Này", 
              onTap: () {
                Navigator.of(context).pop(tripData);
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      padding: const EdgeInsets.all(kMediumPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(kTopPadding),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.hotel, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'Thông tin lưu trú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(Icons.location_on, tripData.destination),
              ),
              _buildInfoItem(Icons.people, '${tripData.travelers} người'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(Icons.calendar_today, '${tripData.totalDays} đêm'),
              ),
              _buildInfoItem(Icons.hotel, '${(tripData.travelers / 2).ceil()} phòng'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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

  void _showAccommodationTypePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(kMediumPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Chọn loại lưu trú',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: kMediumPadding),
              
              ...[
                'Tất cả',
                'Khách sạn',
                'Homestay',
                'Resort',
                'Hostel',
                'Villa',
                'Apartment',
              ].map((type) => ListTile(
                title: Text(type),
                trailing: type == selectedAccommodationType 
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() {
                    selectedAccommodationType = type;
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

  void _showBudgetPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(kMediumPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Chọn mức giá mong muốn',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: kMediumPadding),
              
              ...[
                {'range': 'Mọi mức giá', 'description': ''},
                {'range': 'Dưới 500K/đêm', 'description': 'Tiết kiệm'},
                {'range': '500K - 1.5M/đêm', 'description': 'Trung bình'},
                {'range': '1.5M - 3M/đêm', 'description': 'Cao cấp'},
                {'range': 'Trên 3M/đêm', 'description': 'Sang trọng'},
              ].map((budget) => ListTile(
                title: Text(budget['range']!),
                subtitle: budget['description']!.isNotEmpty 
                    ? Text(budget['description']!)
                    : null,
                trailing: budget['range'] == selectedBudgetRange 
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() {
                    selectedBudgetRange = budget['range']!;
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