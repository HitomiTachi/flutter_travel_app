import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/helpers/images_helpers.dart';
import 'package:flutter_travels_apps/data/models/accommodation_model.dart';
import 'package:flutter_travels_apps/data/models/trip_plan_data.dart';

class ItemAccommodationWidget extends StatelessWidget {
  const ItemAccommodationWidget({
    Key? key,
    required this.accommodationModel,
    required this.tripData,
  }) : super(key: key);

  final AccommodationModel accommodationModel;
  final TripPlanData tripData;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: kMediumPadding),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kTopPadding),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(kTopPadding),
        onTap: () {
          _showAccommodationDetails(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(kMediumPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hình ảnh
              ClipRRect(
                borderRadius: BorderRadius.circular(kDefaultPadding),
                child: ImageHelper.loadFromAsset(
                  accommodationModel.imageUrl,
                  width: 100,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              
              const SizedBox(width: kMediumPadding),
              
              // Thông tin
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên và loại
                    Row(
                      children: [
                        Text(
                          accommodationModel.typeIcon,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            accommodationModel.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Địa điểm
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            accommodationModel.location,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Rating và reviews
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          accommodationModel.rating.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${accommodationModel.reviewCount})',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Giá và nút chọn
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${accommodationModel.formattedPrice}/đêm',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                            Text(
                              'Tổng: ${_calculateTotalPrice()}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        
                        ElevatedButton(
                          onPressed: () {
                            _addToTripPlan(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(80, 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Chọn',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _calculateTotalPrice() {
    final totalPrice = accommodationModel.pricePerNight * tripData.totalDays;
    if (totalPrice >= 1000000) {
      return '${(totalPrice / 1000000).toStringAsFixed(1)}M VNĐ';
    } else if (totalPrice >= 1000) {
      return '${(totalPrice / 1000).toStringAsFixed(0)}K VNĐ';
    } else {
      return '$totalPrice VNĐ';
    }
  }

  void _showAccommodationDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(kMediumPadding),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: kMediumPadding),
                    
                    // Hình ảnh lớn
                    ClipRRect(
                      borderRadius: BorderRadius.circular(kTopPadding),
                      child: ImageHelper.loadFromAsset(
                        accommodationModel.imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    
                    const SizedBox(height: kMediumPadding),
                    
                    // Tên và loại
                    Row(
                      children: [
                        Text(
                          accommodationModel.typeIcon,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            accommodationModel.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Loại và địa điểm
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            accommodationModel.type,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            accommodationModel.location,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: kMediumPadding),
                    
                    // Rating
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            Icons.star,
                            size: 20,
                            color: index < accommodationModel.rating.floor() 
                                ? Colors.amber 
                                : Colors.grey[300],
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          '${accommodationModel.rating} (${accommodationModel.reviewCount} đánh giá)',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: kMediumPadding),
                    
                    // Mô tả
                    const Text(
                      'Mô tả',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      accommodationModel.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    
                    const SizedBox(height: kMediumPadding),
                    
                    // Tiện nghi
                    const Text(
                      'Tiện nghi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: accommodationModel.amenities.map((amenity) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            amenity,
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: kMediumPadding * 2),
                    
                    // Giá và nút chọn
                    Container(
                      padding: const EdgeInsets.all(kMediumPadding),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(kTopPadding),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${accommodationModel.formattedPrice}/đêm',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                              Text(
                                'Tổng ${tripData.totalDays} đêm: ${_calculateTotalPrice()}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _addToTripPlan(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('Thêm vào kế hoạch'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _addToTripPlan(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm vào kế hoạch'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Đã thêm ${accommodationModel.name} vào kế hoạch chuyến đi của bạn!'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chi tiết:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                    Text('📍 ${accommodationModel.location}'),
                    Text('📅 ${tripData.dateRange}'),
                    Text('💰 ${_calculateTotalPrice()} tổng cộng'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Quay về trip creation
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}