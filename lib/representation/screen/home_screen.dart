import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/core/helpers/images_helpers.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:flutter_travels_apps/representation/screen/profile_screen.dart';
import 'package:flutter_travels_apps/data/models/popular_destination.dart';
import 'package:flutter_travels_apps/data/models/featured_article.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();

}
  class _HomeScreenState extends State<HomeScreen>{

    // Dữ liệu mẫu cho Popular Destinations
    List<PopularDestination> get popularDestinations => [
      PopularDestination(
        id: '1',
        name: 'Hạ Long Bay',
        country: 'Việt Nam',
        imageUrl: 'assets/images/img1.jpg',
        rating: 4.9,
        reviewCount: 3247,
        description: 'Di sản thế giới với hàng nghìn đảo đá vôi kỳ thú',
        isPopular: true,
      ),
      PopularDestination(
        id: '2',
        name: 'Phú Quốc',
        country: 'Việt Nam',
        imageUrl: 'assets/images/img2.jpg',
        rating: 4.8,
        reviewCount: 2156,
        description: 'Đảo ngọc nhiệt đới với bãi biển cát trắng tuyệt đẹp',
        isPopular: true,
      ),
      PopularDestination(
        id: '3',
        name: 'Tokyo',
        country: 'Japan',
        imageUrl: 'assets/images/img3.jpg',
        rating: 4.7,
        reviewCount: 3521,
        description: 'Thủ đô hiện đại kết hợp văn hóa truyền thống độc đáo',
      ),
      PopularDestination(
        id: '4',
        name: 'Santorini',
        country: 'Hy Lạp',
        imageUrl: 'assets/images/imgHotel.jpg',
        rating: 4.9,
        reviewCount: 1923,
        description: 'Đảo lãng mạn với kiến trúc trắng xanh đặc trưng',
      ),
      PopularDestination(
        id: '5',
        name: 'Bali',
        country: 'Indonesia',
        imageUrl: 'assets/images/img1.jpg',
        rating: 4.6,
        reviewCount: 2847,
        description: 'Thiên đường nhiệt đới với văn hóa Hindu độc đáo',
      ),
      PopularDestination(
        id: '6',
        name: 'Đà Lạt',
        country: 'Việt Nam',
        imageUrl: 'assets/images/img2.jpg',
        rating: 4.5,
        reviewCount: 1654,
        description: 'Thành phố ngàn hoa với khí hậu mát mẻ quanh năm',
      ),
    ];

    // Dữ liệu mẫu cho Featured Articles
    List<FeaturedArticle> get featuredArticles => [
      FeaturedArticle(
        id: '1',
        title: 'Top 15 Điểm Đến Tuyệt Vời Nhất Việt Nam 2024',
        subtitle: 'Khám phá những địa danh đẹp nhất đất nước hình chữ S từ Bắc vào Nam',
        imageUrl: 'assets/images/img1.jpg',
        author: 'Minh Châu',
        publishDate: DateTime.now().subtract(Duration(days: 1)),
        readTime: 12,
        category: 'Khám phá',
        likes: 1247,
        isFeatured: true,
      ),
      FeaturedArticle(
        id: '2',
        title: 'Bí Kíp Du Lịch Bụi Đông Nam Á Tiết Kiệm',
        subtitle: 'Hướng dẫn chi tiết để có chuyến đi backpacking hoàn hảo với ngân sách thấp',
        imageUrl: 'assets/images/img2.jpg',
        author: 'Hoàng Anh',
        publishDate: DateTime.now().subtract(Duration(days: 3)),
        readTime: 8,
        category: 'Mẹo hay',
        likes: 892,
        isFeatured: true,
      ),
      FeaturedArticle(
        id: '3',
        title: 'Ẩm Thực Đường Phố Sài Gòn Phải Thử',
        subtitle: 'Những món ăn vặt không thể bỏ qua khi đến thành phố Hồ Chí Minh',
        imageUrl: 'assets/images/img3.jpg',
        author: 'Thuỳ Linh',
        publishDate: DateTime.now().subtract(Duration(days: 5)),
        readTime: 6,
        category: 'Ẩm thực',
        likes: 567,
      ),
      FeaturedArticle(
        id: '4',
        title: 'Resort Cao Cấp Phú Quốc Đáng Trải Nghiệm',
        subtitle: 'Danh sách những khu nghỉ dưỡng 5 sao tốt nhất tại đảo ngọc',
        imageUrl: 'assets/images/imgHotel.jpg',
        author: 'Đức Minh',
        publishDate: DateTime.now().subtract(Duration(days: 7)),
        readTime: 10,
        category: 'Nghỉ dưỡng',
        likes: 724,
      ),
      FeaturedArticle(
        id: '5',
        title: 'Hành Trình Khám Phá Hạ Long Bằng Du Thuyền',
        subtitle: 'Trải nghiệm overnight cruise qua vịnh Hạ Long huyền diệu',
        imageUrl: 'assets/images/img1.jpg',
        author: 'Văn Hưng',
        publishDate: DateTime.now().subtract(Duration(days: 10)),
        readTime: 15,
        category: 'Phiêu lưu',
        likes: 445,
      ),
      FeaturedArticle(
        id: '6',
        title: 'Lịch Trình Du Lịch Đà Lạt 3 Ngày 2 Đêm',
        subtitle: 'Khám phá thành phố ngàn hoa với lịch trình chi tiết và tiết kiệm',
        imageUrl: 'assets/images/img2.jpg',
        author: 'Thanh Hà',
        publishDate: DateTime.now().subtract(Duration(days: 12)),
        readTime: 9,
        category: 'Lịch trình',
        likes: 658,
      ),
    ];

    Widget _buildItemCategory(Widget icon, Color color, Function() onTap, String title){
      return GestureDetector(
        onTap: onTap,
        child: Container(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 60,
                padding: EdgeInsets.symmetric(
                  vertical: kMediumPadding,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(kItemPadding)
                ),
                child: Center(child: icon),
              ),
              SizedBox(height: kDefaultPadding / 2),
              Container(
                height: 32,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildPopularDestinations() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Điểm Đến Phổ Biến',
                  style: TextStyles.defaultStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.textColor,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Tính năng đang phát triển'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Text(
                    'Xem thêm',
                    style: TextStyles.defaultStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ColorPalette.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: kMediumPadding),
          Container(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              itemCount: popularDestinations.length,
              itemBuilder: (context, index) {
                final destination = popularDestinations[index];
                return _buildDestinationCard(destination, index);
              },
            ),
          ),
        ],
      );
    }

    Widget _buildDestinationCard(PopularDestination destination, int index) {
      return Container(
        width: 220,
        margin: EdgeInsets.only(right: kDefaultPadding),
        child: Card(
          elevation: 12,
          shadowColor: ColorPalette.primaryColor.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kTopPadding * 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(kTopPadding * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Stack(
                  children: [
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(destination.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Gradient Overlay
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                    // Popular Badge
                    if (destination.isPopular)
                      Positioned(
                        top: kMediumPadding,
                        right: kMediumPadding,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: kItemPadding,
                            vertical: kMinPadding,
                          ),
                          decoration: BoxDecoration(
                            color: ColorPalette.yellowColor,
                            borderRadius: BorderRadius.circular(kTopPadding * 2),
                            boxShadow: [
                              BoxShadow(
                                color: ColorPalette.yellowColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            'Phổ biến',
                            style: TextStyles.defaultStyle.copyWith(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    // Rating Badge
                    Positioned(
                      bottom: kMediumPadding,
                      left: kMediumPadding,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: kItemPadding,
                          vertical: kMinPadding,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(kTopPadding),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              FontAwesomeIcons.star,
                              color: ColorPalette.yellowColor,
                              size: kDefaultIconSize - 4,
                            ),
                            SizedBox(width: kMinPadding),
                            Text(
                              destination.rating.toString(),
                              style: TextStyles.defaultStyle.copyWith(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Content Section
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(kDefaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          destination.name,
                          style: TextStyles.defaultStyle.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: ColorPalette.textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: kMinPadding),
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.locationDot,
                              color: ColorPalette.subTitleColor,
                              size: kDefaultIconSize - 4,
                            ),
                            SizedBox(width: kMinPadding),
                            Expanded(
                              child: Text(
                                destination.country,
                                style: TextStyles.defaultStyle.copyWith(
                                  fontSize: 13,
                                  color: ColorPalette.subTitleColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: kTopPadding),
                        Expanded(
                          child: Text(
                            destination.description,
                            style: TextStyles.defaultStyle.copyWith(
                              fontSize: 12,
                              color: ColorPalette.subTitleColor,
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: kTopPadding),
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.users,
                              color: ColorPalette.primaryColor,
                              size: kDefaultIconSize - 6,
                            ),
                            SizedBox(width: kMinPadding),
                            Text(
                              '${destination.reviewCount}+ đánh giá',
                              style: TextStyles.defaultStyle.copyWith(
                                fontSize: 11,
                                color: ColorPalette.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildFeaturedArticles() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bài Viết Nổi Bật',
                  style: TextStyles.defaultStyle.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.textColor,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Tính năng đang phát triển'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Text(
                    'Xem tất cả',
                    style: TextStyles.defaultStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ColorPalette.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: kMediumPadding),
          // Grid Layout cho Articles
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Column(
              children: [
                // Hàng đầu tiên: 1 article lớn bên trái, 2 article nhỏ bên phải
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Article lớn bên trái
                    Expanded(
                      flex: 3,
                      child: _buildLargeArticleCard(featuredArticles[0]),
                    ),
                    SizedBox(width: kDefaultPadding),
                    // Cột bên phải với 2 article nhỏ
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _buildCompactArticleCard(featuredArticles[1]),
                          SizedBox(height: kDefaultPadding),
                          _buildCompactArticleCard(featuredArticles[2]),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: kMediumPadding),
                // Hàng thứ hai: Horizontal scroll cho các article còn lại
                if (featuredArticles.length > 3)
                  Container(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: featuredArticles.length - 3,
                      itemBuilder: (context, index) {
                        final article = featuredArticles[index + 3];
                        return Container(
                          width: 300,
                          margin: EdgeInsets.only(right: kDefaultPadding),
                          child: _buildHorizontalArticleCard(article),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    }

    Widget _buildLargeArticleCard(FeaturedArticle article) {
      return Card(
        elevation: 12,
        shadowColor: ColorPalette.primaryColor.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kTopPadding * 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(kTopPadding * 2),
          child: Container(
            height: 300,
            child: Stack(
              children: [
                // Background Image
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(article.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        ColorPalette.primaryColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
                // Category Badge
                Positioned(
                  top: kDefaultPadding,
                  left: kDefaultPadding,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: kMediumPadding,
                      vertical: kTopPadding,
                    ),
                    decoration: BoxDecoration(
                      color: ColorPalette.yellowColor,
                      borderRadius: BorderRadius.circular(kTopPadding * 2),
                      boxShadow: [
                        BoxShadow(
                          color: ColorPalette.yellowColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      article.category,
                      style: TextStyles.defaultStyle.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Content
                Positioned(
                  bottom: kDefaultPadding,
                  left: kDefaultPadding,
                  right: kDefaultPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        style: TextStyles.defaultStyle.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: kTopPadding),
                      Text(
                        'Bởi ${article.author}',
                        style: TextStyles.defaultStyle.copyWith(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: kTopPadding),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.clock,
                            color: Colors.white70,
                            size: kDefaultIconSize - 4,
                          ),
                          SizedBox(width: kMinPadding),
                          Text(
                            '${article.readTime} phút đọc',
                            style: TextStyles.defaultStyle.copyWith(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: kDefaultPadding),
                          Icon(
                            FontAwesomeIcons.heart,
                            color: ColorPalette.yellowColor,
                            size: kDefaultIconSize - 4,
                          ),
                          SizedBox(width: kMinPadding),
                          Text(
                            article.likes.toString(),
                            style: TextStyles.defaultStyle.copyWith(
                              color: Colors.white70,
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
          ),
        ),
      );
    }

    Widget _buildCompactArticleCard(FeaturedArticle article) {
      return Card(
        elevation: 8,
        shadowColor: ColorPalette.primaryColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kMediumPadding),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(kMediumPadding),
          child: Container(
            height: 140,
            child: Stack(
              children: [
                // Background Image
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(article.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        ColorPalette.primaryColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
                // Category Badge
                Positioned(
                  top: kTopPadding,
                  left: kTopPadding,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: kTopPadding,
                      vertical: kMinPadding,
                    ),
                    decoration: BoxDecoration(
                      color: ColorPalette.secondColor,
                      borderRadius: BorderRadius.circular(kMediumPadding),
                    ),
                    child: Text(
                      article.category,
                      style: TextStyles.defaultStyle.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Content
                Positioned(
                  bottom: kTopPadding,
                  left: kTopPadding,
                  right: kTopPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        article.title,
                        style: TextStyles.defaultStyle.copyWith(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: kMinPadding),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.clock,
                            color: Colors.white70,
                            size: kDefaultIconSize - 6,
                          ),
                          SizedBox(width: kMinPadding),
                          Text(
                            '${article.readTime}p',
                            style: TextStyles.defaultStyle.copyWith(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            FontAwesomeIcons.heart,
                            color: ColorPalette.yellowColor,
                            size: kDefaultIconSize - 6,
                          ),
                          SizedBox(width: kMinPadding),
                          Text(
                            article.likes.toString(),
                            style: TextStyles.defaultStyle.copyWith(
                              color: Colors.white70,
                              fontSize: 10,
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

    Widget _buildHorizontalArticleCard(FeaturedArticle article) {
      return Card(
        elevation: 8,
        shadowColor: ColorPalette.primaryColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kMediumPadding),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(kMediumPadding),
          child: Row(
            children: [
              // Image Section
              Container(
                width: 120,
                height: 160,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(article.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Content Section
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(kDefaultPadding),
                  height: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: kItemPadding,
                          vertical: kMinPadding,
                        ),
                        decoration: BoxDecoration(
                          color: ColorPalette.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(kTopPadding),
                        ),
                        child: Text(
                          article.category,
                          style: TextStyles.defaultStyle.copyWith(
                            color: ColorPalette.primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: kTopPadding),
                      Expanded(
                        child: Text(
                          article.title,
                          style: TextStyles.defaultStyle.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: ColorPalette.textColor,
                            height: 1.3,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: kMinPadding),
                      Text(
                        'Bởi ${article.author}',
                        style: TextStyles.defaultStyle.copyWith(
                          fontSize: 12,
                          color: ColorPalette.subTitleColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: kTopPadding),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.clock,
                            color: ColorPalette.subTitleColor,
                            size: kDefaultIconSize - 6,
                          ),
                          SizedBox(width: kMinPadding),
                          Text(
                            '${article.readTime} phút',
                            style: TextStyles.defaultStyle.copyWith(
                              fontSize: 11,
                              color: ColorPalette.subTitleColor,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            FontAwesomeIcons.heart,
                            color: ColorPalette.yellowColor,
                            size: kDefaultIconSize - 6,
                          ),
                          SizedBox(width: kMinPadding),
                          Text(
                            article.likes.toString(),
                            style: TextStyles.defaultStyle.copyWith(
                              fontSize: 11,
                              color: ColorPalette.subTitleColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    @override
    Widget build(BuildContext context){
      return AppBarContainerWidget(
        title: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Xin Chào! ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          FontAwesomeIcons.handPeace,
                          size: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Bạn muốn đi đâu...?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  // TODO: Navigate to notifications
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Chức năng thông báo sẽ được phát triển'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.2),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    FontAwesomeIcons.bell,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 12,),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ProfileScreen.routeName);
                },
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: ImageHelper.loadFromAsset(
                        AssetHelper.person,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        // titleString: 'Home',
        // implementLeading: true,
        // implementTraling: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm điểm đến ...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(kTopPadding),
                    child: Icon(FontAwesomeIcons.magnifyingGlass,
                    color: Colors.black,
                    size: kDefaultPadding,),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(kItemPadding),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: kItemPadding,
                    ),
                  ),
                ),
                SizedBox(
                  height: kDefaultPadding,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildItemCategory(
                        ImageHelper.loadFromAsset(AssetHelper.iconlocation,
                        width: kBottomBarIconSize,
                        height: kBottomBarIconSize,),
                        Colors.blue,
                        () {
                          Navigator.of(context).pushNamed('/trip_plans_list_screen');
                        },
                        'Kế hoạch\nchuyến đi',
                      ),
                    ),
                    SizedBox(width: kDefaultPadding,),
                    Expanded(
                      child: _buildItemCategory(
                        Icon(
                          FontAwesomeIcons.map,
                          size: kBottomBarIconSize,
                          color: Colors.green[700],
                        ),
                        Colors.green,
                        () {
                          // TODO: Navigate to map screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Chức năng bản đồ sẽ được phát triển'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        'Bản đồ',
                      ),
                    ),
                    SizedBox(width: kDefaultPadding,),
                    Expanded(
                      child: _buildItemCategory(
                        ImageHelper.loadFromAsset(AssetHelper.allservices,
                        width: kBottomBarIconSize,
                        height: kBottomBarIconSize,),
                        Colors.orange,
                        () {},
                        'Tất cả dịch vụ',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: kTopPadding),
                // Popular Destinations Section
                _buildPopularDestinations(),
                SizedBox(height: kTopPadding),
                // Featured Articles Section
                _buildFeaturedArticles(),
                SizedBox(height: kTopPadding),
            ],
          ),
        ),
      );
    }

  }