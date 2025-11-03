import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:flutter_travels_apps/representation/widgets/common/app_bar_container.dart';
import 'package:flutter_travels_apps/data/models/trip_plan_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailedTripPlanScreen extends StatefulWidget {
  const DetailedTripPlanScreen({super.key});
  static const String routeName = '/detailed_trip_plan_screen';

  @override
  State<DetailedTripPlanScreen> createState() => _DetailedTripPlanScreenState();
}

class _DetailedTripPlanScreenState extends State<DetailedTripPlanScreen>
    with TickerProviderStateMixin {
  int selectedDay = 1;
  late TripPlanData tripData;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final PageController _pageController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 260),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _pageController = PageController(initialPage: selectedDay - 1);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is TripPlanData) {
        tripData = args;
      } else {
        tripData = TripPlanData();
      }
      selectedDay = tripData.totalDays.clamp(1, tripData.totalDays);
      isLoading = false;
      setState(() {});
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // ================== SAMPLE DATA ==================
  Map<int, List<TripActivity>> get tripPlan => {
        for (int i = 1; i <= tripData.totalDays; i++) i: _getActivitiesForDay(i),
      };

  List<TripActivity> _getActivitiesForDay(int day) {
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
            color: ColorPalette.yellowColor,
          ),
          TripActivity(
            time: '14:00',
            title: 'Check-in chỗ ở',
            description: 'Nhận phòng và nghỉ ngơi sau chuyến đi',
            type: ActivityType.accommodation,
            duration: '30 phút',
            cost: '${tripData.budget ~/ (tripData.totalDays == 0 ? 1 : tripData.totalDays)} VNĐ/ngày',
            icon: FontAwesomeIcons.bed,
            color: ColorPalette.secondColor,
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

  // ================== UI ==================
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bottomSafe = MediaQuery.of(context).padding.bottom;

        return AppBarContainerWidget(
          implementLeading: true,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Kế Hoạch Chi Tiết',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.defaultStyle.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(FontAwesomeIcons.route, size: 16, color: Colors.white.withOpacity(0.92)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tripData.destination.isNotEmpty
                            ? 'Điểm đến: ${tripData.destination}'
                            : 'Điền thông tin chuyến đi của bạn',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.defaultStyle.copyWith(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.92),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Align(
                  alignment: Alignment.topRight,
                  child: _buildMiniSummaryBadge(),
                ),
              ],
            ),
          ),
          child: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FA), // Softer background
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorPalette.primaryColor.withOpacity(0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(color: ColorPalette.dividerColor.withOpacity(0.12), width: 1),
              ),
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lịch trình theo ngày',
                    style: TextStyles.defaultStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.textColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildModernDaySelector(),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: _buildActivitiesPageView(bottomInset: bottomSafe + 84),
              ),
            ),
            _buildBottomActionBar(),
          ],
        ),
      ),
    );
  }


  Widget _buildMiniSummaryBadge() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(FontAwesomeIcons.calendar, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text('${tripData.totalDays}N',
              style: TextStyles.defaultStyle.copyWith(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(width: 10),
          const Icon(FontAwesomeIcons.users, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text('${tripData.travelers}',
              style: TextStyles.defaultStyle.copyWith(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  

  Widget _buildModernDaySelector() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        itemCount: tripData.totalDays,
        itemBuilder: (context, index) {
          final day = index + 1;
          final isSelected = day == selectedDay;
          final hasActivities = (tripPlan[day]?.isNotEmpty ?? false);

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
            child: GestureDetector(
              onTap: () {
                setState(() => selectedDay = day);
                _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOutCubic);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 64,
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [ColorPalette.primaryColor, ColorPalette.secondColor],
                        )
                      : null,
                  color: !isSelected ? Colors.white : null,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? ColorPalette.primaryColor : ColorPalette.dividerColor,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: ColorPalette.primaryColor.withOpacity(0.18),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Ngày',
                          style: TextStyles.defaultStyle.copyWith(
                            fontSize: 12,
                            color: isSelected ? Colors.white : ColorPalette.subTitleColor,
                            fontWeight: FontWeight.w500,
                          )),
                      const SizedBox(height: 3),
                      Text('$day',
                          style: TextStyles.defaultStyle.copyWith(
                            fontSize: 22,
                            color: isSelected ? Colors.white : ColorPalette.textColor,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: hasActivities ? (isSelected ? Colors.white : ColorPalette.primaryColor) : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActivitiesPageView({required double bottomInset}) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) => setState(() => selectedDay = index + 1),
      itemCount: tripData.totalDays,
      itemBuilder: (context, index) {
        final day = index + 1;
        final activities = tripPlan[day] ?? [];
        return _buildDayActivities(day, activities, bottomInset: bottomInset);
      },
    );
  }

  Widget _buildDayActivities(int day, List<TripActivity> activities, {required double bottomInset}) {
    if (activities.isEmpty) return _buildEmptyDayState(day);

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(kMediumPadding, kMediumPadding, kMediumPadding, bottomInset),
      itemCount: activities.length,
      itemBuilder: (context, index) => _buildModernActivityCard(activities[index], index, activities.length),
    );
  }

  Widget _buildEmptyDayState(int day) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(
                color: ColorPalette.backgroundScaffoldColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(FontAwesomeIcons.calendarPlus, size: 28, color: ColorPalette.subTitleColor),
            ),
            const SizedBox(height: 18),
            Text('Ngày $day chưa có kế hoạch',
                style: TextStyles.defaultStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ColorPalette.subTitleColor,
                )),
            const SizedBox(height: 6),
            Text('Thêm hoạt động để tạo kế hoạch chi tiết',
                textAlign: TextAlign.center,
                style: TextStyles.defaultStyle.copyWith(fontSize: 13, color: ColorPalette.subTitleColor)),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: () => _showAddActivityDialog(day),
              icon: const Icon(FontAwesomeIcons.plus, size: 14),
              label: Text('Thêm hoạt động', style: TextStyles.defaultStyle.copyWith(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kTopPadding)),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernActivityCard(TripActivity activity, int index, int total) {
    final isLast = index == total - 1;

    return LayoutBuilder(builder: (context, constraints) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline avatar + connector (cao theo nội dung)
          Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [activity.color, activity.color.withOpacity(0.7)]),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: activity.color.withOpacity(0.28), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Icon(activity.icon, color: Colors.white, size: 20),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 42,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [activity.color.withOpacity(0.35), ColorPalette.dividerColor],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: kMediumPadding),
          // Card
          Expanded(
            child: Card(
              elevation: 2,
              shadowColor: ColorPalette.primaryColor.withOpacity(0.08),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kTopPadding)),
              child: Container(
                padding: const EdgeInsets.all(kMediumPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kTopPadding),
                  gradient: LinearGradient(colors: [Colors.white, Colors.grey[50]!], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: activity.color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: Text(activity.time,
                          style: TextStyles.defaultStyle.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: activity.color,
                          )),
                    ),
                    const Spacer(),
                    _buildActivityTypeChip(activity.type),
                  ]),
                  const SizedBox(height: 8),
                  Text(activity.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.defaultStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold, color: ColorPalette.textColor)),
                  const SizedBox(height: 4),
                  Text(activity.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.defaultStyle.copyWith(fontSize: 13, color: ColorPalette.subTitleColor, height: 1.35)),
                  const SizedBox(height: 12),
                  Row(children: [
                    _buildActivityInfo(FontAwesomeIcons.clock, activity.duration, ColorPalette.secondColor),
                    const SizedBox(width: 16),
                    _buildActivityInfo(FontAwesomeIcons.coins, activity.cost, ColorPalette.yellowColor),
                  ]),
                ]),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildActivityTypeChip(ActivityType type) {
    final info = _getActivityTypeInfo(type);
    final Color c = info['color'] as Color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Text(info['label'] as String,
          style: TextStyles.defaultStyle.copyWith(fontSize: 11, fontWeight: FontWeight.w600, color: c)),
    );
  }

  Widget _buildActivityInfo(IconData icon, String text, Color color) {
    return Flexible(
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 6),
        Flexible(
          child: Text(text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.defaultStyle.copyWith(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(kMediumPadding, kMediumPadding, kMediumPadding, kMediumPadding),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA), // Softer background
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.primaryColor.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, -6),
          ),
        ],
        border: Border.all(color: ColorPalette.dividerColor.withOpacity(0.13), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showAddActivityDialog(selectedDay),
              icon: const Icon(FontAwesomeIcons.plus, size: 16),
              label: Text('Thêm hoạt động', style: TextStyles.defaultStyle.copyWith(fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                foregroundColor: ColorPalette.primaryColor,
                side: const BorderSide(color: ColorPalette.primaryColor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kTopPadding)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _saveTripPlan,
              icon: const Icon(FontAwesomeIcons.floppyDisk, size: 16),
              label: Text('Lưu kế hoạch',
                  style: TextStyles.defaultStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kTopPadding)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
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
        return {'label': 'Di chuyển', 'color': ColorPalette.yellowColor};
      case ActivityType.accommodation:
        return {'label': 'Lưu trú', 'color': ColorPalette.secondColor};
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
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      padding: const EdgeInsets.all(kMediumPadding),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
        ),
        const SizedBox(height: 18),
        Text('Thêm hoạt động - Ngày $day',
            style: TextStyles.defaultStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: ColorPalette.textColor)),
        const SizedBox(height: 14),
        Text('Tính năng này đang phát triển...',
            style: TextStyles.defaultStyle.copyWith(fontSize: 14, color: ColorPalette.subTitleColor)),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalette.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kTopPadding)),
            ),
            child: Text('Đóng',
                style: TextStyles.defaultStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ),
      ]),
    );
  }

  void _saveTripPlan() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kế hoạch đã được lưu thành công!', style: TextStyles.defaultStyle.copyWith(color: Colors.white)),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// ================== MODELS ==================
enum ActivityType { transport, accommodation, sightseeing, dining, shopping, entertainment, leisure }

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
