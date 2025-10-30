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
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:flutter_travels_apps/representation/widgets/button_widget.dart';
import 'package:flutter_travels_apps/representation/widgets/item_booking_widget.dart';

class TripCreationScreen extends StatefulWidget {
  const TripCreationScreen({Key? key}) : super(key: key);

  static const String routeName = '/trip_creation_screen';
<<<<<<< HEAD
  
=======

>>>>>>> 72ffec4 (Initial commit)
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
<<<<<<< HEAD
            
            // Chọn điểm đến
            ItemBookingWidget(
              icons: AssetHelper.iconlocation, 
              title: "Điểm Đến", 
=======

            // Chọn điểm đến
            ItemBookingWidget(
              icons: AssetHelper.iconlocation,
              title: "Điểm Đến",
>>>>>>> 72ffec4 (Initial commit)
              description: tripData.destination,
              onTap: () {
                _showDestinationPicker();
              },
            ),
<<<<<<< HEAD
            
            const SizedBox(height: kMediumPadding),
            
=======

            const SizedBox(height: kMediumPadding),

>>>>>>> 72ffec4 (Initial commit)
            // Chọn thời gian
            ItemBookingWidget(
              icons: AssetHelper.iconcalendar,
              title: "Thời Gian Du Lịch",
              description: tripData.dateRange,
              onTap: () async {
<<<<<<< HEAD
                final result = await Navigator.of(context).pushNamed(SelectDateScreen.routeName);
                if (result != null && (result as List<DateTime?>).any((element) => element != null)) {
=======
                final result = await Navigator.of(
                  context,
                ).pushNamed(SelectDateScreen.routeName);
                if (result != null &&
                    (result as List<DateTime?>).any(
                      (element) => element != null,
                    )) {
>>>>>>> 72ffec4 (Initial commit)
                  setState(() {
                    tripData = tripData.copyWith(
                      startDate: result[0]?.getStartDate ?? tripData.startDate,
                      endDate: result[1]?.getEndDate ?? tripData.endDate,
                    );
                  });
                }
              },
            ),
<<<<<<< HEAD
            
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
=======

            const SizedBox(height: kMediumPadding),

            // Chi tiết kế hoạch
            ItemBookingWidget(
              icons: AssetHelper.iconbed,
              title: "Chi Tiết Kế Hoạch",
              description: tripData.planSummary,
              onTap: () async {
                final result = await Navigator.of(
                  context,
                ).pushNamed(TripPlanningScreen.routeName, arguments: tripData);
>>>>>>> 72ffec4 (Initial commit)
                if (result != null && result is TripPlanData) {
                  setState(() {
                    tripData = result;
                  });
                }
              },
            ),
<<<<<<< HEAD
            
            const SizedBox(height: kMediumPadding),
            
            // Gợi ý nơi lưu trú
            ItemBookingWidget(
              icons: AssetHelper.iconbed,
              title: "Gợi Ý Nơi Lưu Trú", 
=======

            const SizedBox(height: kMediumPadding),

            // Gợi ý nơi lưu trú
            ItemBookingWidget(
              icons: AssetHelper.iconbed,
              title: "Gợi Ý Nơi Lưu Trú",
>>>>>>> 72ffec4 (Initial commit)
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
<<<<<<< HEAD
            
            const SizedBox(height: kMediumPadding),
            
            // Hiển thị thông tin tổng hợp
            // _buildTripSummaryCard(),
            
            const SizedBox(height: kMediumPadding),
            
            // Tạo kế hoạch chi tiết
            ButtonWidget(
              title: "Tạo Kế Hoạch Chi Tiết", 
=======

            const SizedBox(height: kMediumPadding),

            // Hiển thị thông tin tổng hợp
            // _buildTripSummaryCard(),
            const SizedBox(height: kMediumPadding),

            // Checklist trước khi đi
            ItemBookingWidget(
              icons: AssetHelper.iconlocation,
              title: 'Checklist Trước Khi Đi',
              description: 'Chuẩn bị đồ dùng cần thiết',
              onTap: () {
                Navigator.of(context).pushNamed(
                  '/travel_checklist_screen',
                  arguments: {
                    'tripId': tripData.destination + tripData.startDate,
                    'tripName': tripData.destination,
                  },
                );
              },
            ),

            const SizedBox(height: kMediumPadding),

            // Tạo kế hoạch chi tiết
            ButtonWidget(
              title: "Tạo Kế Hoạch Chi Tiết",
>>>>>>> 72ffec4 (Initial commit)
              onTap: () {
                Navigator.of(context).pushNamed(
                  DetailedTripPlanScreen.routeName,
                  arguments: tripData,
                );
<<<<<<< HEAD
              }
            ),
            
            const SizedBox(height: kDefaultPadding),
            
=======
              },
            ),

            const SizedBox(height: kDefaultPadding),

>>>>>>> 72ffec4 (Initial commit)
            // Các tùy chọn bổ sung - Tạm thời ẩn
            // _buildAdditionalOptions(),
          ],
        ),
      ),
    );
  }

  // Widget _buildTripSummaryCard() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
  //     padding: const EdgeInsets.all(kMediumPadding),
  //     decoration: BoxDecoration(
  //       color: Colors.blue[50],
  //       borderRadius: BorderRadius.circular(kTopPadding),
  //       border: Border.all(color: Colors.blue[200]!),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Icon(
  //               Icons.info_outline,
  //               color: Colors.blue[600],
  //               size: 20,
  //             ),
  //             const SizedBox(width: 8),
  //             Text(
  //               'Tóm tắt chuyến đi',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.blue[800],
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 12),
<<<<<<< HEAD
          
=======

>>>>>>> 72ffec4 (Initial commit)
  //         Row(
  //           children: [
  //             Expanded(
  //               child: _buildSummaryItem(
  //                 Icons.location_on,
  //                 'Điểm đến',
  //                 tripData.destination,
  //                 Colors.green,
  //               ),
  //             ),
  //             const SizedBox(width: 16),
  //             Expanded(
  //               child: _buildSummaryItem(
  //                 Icons.calendar_today,
  //                 'Thời gian',
  //                 '${tripData.totalDays} ngày',
  //                 Colors.orange,
  //               ),
  //             ),
  //           ],
  //         ),
<<<<<<< HEAD
          
  //         const SizedBox(height: 8),
          
=======

  //         const SizedBox(height: 8),

>>>>>>> 72ffec4 (Initial commit)
  //         Row(
  //           children: [
  //             Expanded(
  //               child: _buildSummaryItem(
  //                 Icons.people,
  //                 'Số người',
  //                 '${tripData.travelers} người',
  //                 Colors.blue,
  //               ),
  //             ),
  //             const SizedBox(width: 16),
  //             Expanded(
  //               child: _buildSummaryItem(
  //                 Icons.place,
  //                 'Địa điểm tham quan',
  //                 '${tripData.destinations} điểm',
  //                 Colors.purple,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildSummaryItem(IconData icon, String label, String value, Color color) {
  //   return Row(
  //     children: [
  //       Icon(icon, size: 16, color: color),
  //       const SizedBox(width: 6),
  //       Expanded(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               label,
  //               style: TextStyle(
  //                 fontSize: 11,
  //                 color: Colors.grey[600],
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //             Text(
  //               value,
  //               style: const TextStyle(
  //                 fontSize: 13,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildAdditionalOptions() {
  //   return Container(
  //     padding: const EdgeInsets.all(kMediumPadding),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[50],
  //       borderRadius: BorderRadius.circular(kTopPadding),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           'Tùy chọn bổ sung:',
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         const SizedBox(height: kDefaultPadding),
<<<<<<< HEAD
          
=======

>>>>>>> 72ffec4 (Initial commit)
  //         CheckboxListTile(
  //           title: const Text('Bao gồm phương tiện di chuyển'),
  //           value: tripData.includeTransport,
  //           onChanged: (bool? value) {
  //             setState(() {
  //               tripData = tripData.copyWith(includeTransport: value ?? true);
  //             });
  //           },
  //           controlAffinity: ListTileControlAffinity.leading,
  //         ),
<<<<<<< HEAD
          
=======

>>>>>>> 72ffec4 (Initial commit)
  //         CheckboxListTile(
  //           title: const Text('Gợi ý nhà hàng địa phương'),
  //           value: tripData.includeRestaurants,
  //           onChanged: (bool? value) {
  //             setState(() {
  //               tripData = tripData.copyWith(includeRestaurants: value ?? true);
  //             });
  //           },
  //           controlAffinity: ListTileControlAffinity.leading,
  //         ),
<<<<<<< HEAD
          
=======

>>>>>>> 72ffec4 (Initial commit)
  //         CheckboxListTile(
  //           title: const Text('Bao gồm hoạt động giải trí'),
  //           value: tripData.includeEntertainment,
  //           onChanged: (bool? value) {
  //             setState(() {
  //               tripData = tripData.copyWith(includeEntertainment: value ?? false);
  //             });
  //           },
  //           controlAffinity: ListTileControlAffinity.leading,
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
<<<<<<< HEAD
              
              // Title
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.blue[600],
                    size: 24,
                  ),
=======

              // Title
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.blue[600], size: 24),
>>>>>>> 72ffec4 (Initial commit)
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
<<<<<<< HEAD
              
              const SizedBox(height: kMediumPadding),
              
=======

              const SizedBox(height: kMediumPadding),

>>>>>>> 72ffec4 (Initial commit)
              // Destination list
              Container(
                constraints: const BoxConstraints(maxHeight: 400),
                child: SingleChildScrollView(
                  child: Column(
<<<<<<< HEAD
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
              
=======
                    children:
                        [
                              'Hà Nội, Việt Nam',
                              'TP. Hồ Chí Minh, Việt Nam',
                              'Đà Nẵng, Việt Nam',
                              'Hội An, Việt Nam',
                              'Sapa, Việt Nam',
                              'Phú Quốc, Việt Nam',
                            ]
                            .map(
                              (dest) => Container(
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
                                      tripData = tripData.copyWith(
                                        destination: dest,
                                      );
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),

              const SizedBox(height: kMediumPadding),

>>>>>>> 72ffec4 (Initial commit)
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
<<<<<<< HEAD
}
=======
}
>>>>>>> 72ffec4 (Initial commit)
