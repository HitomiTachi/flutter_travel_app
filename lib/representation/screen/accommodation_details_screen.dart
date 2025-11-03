import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/core/helpers/images_helpers.dart';
import 'package:flutter_travels_apps/core/helpers/accommodation_selection_helper.dart';
import 'package:flutter_travels_apps/representation/widgets/common/button_widget.dart';
import 'package:flutter_travels_apps/representation/widgets/trip_planing_widgets/item_add_trip_component.dart';
import 'package:flutter_travels_apps/data/models/trip_plan_data.dart';
import 'package:flutter_travels_apps/data/models/accommodation_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_travels_apps/representation/screen/destination_reviews_screen.dart';
import 'package:flutter_travels_apps/services/share_service.dart';

class AccommodationDetailsScreen extends StatefulWidget {
  const AccommodationDetailsScreen({super.key});

  static const String routeName = '/accommodation_details_screen';

  @override
  State<AccommodationDetailsScreen> createState() =>
      _AccommodationDetailsScreenState();
}

class _AccommodationDetailsScreenState
    extends State<AccommodationDetailsScreen> {
  late TripPlanData tripData;
  AccommodationModel? accommodationModel;
  int guests = 2;
  int rooms = 1;
  String roomType = 'Phòng đôi';
  List<String> amenities = [];
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null) {
        if (args is TripPlanData) {
          // Trường hợp cũ: chỉ có TripPlanData
          setState(() {
            tripData = args;
            guests = tripData.travelers;
            rooms = (tripData.travelers / 2).ceil();
          });
        } else if (args is Map<String, dynamic>) {
          // Trường hợp mới: có cả AccommodationModel và TripPlanData
          setState(() {
            accommodationModel =
                args['accommodationModel'] as AccommodationModel?;
            tripData = args['tripData'] as TripPlanData? ?? TripPlanData();
            guests = tripData.travelers;
            rooms = (tripData.travelers / 2).ceil();
          });
        }
      } else {
        tripData = TripPlanData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Ảnh nền toàn màn (giống HotelDetailScreen)
          Positioned.fill(
            child: ImageHelper.loadFromAsset(
              accommodationModel?.imageUrl ?? AssetHelper.imgHotel3,
              fit: BoxFit.cover,
            ),
          ),

          // Nút Back
          Positioned(
            top: MediaQuery.of(context).padding.top + kDefaultPadding,
            left: kDefaultPadding,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: EdgeInsets.all(kItemPadding),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(kDefaultPadding),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  FontAwesomeIcons.arrowLeft,
                  size: 20,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          // Nút yêu thích
          Positioned(
            top: MediaQuery.of(context).padding.top + kDefaultPadding,
            right: kDefaultPadding,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
                _showFavoriteToast();
              },
              child: Container(
                padding: EdgeInsets.all(kItemPadding),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(kDefaultPadding),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isFavorite
                      ? FontAwesomeIcons.solidHeart
                      : FontAwesomeIcons.heart,
                  size: 20,
                  color: isFavorite ? Colors.red : Colors.grey[600],
                ),
              ),
            ),
          ),

          // Nội dung kéo được (DraggableScrollableSheet)
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            maxChildSize: 0.9,
            minChildSize: 0.4,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(kDefaultPadding * 2),
                    topRight: Radius.circular(kDefaultPadding * 2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.all(kDefaultPadding * 1.5),
                  children: [
                    // Handle kéo
                    Center(
                      child: Container(
                        height: 5,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(kItemPadding),
                        ),
                      ),
                    ),
                    const SizedBox(height: kDefaultPadding),

                    // HEADER: Tên + rating (giống "Hotel Name & Rating")
                    _buildHeaderSection(),

                    const SizedBox(height: kDefaultPadding),

                    // Nút Đánh giá và Chia sẻ
                    _buildActionButtons(),

                    const SizedBox(height: kDefaultPadding),

                    // VỊ TRÍ
                    _buildLocationSection(),

                    const SizedBox(height: kDefaultPadding * 1.5),

                    // MÔ TẢ VÀ LOẠI HÌNH LƯU TRÚ
                    _buildDescriptionSection(),

                    const SizedBox(height: kDefaultPadding * 1.5),

                    // ROOM & GUESTS (thay cho phần chỉnh số khách/phòng)
                    _buildRoomAndGuestsSection(),

                    const SizedBox(height: kDefaultPadding * 1.5),

                    // LOẠI PHÒNG (Dropdown)
                    _buildRoomTypeSection(),

                    const SizedBox(height: kDefaultPadding * 1.5),

                    // TIỆN NGHI (chips/grid nhẹ)
                    _buildAmenitiesSection(),

                    const SizedBox(height: kDefaultPadding * 1.5),

                    // TÓM TẮT
                    _buildSummarySection(),

                    const SizedBox(height: kDefaultPadding * 2),

                    // GIÁ + NÚT XÁC NHẬN (giống Price & Book Button)
                    _buildBookingSection(),
                    const SizedBox(height: kDefaultPadding),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ====== SECTIONS ======

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          accommodationModel?.name ?? 'Thông tin lưu trú',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: kMinPadding),
        Row(
          children: [
            ...List.generate(5, (index) {
              // Hiển thị rating từ accommodationModel hoặc mặc định 4.5
              final rating = accommodationModel?.rating ?? 4.5;
              final fullStars = rating.floor();
              final hasHalfStar = rating - fullStars >= 0.5;

              if (index < fullStars) {
                return Icon(Icons.star, color: Colors.amber, size: 20);
              } else if (index == fullStars && hasHalfStar) {
                return Icon(Icons.star_half, color: Colors.amber, size: 20);
              } else {
                return Icon(Icons.star_border, color: Colors.amber, size: 20);
              }
            }),
            const SizedBox(width: kMinPadding),
            Text(
              (accommodationModel?.rating ?? 4.5).toStringAsFixed(1),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.amber[700],
              ),
            ),
            const SizedBox(width: kMinPadding),
            Text(
              accommodationModel != null
                  ? '(${accommodationModel!.reviewCount} đánh giá)'
                  : '(gợi ý theo sở thích)',
              style: TextStyle(color: ColorPalette.subTitleColor, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final shareService = ShareService();
    final accommodationName = accommodationModel?.name ?? 'Thông tin lưu trú';
    final accommodationDescription = accommodationModel?.description ?? '';
    final accommodationRating = accommodationModel?.rating ?? 0.0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  DestinationReviewsScreen.routeName,
                  arguments: {
                    'destinationId': accommodationModel?.id ?? 'temp_id',
                    'destinationName': accommodationName,
                    'targetType': 'location',
                  },
                );
              },
              icon: Icon(Icons.star, size: 20, color: Colors.white),
              label: Text(
                'Đánh giá',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(width: kDefaultPadding),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () async {
                await shareService.shareLocation(
                  name: accommodationName,
                  description: accommodationDescription,
                  rating: accommodationRating > 0 ? accommodationRating : null,
                );
              },
              icon: Icon(Icons.share, size: 18),
              label: Text('Chia sẻ'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: ColorPalette.primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Row(
      children: [
        const Icon(
          FontAwesomeIcons.locationDot,
          size: 16,
          color: ColorPalette.primaryColor,
        ),
        const SizedBox(width: kMinPadding),
        Expanded(
          child: Text(
            accommodationModel?.location ??
                (tripData.destination.isNotEmpty
                    ? tripData.destination
                    : 'Chưa chọn điểm đến'),
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          '${tripData.totalDays} đêm',
          style: TextStyle(color: ColorPalette.subTitleColor, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    if (accommodationModel == null) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Loại hình lưu trú
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            accommodationModel!.type,
            style: TextStyle(
              color: Colors.blue[700],
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: kDefaultPadding),

        // Mô tả
        Text(
          'Về nơi lưu trú này',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: kMinPadding),

        Text(
          accommodationModel!.description,
          style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
        ),

        const SizedBox(height: kDefaultPadding),

        // Tiện nghi nổi bật
        if (accommodationModel!.amenities.isNotEmpty) ...[
          Text(
            'Tiện nghi nổi bật',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: kMinPadding),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: accommodationModel!.amenities.take(4).map((amenity) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Colors.green[600],
                    ),
                    SizedBox(width: 4),
                    Text(
                      amenity,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildRoomAndGuestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Khách & Phòng',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: kDefaultPadding),
        // Giống kiểu ô tuỳ chọn trong hotel detail (dạng card nhẹ)
        Container(
          padding: const EdgeInsets.all(kDefaultPadding),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(kDefaultPadding),
          ),
          child: Column(
            children: [
              ItemAddTripComponent(
                icon: AssetHelper.icoGuest,
                innitData: guests,
                title: 'Số khách',
                minValue: 1,
                maxValue: 20,
                onValueChanged: (value) {
                  setState(() {
                    guests = value;
                    rooms = (value / 2).ceil();
                  });
                },
              ),
              const SizedBox(height: kDefaultPadding),
              ItemAddTripComponent(
                icon: AssetHelper.iconbed,
                innitData: rooms,
                title: 'Số phòng',
                minValue: 1,
                maxValue: 10,
                onValueChanged: (value) {
                  setState(() => rooms = value);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoomTypeSection() {
    final roomTypes = [
      'Phòng đơn',
      'Phòng đôi',
      'Phòng gia đình',
      'Suite',
      'Phòng deluxe',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Loại phòng',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
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
              items: roomTypes
                  .map(
                    (e) => DropdownMenuItem<String>(value: e, child: Text(e)),
                  )
                  .toList(),
              onChanged: (val) => setState(() => roomType = val ?? roomType),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmenitiesSection() {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tiện nghi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: kDefaultPadding),
        Wrap(
          spacing: kDefaultPadding,
          runSpacing: kDefaultPadding,
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
                  horizontal: kDefaultPadding,
                  vertical: kMinPadding,
                ),
                decoration: BoxDecoration(
                  color: (isSelected
                      ? ColorPalette.primaryColor
                      : ColorPalette.primaryColor.withOpacity(0.08)),
                  borderRadius: BorderRadius.circular(kDefaultPadding),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FontAwesomeIcons.circleCheck,
                      size: 12,
                      color: isSelected
                          ? Colors.white
                          : ColorPalette.primaryColor,
                    ),
                    const SizedBox(width: kMinPadding),
                    Text(
                      amenity,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? Colors.white
                            : ColorPalette.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tóm tắt yêu cầu',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: kDefaultPadding),
        Container(
          padding: const EdgeInsets.all(kDefaultPadding * 1.2),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(kDefaultPadding * 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _summaryRow(FontAwesomeIcons.users, '$guests khách'),
              const SizedBox(height: 8),
              _summaryRow(FontAwesomeIcons.bed, '$rooms phòng • $roomType'),
              const SizedBox(height: 8),
              _summaryRow(FontAwesomeIcons.calendarDays, tripData.dateRange),
              if (amenities.isNotEmpty) ...[
                const SizedBox(height: 8),
                _summaryRow(
                  FontAwesomeIcons.star,
                  'Tiện nghi: ${amenities.join(', ')}',
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: ColorPalette.primaryColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildBookingSection() {
    // Sử dụng giá từ accommodationModel nếu có, nếu không thì tính từ budget
    final pricePerNight =
        accommodationModel?.pricePerNight.toDouble() ??
        ((tripData.budget > 0)
            ? (tripData.budget /
                  (tripData.totalDays == 0 ? 1 : tripData.totalDays))
            : 1200000.0);

    return Container(
      padding: EdgeInsets.all(kDefaultPadding * 1.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kDefaultPadding * 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatCurrency(pricePerNight),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.primaryColor,
                ),
              ),
              Text(
                accommodationModel != null ? 'mỗi đêm (tham khảo)' : 'mỗi đêm',
                style: TextStyle(
                  color: ColorPalette.subTitleColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(width: kDefaultPadding),
          Expanded(
            child: ButtonWidget(
              title: accommodationModel != null ? 'Chọn' : 'Xác nhận',
              onTap: () {
                if (accommodationModel != null) {
                  // Cập nhật tripData với thông tin accommodation và quay về trang tạo kế hoạch
                  _selectAccommodationAndGoBack();
                } else {
                  // Logic cũ cho trường hợp không có accommodationModel
                  final updatedTripData = tripData.copyWith(travelers: guests);
                  Navigator.of(context).pop(updatedTripData);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // ====== HELPERS ======

  void _showFavoriteToast() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              isFavorite ? 'Đã thêm vào yêu thích' : 'Đã bỏ khỏi yêu thích',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: isFavorite ? Colors.red[400] : Colors.grey[600],
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _selectAccommodationAndGoBack() {
    // Lưu accommodation đã chọn vào helper
    if (accommodationModel != null) {
      AccommodationSelectionHelper.setSelectedAccommodation(accommodationModel);
    }

    // Quay về màn hình gốc và set tab kế hoạch
    // Cách 1: Thử quay về MainApp nếu tồn tại trong stack
    Navigator.of(context).popUntil((route) {
      return route.settings.name == 'main_app' || route.isFirst;
    });

    // Nếu đã ở MainApp, chỉ cần trigger refresh cho tab kế hoạch
    // Điều này sẽ được xử lý bởi MainApp's arguments hoặc callback
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M VNĐ';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K VNĐ';
    }
    return '${amount.toStringAsFixed(0)} VNĐ';
  }
}
