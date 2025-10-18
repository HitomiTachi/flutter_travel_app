import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:flutter_travels_apps/representation/widgets/button_widget.dart';
import 'package:flutter_travels_apps/representation/widgets/item_add_trip_component.dart';
import 'package:flutter_travels_apps/data/models/trip_plan_data.dart';

class AccommodationDetailsScreen extends StatefulWidget {
  const AccommodationDetailsScreen({Key? key}) : super(key: key);

  static const String routeName = '/accommodation_details_screen';
  
  @override
  State<AccommodationDetailsScreen> createState() => _AccommodationDetailsScreenState();
}

class _AccommodationDetailsScreenState extends State<AccommodationDetailsScreen> {
  late TripPlanData tripData;
  int guests = 2;
  int rooms = 1;
  String roomType = 'Phòng đôi';
  List<String> amenities = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is TripPlanData) {
        setState(() {
          tripData = args;
          guests = tripData.travelers;
          rooms = (tripData.travelers / 2).ceil();
        });
      } else {
        tripData = TripPlanData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Chi Tiết Lưu Trú',
      implementLeading: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: kMediumPadding * 1.5),
            
            // Số khách
            ItemAddTripComponent(
              icon: AssetHelper.icoGuest,
              innitData: guests,
              title: 'Số khách',
              minValue: 1,
              maxValue: 20,
              onValueChanged: (value) {
                setState(() {
                  guests = value;
                  // Tự động điều chỉnh số phòng
                  rooms = (value / 2).ceil();
                });
              },
            ),
            
            // Số phòng
            ItemAddTripComponent(
              icon: AssetHelper.iconbed,
              innitData: rooms,
              title: 'Số phòng',
              minValue: 1,
              maxValue: 10,
              onValueChanged: (value) {
                setState(() {
                  rooms = value;
                });
              },
            ),
            
            const SizedBox(height: kMediumPadding),
            
            // Loại phòng
            _buildRoomTypeSelector(),
            
            const SizedBox(height: kMediumPadding),
            
            // Tiện nghi
            _buildAmenitiesSelector(),
            
            const Spacer(),
            
            // Thông tin tóm tắt
            _buildSummaryCard(),
            
            const SizedBox(height: kMediumPadding),
            
            // Nút xác nhận
            ButtonWidget(
              title: 'Xác Nhận',
              onTap: () {
                // Cập nhật tripData và trả về
                final updatedTripData = tripData.copyWith(
                  travelers: guests,
                );
                Navigator.of(context).pop(updatedTripData);
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
      ),
    );
  }

  Widget _buildRoomTypeSelector() {
    final roomTypes = ['Phòng đơn', 'Phòng đôi', 'Phòng gia đình', 'Suite', 'Phòng deluxe'];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Loại phòng mong muốn',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: kDefaultPadding),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(kDefaultPadding),
              color: Colors.white,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: roomType,
                items: roomTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      roomType = newValue;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesSelector() {
    final availableAmenities = [
      'WiFi miễn phí',
      'Điều hòa',
      'Tivi',
      'Minibar',
      'Bồn tắm',
      'Ban công',
      'View biển',
      'Bể bơi',
      'Gym',
      'Spa',
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tiện nghi mong muốn',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: kDefaultPadding),
          Container(
            padding: const EdgeInsets.all(kMediumPadding),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(kDefaultPadding),
              color: Colors.grey[50],
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableAmenities.map((amenity) {
                final isSelected = amenities.contains(amenity);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        amenities.remove(amenity);
                      } else {
                        amenities.add(amenity);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      amenity,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
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
          const Text(
            'Tóm tắt yêu cầu lưu trú',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              const Icon(Icons.people, size: 18, color: Colors.blue),
              const SizedBox(width: 8),
              Text('$guests khách'),
              const SizedBox(width: 24),
              const Icon(Icons.hotel, size: 18, color: Colors.blue),
              const SizedBox(width: 8),
              Text('$rooms phòng'),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              const Icon(Icons.bed, size: 18, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(child: Text(roomType)),
            ],
          ),
          
          if (amenities.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.star, size: 18, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tiện nghi: ${amenities.join(', ')}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
          
          const SizedBox(height: 12),
          
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const Icon(Icons.info, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Thông tin này sẽ giúp chúng tôi tìm nơi lưu trú phù hợp nhất',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.green[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}