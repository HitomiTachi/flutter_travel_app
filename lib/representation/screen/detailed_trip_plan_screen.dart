import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';

import 'package:flutter_travels_apps/data/models/trip_plan_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailedTripPlanScreen extends StatefulWidget {
  const DetailedTripPlanScreen({Key? key}) : super(key: key);

  static const String routeName = '/detailed_trip_plan_screen';

  @override
  State<DetailedTripPlanScreen> createState() => _DetailedTripPlanScreenState();
}

class _DetailedTripPlanScreenState extends State<DetailedTripPlanScreen>
    with TickerProviderStateMixin {
  int selectedDay = 1;
  late TripPlanData tripData;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late PageController _pageController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _pageController = PageController();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is TripPlanData) {
        setState(() {
          tripData = args;
          isLoading = false;
        });
      } else {
        tripData = TripPlanData();
        setState(() {
          isLoading = false;
        });
      }
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // Dữ liệu mẫu cho kế hoạch chi tiết với icon và màu sắc
  Map<int, List<TripActivity>> get tripPlan => {
    for (int i = 1; i <= tripData.totalDays; i++)
      i: _getActivitiesForDay(i),
  };

  List<TripActivity> _getActivitiesForDay(int day) {
    // Tạo dữ liệu mẫu cho từng ngày
    switch (day) {
      case 1:
        return [
          TripActivity(
            time: '06:00',
            title: 'Khởi hành từ ${tripData.departure}',
            description: 'Chuẩn bị hành lý và di chuyển đến điểm khởi hành',
            type: ActivityType.transport,
            duration: '2 giờ',
            cost: '500,000 VNĐ',
            icon: FontAwesomeIcons.planeDeparture,
            color: Colors.orange,
          ),
          TripActivity(
            time: '14:00',
            title: 'Check-in chỗ ở',
            description: 'Nhận phòng và nghỉ ngơi sau chuyến đi',
            type: ActivityType.accommodation,
            duration: '30 phút',
            cost: '${tripData.budget ~/ tripData.totalDays} VNĐ/ngày',
            icon: FontAwesomeIcons.bed,
            color: Colors.blue,
          ),
          TripActivity(
            time: '16:00',
            title: 'Khám phá khu vực xung quanh',
            description: 'Dạo quanh và làm quen với môi trường mới',
            type: ActivityType.sightseeing,
            duration: '2 giờ',
            cost: 'Miễn phí',
            icon: FontAwesomeIcons.locationDot,
            color: Colors.green,
          ),
          TripActivity(
            time: '19:00',
            title: 'Ăn tối đặc sản địa phương',
            description: 'Thưởng thức món ăn truyền thống',
            type: ActivityType.dining,
            duration: '1.5 giờ',
            cost: '300,000 VNĐ',
            icon: FontAwesomeIcons.utensils,
            color: Colors.red,
          ),
        ];
      case 2:
        return [
          TripActivity(
            time: '08:00',
            title: 'Ăn sáng và chuẩn bị',
            description: 'Bắt đầu ngày mới với bữa sáng ngon',
            type: ActivityType.dining,
            duration: '1 giờ',
            cost: '150,000 VNĐ',
            icon: FontAwesomeIcons.mugHot,
            color: Colors.brown,
          ),
          TripActivity(
            time: '09:30',
            title: 'Tham quan điểm nổi tiếng',
            description: 'Khám phá những địa danh không thể bỏ qua',
            type: ActivityType.sightseeing,
            duration: '3 giờ',
            cost: '200,000 VNĐ',
            icon: FontAwesomeIcons.camera,
            color: Colors.purple,
          ),
          TripActivity(
            time: '14:00',
            title: 'Hoạt động giải trí',
            description: 'Tham gia các hoạt động thú vị',
            type: ActivityType.entertainment,
            duration: '2 giờ',
            cost: '400,000 VNĐ',
            icon: FontAwesomeIcons.gamepad,
            color: Colors.indigo,
          ),
          TripActivity(
            time: '17:00',
            title: 'Mua sắm kỷ niệm',
            description: 'Tìm mua những món quà đặc biệt',
            type: ActivityType.shopping,
            duration: '2 giờ',
            cost: '500,000 VNĐ',
            icon: FontAwesomeIcons.bagShopping,
            color: Colors.pink,
          ),
        ];
      default:
        return [
          TripActivity(
            time: '09:00',
            title: 'Hoạt động tự do',
            description: 'Thời gian tự do khám phá theo sở thích',
            type: ActivityType.leisure,
            duration: '4 giờ',
            cost: 'Tùy chọn',
            icon: FontAwesomeIcons.clock,
            color: Colors.teal,
          ),
          TripActivity(
            time: '15:00',
            title: 'Nghỉ ngơi và thư giãn',
            description: 'Dành thời gian nghỉ ngơi tại chỗ ở',
            type: ActivityType.leisure,
            duration: '2 giờ',
            cost: 'Miễn phí',
            icon: FontAwesomeIcons.spa,
            color: Colors.cyan,
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return AppBarContainerWidget(
      titleString: 'Kế Hoạch Chi Tiết',
      implementLeading: true,
      child: Column(
        children: [
          // Trip Summary Card
          _buildTripSummaryCard(),
          
          // Day Navigation
          _buildModernDaySelector(),
          
          // Activities Content
          Expanded(
            child: _buildActivitiesPageView(),
          ),
          
          // Bottom Action Bar
          _buildBottomActionBar(),
        ],
      ),
    );
  }

  Widget _buildTripSummaryCard() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.all(kMediumPadding),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kTopPadding * 1.5),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kTopPadding * 1.5),
              gradient: LinearGradient(
                colors: [
                  ColorPalette.primaryColor,
                  ColorPalette.primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(kMediumPadding * 1.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        FontAwesomeIcons.mapLocationDot,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tripData.destination,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Từ ${tripData.departure}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: kMediumPadding),
                
                Row(
                  children: [
                    _buildInfoChip(
                      FontAwesomeIcons.calendar,
                      '${tripData.totalDays} ngày',
                    ),
                    const SizedBox(width: 12),
                    _buildInfoChip(
                      FontAwesomeIcons.users,
                      '${tripData.travelers} người',
                    ),
                    const SizedBox(width: 12),
                    _buildInfoChip(
                      FontAwesomeIcons.coins,
                      '${_formatCurrency(tripData.budget)}',
                    ),
                  ],
                ),
                
                const SizedBox(height: kDefaultPadding),
                
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        FontAwesomeIcons.clockFour,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        tripData.dateRange,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernDaySelector() {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: tripData.totalDays,
        itemBuilder: (context, index) {
          final day = index + 1;
          final isSelected = day == selectedDay;
          final hasActivities = tripPlan[day]?.isNotEmpty ?? false;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDay = day;
              });
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 60,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          ColorPalette.primaryColor,
                          ColorPalette.primaryColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    : null,
                color: !isSelected ? Colors.grey[50] : null,
                borderRadius: BorderRadius.circular(kTopPadding),
                border: Border.all(
                  color: isSelected
                      ? ColorPalette.primaryColor
                      : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: ColorPalette.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ngày',
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$day',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: hasActivities
                          ? (isSelected ? Colors.white : ColorPalette.primaryColor)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActivitiesPageView() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          selectedDay = index + 1;
        });
      },
      itemCount: tripData.totalDays,
      itemBuilder: (context, index) {
        final day = index + 1;
        final activities = tripPlan[day] ?? [];
        
        return AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 300),
          child: _buildDayActivities(day, activities),
        );
      },
    );
  }

  Widget _buildDayActivities(int day, List<TripActivity> activities) {
    if (activities.isEmpty) {
      return _buildEmptyDayState(day);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(kMediumPadding),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return _buildModernActivityCard(activity, index, activities.length);
      },
    );
  }

  Widget _buildEmptyDayState(int day) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              FontAwesomeIcons.calendarPlus,
              size: 32,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Ngày $day chưa có kế hoạch',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thêm hoạt động để tạo kế hoạch chi tiết',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddActivityDialog(day),
            icon: const Icon(FontAwesomeIcons.plus, size: 16),
            label: const Text('Thêm hoạt động'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalette.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kTopPadding),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernActivityCard(TripActivity activity, int index, int total) {
    final isLast = index == total - 1;
    
    return Container(
      margin: const EdgeInsets.only(bottom: kMediumPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline với animation
          Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      activity.color,
                      activity.color.withOpacity(0.7),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: activity.color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  activity.icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 40,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        activity.color.withOpacity(0.3),
                        Colors.grey[300]!,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(width: kMediumPadding),
          
          // Activity Card
          Expanded(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kTopPadding),
              ),
              child: Container(
                padding: const EdgeInsets.all(kMediumPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kTopPadding),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.grey[50]!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: activity.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            activity.time,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: activity.color,
                            ),
                          ),
                        ),
                        const Spacer(),
                        _buildActivityTypeChip(activity.type),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      activity.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      activity.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        _buildActivityInfo(
                          FontAwesomeIcons.clock,
                          activity.duration,
                          Colors.blue,
                        ),
                        const SizedBox(width: 16),
                        _buildActivityInfo(
                          FontAwesomeIcons.coins,
                          activity.cost,
                          Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTypeChip(ActivityType type) {
    final typeInfo = _getActivityTypeInfo(type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: typeInfo['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        typeInfo['label'],
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: typeInfo['color'],
        ),
      ),
    );
  }

  Widget _buildActivityInfo(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(kMediumPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showAddActivityDialog(selectedDay),
              icon: const Icon(FontAwesomeIcons.plus, size: 16),
              label: const Text('Thêm hoạt động'),
              style: OutlinedButton.styleFrom(
                foregroundColor: ColorPalette.primaryColor,
                side: BorderSide(color: ColorPalette.primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kTopPadding),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _saveTripPlan,
              icon: const Icon(FontAwesomeIcons.floppyDisk, size: 16),
              label: const Text('Lưu kế hoạch'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kTopPadding),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getActivityTypeInfo(ActivityType type) {
    switch (type) {
      case ActivityType.transport:
        return {'label': 'Di chuyển', 'color': Colors.orange};
      case ActivityType.accommodation:
        return {'label': 'Lưu trú', 'color': Colors.blue};
      case ActivityType.sightseeing:
        return {'label': 'Tham quan', 'color': Colors.green};
      case ActivityType.dining:
        return {'label': 'Ăn uống', 'color': Colors.red};
      case ActivityType.shopping:
        return {'label': 'Mua sắm', 'color': Colors.pink};
      case ActivityType.entertainment:
        return {'label': 'Giải trí', 'color': Colors.purple};
      case ActivityType.leisure:
        return {'label': 'Tự do', 'color': Colors.teal};
    }
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M VNĐ';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K VNĐ';
    }
    return '${amount.toStringAsFixed(0)} VNĐ';
  }

  void _showAddActivityDialog(int day) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAddActivityBottomSheet(day),
    );
  }

  Widget _buildAddActivityBottomSheet(int day) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(kMediumPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: 20),
          Text(
            'Thêm hoạt động - Ngày $day',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Tính năng này đang phát triển...',
            style: TextStyle(fontSize: 16),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kTopPadding),
                ),
              ),
              child: const Text('Đóng', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  void _saveTripPlan() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Kế hoạch đã được lưu thành công!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

// Enum cho loại hoạt động
enum ActivityType {
  transport,
  accommodation,
  sightseeing,
  dining,
  shopping,
  entertainment,
  leisure,
}

// Enhanced Activity Model
class TripActivity {
  final String time;
  final String title;
  final String description;
  final ActivityType type;
  final String duration;
  final String cost;
  final IconData icon;
  final Color color;

  TripActivity({
    required this.time,
    required this.title,
    required this.description,
    required this.type,
    required this.duration,
    required this.cost,
    required this.icon,
    required this.color,
  });
}