import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/data/models/accommodation_model.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:flutter_travels_apps/representation/widgets/item_accommodation_widget.dart';
import 'package:flutter_travels_apps/data/models/trip_plan_data.dart';

class AccommodationListScreen extends StatefulWidget {
  const AccommodationListScreen({Key? key}) : super(key: key);

  static const String routeName = '/accommodation_list_screen';
  
  @override
  State<AccommodationListScreen> createState() => _AccommodationListScreenState();
}

class _AccommodationListScreenState extends State<AccommodationListScreen> {
  late TripPlanData tripData;
  String accommodationType = 'Tất cả';
  String budgetRange = 'Mọi mức giá';
  List<AccommodationModel> allAccommodations = [];
  List<AccommodationModel> filteredAccommodations = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _loadAccommodations();
  }

  void _initializeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, dynamic>) {
        setState(() {
          tripData = args['tripData'] as TripPlanData;
          accommodationType = args['accommodationType'] as String;
          budgetRange = args['budgetRange'] as String;
        });
        _filterAccommodations();
      }
    });
  }

  void _loadAccommodations() {
    // Dữ liệu mẫu cho các loại lưu trú
    allAccommodations = [
      AccommodationModel(
        id: '1',
        name: "Royal Heritage Hotel",
        type: "Khách sạn",
        location: "Trung tâm Hà Nội",
        imageUrl: AssetHelper.imgHotel1,
        rating: 4.8,
        reviewCount: 1247,
        pricePerNight: 2500000,
        amenities: ['WiFi miễn phí', 'Bể bơi', 'Spa', 'Nhà hàng'],
        description: "Khách sạn sang trọng với thiết kế cổ điển",
      ),
      AccommodationModel(
        id: '2',
        name: "Cozy Family Homestay",
        type: "Homestay", 
        location: "Phố cổ Hà Nội",
        imageUrl: AssetHelper.imgHotel2,
        rating: 4.5,
        reviewCount: 523,
        pricePerNight: 800000,
        amenities: ['WiFi miễn phí', 'Bếp', 'Máy giặt'],
        description: "Homestay ấm cúng giữa lòng phố cổ",
      ),
      AccommodationModel(
        id: '3',
        name: "Sunset Beach Resort",
        type: "Resort",
        location: "Hạ Long Bay",
        imageUrl: AssetHelper.imgHotel3,
        rating: 4.9,
        reviewCount: 2156,
        pricePerNight: 3200000,
        amenities: ['Bãi biển riêng', 'Spa', 'Golf', 'Nhà hàng'],
        description: "Resort cao cấp với view biển tuyệt đẹp",
      ),
      AccommodationModel(
        id: '4',
        name: "Backpacker Central Hostel",
        type: "Hostel",
        location: "Quận 1, TP.HCM",
        imageUrl: AssetHelper.imgHotel1,
        rating: 4.2,
        reviewCount: 789,
        pricePerNight: 300000,
        amenities: ['WiFi miễn phí', 'Khu vực chung', 'Bếp chung'],
        description: "Hostel hiện đại cho du khách ba lô",
      ),
      AccommodationModel(
        id: '5',
        name: "Luxury Ocean Villa",
        type: "Villa",
        location: "Phú Quốc",
        imageUrl: AssetHelper.imgHotel2,
        rating: 4.7,
        reviewCount: 412,
        pricePerNight: 4500000,
        amenities: ['Hồ bơi riêng', 'BBQ', 'Bãi biển riêng', 'Butler'],
        description: "Villa sang trọng view biển tuyệt đẹp",
      ),
    ];
    
    _filterAccommodations();
  }

  void _filterAccommodations() {
    setState(() {
      filteredAccommodations = allAccommodations.where((accommodation) {
        // Lọc theo loại
        bool typeMatch = accommodationType == 'Tất cả' || 
                        accommodation.type == accommodationType;
        
        // Lọc theo ngân sách
        bool budgetMatch = true;
        switch (budgetRange) {
          case 'Dưới 500K/đêm':
            budgetMatch = accommodation.pricePerNight < 500000;
            break;
          case '500K - 1.5M/đêm':
            budgetMatch = accommodation.pricePerNight >= 500000 && 
                         accommodation.pricePerNight <= 1500000;
            break;
          case '1.5M - 3M/đêm':
            budgetMatch = accommodation.pricePerNight > 1500000 && 
                         accommodation.pricePerNight <= 3000000;
            break;
          case 'Trên 3M/đêm':
            budgetMatch = accommodation.pricePerNight > 3000000;
            break;
          default:
            budgetMatch = true;
        }
        
        return typeMatch && budgetMatch;
      }).toList();
      
      // Sắp xếp theo rating
      filteredAccommodations.sort((a, b) => b.rating.compareTo(a.rating));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Chọn Nơi Lưu Trú',
      implementLeading: true,
      child: Column(
        children: [
          // Header với filter
          _buildFilterHeader(),
          
          // Danh sách kết quả
          Expanded(
            child: _buildAccommodationList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterHeader() {
    return Container(
      padding: const EdgeInsets.all(kMediumPadding),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tìm thấy ${filteredAccommodations.length} lựa chọn',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildFilterChip(
                  'Loại: $accommodationType',
                  () => _showTypeFilter(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterChip(
                  'Giá: $budgetRange',
                  () => _showBudgetFilter(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, color: Colors.blue, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAccommodationList() {
    if (filteredAccommodations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Không tìm thấy nơi lưu trú phù hợp',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hãy thử điều chỉnh bộ lọc',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(kMediumPadding),
      itemCount: filteredAccommodations.length,
      itemBuilder: (context, index) {
        final accommodation = filteredAccommodations[index];
        return ItemAccommodationWidget(
          accommodationModel: accommodation,
          tripData: tripData,
        );
      },
    );
  }

  void _showTypeFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(kMediumPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Chọn loại lưu trú',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: kMediumPadding),
              ...[
                'Tất cả',
                'Khách sạn',
                'Homestay', 
                'Resort',
                'Hostel',
                'Villa',
              ].map((type) => ListTile(
                title: Text(type),
                trailing: type == accommodationType 
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() {
                    accommodationType = type;
                  });
                  _filterAccommodations();
                  Navigator.pop(context);
                },
              )).toList(),
            ],
          ),
        );
      },
    );
  }

  void _showBudgetFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(kMediumPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Chọn mức giá',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: kMediumPadding),
              ...[
                'Mọi mức giá',
                'Dưới 500K/đêm',
                '500K - 1.5M/đêm',
                '1.5M - 3M/đêm',
                'Trên 3M/đêm',
              ].map((budget) => ListTile(
                title: Text(budget),
                trailing: budget == budgetRange 
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() {
                    budgetRange = budget;
                  });
                  _filterAccommodations();
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