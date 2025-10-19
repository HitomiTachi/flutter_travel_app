import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({Key? key}) : super(key: key);

  static const String routeName = '/like_screen';

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen>
    with TickerProviderStateMixin {
  
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Sample data
  final List<Map<String, dynamic>> _favoriteDestinations = [
    {
      'name': 'Hạ Long Bay',
      'location': 'Quảng Ninh, Việt Nam',
      'image': AssetHelper.image1,
      'rating': 4.8,
      'price': '1.200.000 VNĐ',
      'type': 'destination'
    },
    {
      'name': 'Phú Quốc',
      'location': 'Kiên Giang, Việt Nam', 
      'image': AssetHelper.image2,
      'rating': 4.6,
      'price': '2.500.000 VNĐ',
      'type': 'destination'
    },
    {
      'name': 'Đà Lạt',
      'location': 'Lâm Đồng, Việt Nam',
      'image': AssetHelper.image3,
      'rating': 4.7,
      'price': '800.000 VNĐ',
      'type': 'destination'
    },
  ];

  final List<Map<String, dynamic>> _favoriteArticles = [
    {
      'title': '10 Điều Cần Biết Khi Du Lịch Hạ Long',
      'author': 'Travel Expert',
      'image': AssetHelper.image1,
      'readTime': '5 phút',
      'publishDate': '2 ngày trước',
      'likes': 124,
      'type': 'article'
    },
    {
      'title': 'Khám Phá Ẩm Thực Đường Phố Sài Gòn',
      'author': 'Food Blogger',
      'image': AssetHelper.image2,
      'readTime': '8 phút',
      'publishDate': '1 tuần trước',
      'likes': 89,
      'type': 'article'
    },
    {
      'title': 'Bí Quyết Tiết Kiệm Chi Phí Du Lịch',
      'author': 'Budget Traveler',
      'image': AssetHelper.image3,
      'readTime': '6 phút',
      'publishDate': '3 ngày trước',
      'likes': 156,
      'type': 'article'
    },
  ];

  final List<Map<String, dynamic>> _favoriteVideos = [
    {
      'title': 'VLOG: 3 Ngày 2 Đêm Ở Đà Nẵng',
      'creator': 'Travel Vlogger',
      'image': AssetHelper.image1,
      'duration': '12:45',
      'views': '45K',
      'uploadDate': '1 ngày trước',
      'type': 'video'
    },
    {
      'title': 'Review Resort 5 Sao Phú Quốc',
      'creator': 'Luxury Travel',
      'image': AssetHelper.image2,
      'duration': '8:30',
      'views': '78K',
      'uploadDate': '4 ngày trước',
      'type': 'video'
    },
    {
      'title': 'Hướng Dẫn Lên Kế Hoạch Du Lịch',
      'creator': 'Travel Tips',
      'image': AssetHelper.image3,
      'duration': '15:20',
      'views': '32K',
      'uploadDate': '1 tuần trước',
      'type': 'video'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.backgroundScaffoldColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverAppBar(),
        ],
        body: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDestinationsTab(),
                    _buildArticlesTab(),
                    _buildVideosTab(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Sliver App Bar
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: ColorPalette.primaryColor,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: Gradients.defaultGradientBackground,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Yêu Thích',
          style: TextStyles.defaultStyle.fontHeader.bold.whiteTextColor,
        ),
      ),
    );
  }

  // Tab Bar
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: ColorPalette.primaryColor,
        unselectedLabelColor: ColorPalette.subTitleColor,
        indicatorColor: ColorPalette.primaryColor,
        indicatorWeight: 3,
        labelStyle: TextStyles.defaultStyle.medium,
        unselectedLabelStyle: TextStyles.defaultStyle.regular,
        tabs: const [
          Tab(
            icon: Icon(FontAwesomeIcons.mapLocationDot, size: 20),
            text: 'Địa điểm',
          ),
          Tab(
            icon: Icon(FontAwesomeIcons.newspaper, size: 20),
            text: 'Bài viết',
          ),
          Tab(
            icon: Icon(FontAwesomeIcons.play, size: 20),
            text: 'Video',
          ),
        ],
      ),
    );
  }

  // Destinations Tab
  Widget _buildDestinationsTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      itemCount: _favoriteDestinations.length,
      itemBuilder: (context, index) {
        final destination = _favoriteDestinations[index];
        return _buildDestinationCard(destination);
      },
    );
  }

  Widget _buildDestinationCard(Map<String, dynamic> destination) {
    return Container(
      margin: const EdgeInsets.only(bottom: kMediumPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 200,
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  destination['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 50),
                    );
                  },
                ),
              ),
              
              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Heart Icon
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () => _toggleFavorite(destination),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      FontAwesomeIcons.solidHeart,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ),
              
              // Content
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination['name'],
                      style: TextStyles.defaultStyle.fontHeader.bold.whiteTextColor,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.locationDot,
                          color: Colors.white70,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          destination['location'],
                          style: TextStyles.defaultStyle.regular.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              destination['rating'].toString(),
                              style: TextStyles.defaultStyle.semiBold.whiteTextColor,
                            ),
                          ],
                        ),
                        Text(
                          destination['price'],
                          style: TextStyles.defaultStyle.bold.whiteTextColor,
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

  // Articles Tab
  Widget _buildArticlesTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      itemCount: _favoriteArticles.length,
      itemBuilder: (context, index) {
        final article = _favoriteArticles[index];
        return _buildArticleCard(article);
      },
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> article) {
    return Container(
      margin: const EdgeInsets.only(bottom: kMediumPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Image
            Container(
              height: 160,
              width: double.infinity,
              child: Stack(
                children: [
                  Image.asset(
                    article['image'],
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 50),
                      );
                    },
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () => _toggleFavorite(article),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          FontAwesomeIcons.solidHeart,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Article Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article['title'],
                    style: TextStyles.defaultStyle.fontHeader.bold.text1Color,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: ColorPalette.primaryColor.withOpacity(0.2),
                        child: Icon(
                          FontAwesomeIcons.user,
                          size: 12,
                          color: ColorPalette.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        article['author'],
                        style: TextStyles.defaultStyle.medium.subTitleTextColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.clock,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            article['readTime'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            FontAwesomeIcons.heart,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${article['likes']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        article['publishDate'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
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
    );
  }

  // Videos Tab
  Widget _buildVideosTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      itemCount: _favoriteVideos.length,
      itemBuilder: (context, index) {
        final video = _favoriteVideos[index];
        return _buildVideoCard(video);
      },
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> video) {
    return Container(
      margin: const EdgeInsets.only(bottom: kMediumPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Thumbnail
            Container(
              height: 180,
              width: double.infinity,
              child: Stack(
                children: [
                  Image.asset(
                    video['image'],
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 50),
                      );
                    },
                  ),
                  
                  // Play Button Overlay
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            FontAwesomeIcons.play,
                            color: ColorPalette.primaryColor,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Duration Badge
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        video['duration'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  
                  // Heart Icon
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () => _toggleFavorite(video),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          FontAwesomeIcons.solidHeart,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Video Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: ColorPalette.primaryColor.withOpacity(0.2),
                        child: Icon(
                          FontAwesomeIcons.user,
                          size: 12,
                          color: ColorPalette.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        video['creator'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.eye,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${video['views']} lượt xem',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        video['uploadDate'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
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
    );
  }

  // Toggle Favorite
  void _toggleFavorite(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa khỏi danh sách yêu thích'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'Hoàn tác',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}