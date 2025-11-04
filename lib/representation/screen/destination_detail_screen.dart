import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/core/helpers/images_helpers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_travels_apps/representation/screen/destination_reviews_screen.dart';
import 'package:flutter_travels_apps/services/share_service.dart';
import 'package:flutter_travels_apps/data/models/popular_destination.dart';

class DestinationDetailScreen extends StatefulWidget {
  final PopularDestination? destination;
  
  const DestinationDetailScreen({
    super.key,
    this.destination,
  });

  static const String routeName = '/destination_detail_screen';

  @override
  State<DestinationDetailScreen> createState() => _DestinationDetailScreenState();
}

class _DestinationDetailScreenState extends State<DestinationDetailScreen> {
  bool isFavorite = false;
  
  @override
  Widget build(BuildContext context) {
    // Lấy destination từ widget hoặc từ arguments
    final PopularDestination destination = widget.destination ?? 
      (ModalRoute.of(context)?.settings.arguments as PopularDestination?) ?? _getDefaultDestination();
    
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: ImageHelper.loadFromAsset(
              destination.imageUrl,
              fit: BoxFit.cover,
            ),
          ),

          // Back Button
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
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  FontAwesomeIcons.arrowLeft,
                  size: 20,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          // Favorite Button
          Positioned(
            top: MediaQuery.of(context).padding.top + kDefaultPadding,
            right: kDefaultPadding,
            child: GestureDetector(
              onTap: () {
                setState(() => isFavorite = !isFavorite);
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
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isFavorite ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                  size: 20,
                  color: isFavorite ? Colors.red : Colors.black87,
                ),
              ),
            ),
          ),

          // Draggable Content
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
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Drag Handle
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: kDefaultPadding),
                      child: Container(
                        height: 5,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(kItemPadding),
                        ),
                      ),
                    ),

                    // Content
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: EdgeInsets.all(kDefaultPadding * 1.5),
                        children: [
                          // Destination Name & Rating
                          _buildDestinationHeader(destination),
                          SizedBox(height: kDefaultPadding),

                          // Nút Đánh giá và Chia sẻ
                          _buildActionButtons(destination),
                          SizedBox(height: kDefaultPadding),

                          // Location
                          _buildLocationSection(destination),
                          SizedBox(height: kDefaultPadding * 1.5),

                          // Description
                          _buildDescriptionSection(destination),
                          SizedBox(height: kDefaultPadding * 1.5),

                          // Highlights
                          _buildHighlightsSection(),
                          SizedBox(height: kDefaultPadding * 1.5),

                          // Gallery
                          _buildGallerySection(destination),
                          SizedBox(height: kDefaultPadding * 1.5),

                          // Reviews
                          _buildReviewsSection(destination),
                          SizedBox(height: kDefaultPadding * 2),

                          // Action Buttons
                          _buildBookingSection(destination),
                          SizedBox(height: kDefaultPadding),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationHeader(PopularDestination destination) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          destination.name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: kMinPadding),
        Row(
          children: [
            ...List.generate(5, (index) {
              return Icon(
                index < destination.rating.floor() ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 20,
              );
            }),
            SizedBox(width: kMinPadding),
            Text(
              destination.rating.toStringAsFixed(1),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.amber[700],
              ),
            ),
            SizedBox(width: kMinPadding),
            Text(
              '(${destination.reviewCount} đánh giá)',
              style: TextStyle(color: ColorPalette.subTitleColor, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(PopularDestination destination) {
    final shareService = ShareService();

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
                    'destinationId': destination.id,
                    'destinationName': destination.name,
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
                  name: destination.name,
                  description: destination.description,
                  rating: destination.rating,
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

  Widget _buildLocationSection(PopularDestination destination) {
    return Row(
      children: [
        Icon(
          FontAwesomeIcons.locationDot,
          size: 16,
          color: ColorPalette.primaryColor,
        ),
        SizedBox(width: kMinPadding),
        Expanded(
          child: Text(
            destination.country,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(PopularDestination destination) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Giới thiệu',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: kDefaultPadding),
        Text(
          destination.description,
          style: TextStyle(color: Colors.black54, height: 1.6, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildHighlightsSection() {
    final highlights = [
      {'icon': FontAwesomeIcons.camera, 'label': 'Chụp ảnh'},
      {'icon': FontAwesomeIcons.utensils, 'label': 'Ẩm thực'},
      {'icon': FontAwesomeIcons.personHiking, 'label': 'Dã ngoại'},
      {'icon': FontAwesomeIcons.water, 'label': 'Bãi biển'},
      {'icon': FontAwesomeIcons.mountain, 'label': 'Núi non'},
      {'icon': FontAwesomeIcons.landmark, 'label': 'Di tích'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Điểm nổi bật',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: kDefaultPadding),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.5,
            crossAxisSpacing: kDefaultPadding,
            mainAxisSpacing: kDefaultPadding,
          ),
          itemCount: highlights.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: kDefaultPadding,
                vertical: kMinPadding,
              ),
              decoration: BoxDecoration(
                color: ColorPalette.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(kDefaultPadding),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    highlights[index]['icon'] as IconData,
                    size: 14,
                    color: ColorPalette.primaryColor,
                  ),
                  SizedBox(width: kMinPadding),
                  Flexible(
                    child: Text(
                      highlights[index]['label'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorPalette.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGallerySection(PopularDestination destination) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hình ảnh',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: kDefaultPadding),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              final images = [
                destination.imageUrl,
                AssetHelper.imgHotel1,
                AssetHelper.imgHotel2,
                AssetHelper.imgHotel3,
              ];
              return Container(
                width: 120,
                margin: EdgeInsets.only(right: kDefaultPadding),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(kDefaultPadding),
                  child: ImageHelper.loadFromAsset(
                    images[index],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(PopularDestination destination) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Đánh giá',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  DestinationReviewsScreen.routeName,
                  arguments: {
                    'destinationId': destination.id,
                    'destinationName': destination.name,
                    'targetType': 'location',
                  },
                );
              },
              child: Text(
                'Xem tất cả',
                style: TextStyle(
                  color: ColorPalette.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: kDefaultPadding),
        _buildReviewItem(),
        SizedBox(height: kDefaultPadding),
        _buildReviewItem(),
      ],
    );
  }

  Widget _buildReviewItem() {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(kDefaultPadding),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: ColorPalette.primaryColor,
                child: Text(
                  'NV',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: kDefaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nguyễn Văn A',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 14,
                          );
                        }),
                        SizedBox(width: kMinPadding),
                        Text(
                          '2 ngày trước',
                          style: TextStyle(
                            color: ColorPalette.subTitleColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: kDefaultPadding),
          Text(
            'Địa điểm tuyệt vời! Phong cảnh đẹp, không khí trong lành. Rất đáng để ghé thăm.',
            style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingSection(PopularDestination destination) {
    return Column(
      children: [
        // Tạm ẩn nút "Lên kế hoạch du lịch"
        // ButtonWidget(
        //   title: 'Lên kế hoạch du lịch',
        //   onTap: () {
        //     Navigator.pushNamed(context, '/trip_creation_screen');
        //   },
        // ),
        // SizedBox(height: kDefaultPadding),
        OutlinedButton.icon(
          onPressed: () {
            // Navigate to Map
            Navigator.pop(context);
          },
          icon: Icon(Icons.map, size: 18),
          label: Text('Xem trên bản đồ'),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: kDefaultPadding),
            side: BorderSide(color: ColorPalette.primaryColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  // Default destination nếu không có data
  PopularDestination _getDefaultDestination() {
    return PopularDestination(
      id: '0',
      name: 'Địa điểm du lịch',
      country: 'Việt Nam',
      imageUrl: AssetHelper.imgHotel3,
      rating: 4.5,
      reviewCount: 100,
      description: 'Một địa điểm tuyệt vời để khám phá',
    );
  }
}
