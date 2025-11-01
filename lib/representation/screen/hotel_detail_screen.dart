import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/core/helpers/images_helpers.dart';
import 'package:flutter_travels_apps/representation/widgets/button_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_travels_apps/representation/screen/review_screen.dart';
import 'package:flutter_travels_apps/services/share_service.dart';

class HotelDetailScreen extends StatefulWidget {
  const HotelDetailScreen({Key? key}) : super(key: key);

  static const String routeName = '/hotel_detail_screen';

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: ImageHelper.loadFromAsset(
              AssetHelper.imgHotel3,
              fit: BoxFit.cover,
            ),
          ),

          // Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + kDefaultPadding,
            left: kDefaultPadding,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
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
              child: Icon(FontAwesomeIcons.heart, size: 20, color: Colors.red),
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
                          // Hotel Name & Rating
                          _buildHotelHeader(),
                          SizedBox(height: kDefaultPadding),

                          // Nút Đánh giá và Chia sẻ
                          _buildActionButtons(),
                          SizedBox(height: kDefaultPadding),

                          // Location
                          _buildLocationSection(),
                          SizedBox(height: kDefaultPadding * 1.5),

                          // Description
                          _buildDescriptionSection(),
                          SizedBox(height: kDefaultPadding * 1.5),

                          // Amenities
                          _buildAmenitiesSection(),
                          SizedBox(height: kDefaultPadding * 1.5),

                          // Gallery
                          _buildGallerySection(),
                          SizedBox(height: kDefaultPadding * 1.5),

                          // Reviews
                          _buildReviewsSection(),
                          SizedBox(height: kDefaultPadding * 2),

                          // Price & Book Button
                          _buildBookingSection(),
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

  Widget _buildHotelHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Royal Pain Heritage',
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
                index < 4 ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 20,
              );
            }),
            SizedBox(width: kMinPadding),
            Text(
              '4.5',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.amber[700],
              ),
            ),
            SizedBox(width: kMinPadding),
            Text(
              '(3,241 reviews)',
              style: TextStyle(color: ColorPalette.subTitleColor, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final shareService = ShareService();
    const hotelName = 'Royal Pain Heritage';
    const hotelDescription = 'Khách sạn 5 sao sang trọng';

    return Container(
      padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewScreen(
                      targetId: 'hotel_1',
                      targetType: 'hotel',
                      targetName: hotelName,
                    ),
                  ),
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
                  name: hotelName,
                  description: hotelDescription,
                  rating: 4.5,
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
        Icon(
          FontAwesomeIcons.locationDot,
          size: 16,
          color: ColorPalette.primaryColor,
        ),
        SizedBox(width: kMinPadding),
        Expanded(
          child: Text(
            'Purwokerto, Jawa Tengah, Indonesia',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          '364 km away',
          style: TextStyle(color: ColorPalette.subTitleColor, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About this hotel',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: kDefaultPadding),
        Text(
          'Royal Pain Heritage is a luxurious heritage hotel located in the heart of Purwokerto. The hotel combines traditional Javanese architecture with modern amenities, offering guests a unique and comfortable stay experience.',
          style: TextStyle(color: Colors.black54, height: 1.6, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildAmenitiesSection() {
    final amenities = [
      {'icon': FontAwesomeIcons.wifi, 'label': 'Free WiFi'},
      {'icon': FontAwesomeIcons.car, 'label': 'Parking'},
      {'icon': FontAwesomeIcons.utensils, 'label': 'Restaurant'},
      {'icon': FontAwesomeIcons.dumbbell, 'label': 'Fitness'},
      {'icon': FontAwesomeIcons.personSwimming, 'label': 'Pool'},
      {'icon': FontAwesomeIcons.spa, 'label': 'Spa'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amenities',
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
          itemCount: amenities.length,
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
                    amenities[index]['icon'] as IconData,
                    size: 14,
                    color: ColorPalette.primaryColor,
                  ),
                  SizedBox(width: kMinPadding),
                  Flexible(
                    child: Text(
                      amenities[index]['label'] as String,
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

  Widget _buildGallerySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gallery',
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
                AssetHelper.imgHotel1,
                AssetHelper.imgHotel2,
                AssetHelper.imgHotel3,
                AssetHelper.imgHotel1,
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

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See all',
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
                  'JD',
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
                      'John Doe',
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
                          '2 days ago',
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
            'Amazing hotel with great service! The staff was very friendly and the room was clean and comfortable.',
            style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingSection() {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding * 1.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kDefaultPadding * 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$143',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.primaryColor,
                ),
              ),
              Text(
                'per night',
                style: TextStyle(
                  color: ColorPalette.subTitleColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(width: kDefaultPadding),
          Expanded(
            child: ButtonWidget(
              title: 'Book Now',
              onTap: () {
                // Handle booking
              },
            ),
          ),
        ],
      ),
    );
  }
}
