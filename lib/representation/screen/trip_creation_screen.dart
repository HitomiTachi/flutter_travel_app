import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/extensions/date_ext.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/core/helpers/accommodation_selection_helper.dart';
import 'package:flutter_travels_apps/representation/screen/trip_planning_screen.dart';
import 'package:flutter_travels_apps/representation/screen/detailed_trip_plan_screen.dart';
import 'package:flutter_travels_apps/representation/screen/accommodation_booking_screen.dart';
import 'package:flutter_travels_apps/representation/screen/select_date_screen.dart';
import 'package:flutter_travels_apps/data/models/trip_plan_data.dart';
import 'package:flutter_travels_apps/data/models/accommodation_model.dart';
import 'package:flutter_travels_apps/representation/widgets/common/app_bar_container.dart';
import 'package:flutter_travels_apps/representation/widgets/common/button_widget.dart';
import 'package:flutter_travels_apps/representation/widgets/hotel_boking_widgets/item_booking_widget.dart';

class TripCreationScreen extends StatefulWidget {
  const TripCreationScreen({Key? key}) : super(key: key);

  static const String routeName = '/trip_creation_screen';
  
  @override
  State<TripCreationScreen> createState() => _TripCreationScreenState();
}

class _TripCreationScreenState extends State<TripCreationScreen> {
  late TripPlanData tripData;
  AccommodationModel? selectedAccommodation;

  @override
  void initState() {
    super.initState();
    tripData = TripPlanData();
  }

  @override
  void didUpdateWidget(TripCreationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger rebuild khi widget được cập nhật hoặc khi tab được chọn
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          // Force refresh để cập nhật accommodation description từ helper
        });
      }
    });
  }

  // Thêm method để refresh khi tab được active
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Refresh accommodation data từ helper mỗi lần screen active
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          // Refresh để cập nhật accommodation description
        });
      }
    });
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
            
            // Gợi ý nơi lưu trú
            ItemBookingWidget(
              icons: AssetHelper.iconbed,
              title: "Gợi Ý Nơi Lưu Trú", 
              description: _getAccommodationDescription(),
              onTap: () async {
                final result = await Navigator.of(context).pushNamed(
                  AccommodationBookingScreen.routeName,
                  arguments: tripData,
                );
                // Cập nhật UI sau khi quay về để hiển thị accommodation đã chọn
                setState(() {
                  if (result != null && result is TripPlanData) {
                    tripData = result;
                  }
                  // Force rebuild để cập nhật accommodation description
                });
              },
            ),
            
            const SizedBox(height: kMediumPadding),
            
            // Hiển thị thông tin tổng hợp
            // _buildTripSummaryCard(),
            
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
            
            // Các tùy chọn bổ sung - Tạm thời ẩn
            // _buildAdditionalOptions(),
          ],
        ),
      ),
    );
  }

  String _getAccommodationDescription() {
    return AccommodationSelectionHelper.getDisplayText();
  }

  void _showDestinationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(kMediumPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: kMediumPadding),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // Title
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.blue[600],
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Chọn điểm đến',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: kMediumPadding),
              
              // Destination list
              Container(
                constraints: const BoxConstraints(maxHeight: 400),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      'Hà Nội, Việt Nam',
                      'TP. Hồ Chí Minh, Việt Nam',
                      'Đà Nẵng, Việt Nam',
                      'Hội An, Việt Nam',
                      'Sapa, Việt Nam',
                      'Phú Quốc, Việt Nam',
                    ].map((dest) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey[200]!,
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.place,
                            color: Colors.blue[600],
                            size: 20,
                          ),
                        ),
                        title: Text(
                          dest,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey[400],
                        ),
                        onTap: () {
                          setState(() {
                            tripData = tripData.copyWith(destination: dest);
                          });
                          Navigator.pop(context);
                        },
                      ),
                    )).toList(),
                  ),
                ),
              ),
              
              const SizedBox(height: kMediumPadding),
              
              // Cancel button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Hủy',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}