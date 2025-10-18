import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/data/models/trip_plan_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TripPlansListScreen extends StatefulWidget {
  const TripPlansListScreen({Key? key}) : super(key: key);

  static const String routeName = '/trip_plans_list_screen';

  @override
  State<TripPlansListScreen> createState() => _TripPlansListScreenState();
}

class _TripPlansListScreenState extends State<TripPlansListScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  String selectedFilter = 'Tất cả';
  List<String> filterOptions = ['Tất cả', 'Hoàn thành', 'Đang thực hiện', 'Kế hoạch'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Dữ liệu mẫu các kế hoạch chuyến đi
  List<TripPlan> get tripPlans => [
    TripPlan(
      id: '1',
      title: 'Khám phá Hà Nội',
      destination: 'Hà Nội, Việt Nam',
      startDate: '15 Nov 2024',
      endDate: '18 Nov 2024',
      duration: '4 ngày 3 đêm',
      budget: 3500000,
      travelers: 2,
      status: TripStatus.completed,
      imageUrl: 'assets/images/img1.jpg',
      activities: 12,
      progress: 1.0,
    ),
    TripPlan(
      id: '2',
      title: 'Phượt Sapa mùa lúa chín',
      destination: 'Sapa, Lào Cai',
      startDate: '20 Dec 2024',
      endDate: '23 Dec 2024',
      duration: '4 ngày 3 đêm',
      budget: 4200000,
      travelers: 4,
      status: TripStatus.ongoing,
      imageUrl: 'assets/images/img2.jpg',
      activities: 15,
      progress: 0.6,
    ),
    TripPlan(
      id: '3',
      title: 'Nghỉ dưỡng Đà Nẵng',
      destination: 'Đà Nẵng, Việt Nam',
      startDate: '10 Jan 2025',
      endDate: '15 Jan 2025',
      duration: '6 ngày 5 đêm',
      budget: 6800000,
      travelers: 2,
      status: TripStatus.planned,
      imageUrl: 'assets/images/img3.jpg',
      activities: 18,
      progress: 0.3,
    ),
    TripPlan(
      id: '4',
      title: 'Khám phá Phú Quốc',
      destination: 'Phú Quốc, Kiên Giang',
      startDate: '22 Feb 2025',
      endDate: '26 Feb 2025',
      duration: '5 ngày 4 đêm',
      budget: 5500000,
      travelers: 6,
      status: TripStatus.planned,
      imageUrl: 'assets/images/imgHotel.jpg',
      activities: 20,
      progress: 0.8,
    ),
    TripPlan(
      id: '5',
      title: 'Trekking Fansipan',
      destination: 'Sapa, Lào Cai',
      startDate: '05 Aug 2024',
      endDate: '08 Aug 2024',
      duration: '4 ngày 3 đêm',
      budget: 3200000,
      travelers: 3,
      status: TripStatus.completed,
      imageUrl: 'assets/images/imgHotel2.jpg',
      activities: 10,
      progress: 1.0,
    ),
  ];

  List<TripPlan> get filteredTrips {
    if (selectedFilter == 'Tất cả') return tripPlans;
    
    TripStatus filterStatus;
    switch (selectedFilter) {
      case 'Hoàn thành':
        filterStatus = TripStatus.completed;
        break;
      case 'Đang thực hiện':
        filterStatus = TripStatus.ongoing;
        break;
      case 'Kế hoạch':
        filterStatus = TripStatus.planned;
        break;
      default:
        return tripPlans;
    }
    
    return tripPlans.where((trip) => trip.status == filterStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Modern App Bar
          _buildSliverAppBar(),
          
          // Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    // Quick Stats
                    _buildQuickStats(),
                    
                    const SizedBox(height: 20),
                    
                    // Filter Chips
                    _buildFilterChips(),
                    
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
          
          // Trip Plans List
          _buildTripPlansList(),
          
          // Bottom Spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      
      // Floating Action Button
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: ColorPalette.primaryColor,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Kế Hoạch Chuyến Đi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 55, bottom: 16),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ColorPalette.primaryColor,
                ColorPalette.primaryColor.withOpacity(0.8),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -50,
                top: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                right: 20,
                top: 20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    final completedCount = tripPlans.where((t) => t.status == TripStatus.completed).length;
    final ongoingCount = tripPlans.where((t) => t.status == TripStatus.ongoing).length;
    final plannedCount = tripPlans.where((t) => t.status == TripStatus.planned).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: FontAwesomeIcons.checkCircle,
              count: completedCount,
              label: 'Hoàn thành',
              color: const Color(0xFF10B981),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: FontAwesomeIcons.locationArrow,
              count: ongoingCount,
              label: 'Đang thực hiện',
              color: const Color(0xFFF59E0B),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: FontAwesomeIcons.calendar,
              count: plannedCount,
              label: 'Kế hoạch',
              color: const Color(0xFF3B82F6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required int count,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filterOptions.length,
        itemBuilder: (context, index) {
          final filter = filterOptions[index];
          final isSelected = filter == selectedFilter;
          
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                selectedFilter = filter;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? ColorPalette.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? ColorPalette.primaryColor : Colors.grey[300]!,
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: ColorPalette.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }



  Widget _buildTripPlansList() {
    final trips = filteredTrips;
    
    if (trips.isEmpty) {
      return SliverToBoxAdapter(child: _buildEmptyState());
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final trip = trips[index];
          return AnimatedContainer(
            duration: Duration(milliseconds: 200 + (index * 100)),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildTripCard(trip),
          );
        },
        childCount: trips.length,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              FontAwesomeIcons.mapLocationDot,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Chưa có kế hoạch nào',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tạo kế hoạch đầu tiên để bắt đầu\nchuyến phiêu lưu của bạn',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _navigateToCreateTrip,
            icon: const Icon(FontAwesomeIcons.plus, size: 16),
            label: const Text('Tạo kế hoạch mới'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalette.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        HapticFeedback.mediumImpact();
        _navigateToCreateTrip();
      },
      backgroundColor: ColorPalette.primaryColor,
      icon: const Icon(FontAwesomeIcons.plus, color: Colors.white),
      label: const Text(
        'Tạo kế hoạch',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevation: 4,
    );
  }

  Widget _buildTripCard(TripPlan trip) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _navigateToTripDetail(trip);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Header
            _buildTripImageHeader(trip),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Status
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trip.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.locationDot,
                                  size: 14,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    trip.destination,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _buildStatusBadge(trip.status),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Trip Info Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildInfoChip(
                        FontAwesomeIcons.calendar,
                        trip.duration,
                        const Color(0xFF3B82F6),
                      ),
                      _buildInfoChip(
                        FontAwesomeIcons.users,
                        '${trip.travelers} người',
                        const Color(0xFF10B981),
                      ),
                      _buildInfoChip(
                        FontAwesomeIcons.coins,
                        _formatCurrency(trip.budget),
                        const Color(0xFFF59E0B),
                      ),
                    ],
                  ),
                  
                  // Progress Bar (for planned/ongoing trips)
                  if (trip.status != TripStatus.completed) ...[
                    const SizedBox(height: 16),
                    _buildProgressSection(trip),
                  ],
                  
                  const SizedBox(height: 16),
                  
                  // Action Buttons
                  _buildActionButtons(trip),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripImageHeader(TripPlan trip) {
    return Stack(
      children: [
        Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            image: DecorationImage(
              image: AssetImage(trip.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${trip.startDate} - ${trip.endDate}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: () => _showTripOptions(trip),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                FontAwesomeIcons.ellipsisVertical,
                size: 16,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(TripStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case TripStatus.completed:
        color = const Color(0xFF10B981);
        text = 'Hoàn thành';
        icon = FontAwesomeIcons.check;
        break;
      case TripStatus.ongoing:
        color = const Color(0xFFF59E0B);
        text = 'Đang thực hiện';
        icon = FontAwesomeIcons.locationArrow;
        break;
      case TripStatus.planned:
        color = const Color(0xFF3B82F6);
        text = 'Kế hoạch';
        icon = FontAwesomeIcons.calendar;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(TripPlan trip) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tiến độ kế hoạch',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${(trip.progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: trip.status == TripStatus.ongoing
                    ? const Color(0xFFF59E0B)
                    : const Color(0xFF3B82F6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: trip.progress,
            child: Container(
              decoration: BoxDecoration(
                color: trip.status == TripStatus.ongoing
                    ? const Color(0xFFF59E0B)
                    : const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }





  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildActionButtons(TripPlan trip) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _navigateToTripDetail(trip),
            icon: const Icon(FontAwesomeIcons.eye, size: 16),
            label: const Text('Chi tiết'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF6B7280),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _handleTripAction(trip),
            icon: Icon(_getActionIcon(trip.status), size: 16),
            label: Text(_getActionText(trip.status)),
            style: ElevatedButton.styleFrom(
              backgroundColor: _getActionColor(trip.status),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }



  IconData _getActionIcon(TripStatus status) {
    switch (status) {
      case TripStatus.completed:
        return FontAwesomeIcons.repeat;
      case TripStatus.ongoing:
        return FontAwesomeIcons.play;
      case TripStatus.planned:
        return FontAwesomeIcons.edit;
    }
  }

  String _getActionText(TripStatus status) {
    switch (status) {
      case TripStatus.completed:
        return 'Lặp lại';
      case TripStatus.ongoing:
        return 'Tiếp tục';
      case TripStatus.planned:
        return 'Chỉnh sửa';
    }
  }

  Color _getActionColor(TripStatus status) {
    switch (status) {
      case TripStatus.completed:
        return const Color(0xFF10B981);
      case TripStatus.ongoing:
        return const Color(0xFFF59E0B);
      case TripStatus.planned:
        return ColorPalette.primaryColor;
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

  void _navigateToTripDetail(TripPlan trip) {
    // Create TripPlanData from TripPlan for compatibility
    final tripData = TripPlanData(
      destination: trip.destination,
      startDate: trip.startDate,
      endDate: trip.endDate,
      travelers: trip.travelers,
      budget: trip.budget,
    );
    
    Navigator.pushNamed(
      context,
      '/detailed_trip_plan_screen',
      arguments: tripData,
    );
  }

  void _navigateToCreateTrip() {
    Navigator.pushNamed(context, '/trip_creation_screen');
  }

  void _handleTripAction(TripPlan trip) {
    switch (trip.status) {
      case TripStatus.completed:
        _showRepeatTripDialog(trip);
        break;
      case TripStatus.ongoing:
        _navigateToTripDetail(trip);
        break;
      case TripStatus.planned:
        _navigateToEditTrip(trip);
        break;
    }
  }

  void _navigateToEditTrip(TripPlan trip) {
    // TODO: Navigate to edit trip screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chức năng chỉnh sửa đang phát triển')),
    );
  }

  void _showRepeatTripDialog(TripPlan trip) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Lặp lại chuyến đi'),
          content: Text('Bạn có muốn tạo kế hoạch mới dựa trên "${trip.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _navigateToCreateTrip();
              },
              child: const Text('Tạo mới'),
            ),
          ],
        );
      },
    );
  }

  void _showTripOptions(TripPlan trip) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(kMediumPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                trip.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(FontAwesomeIcons.eye, color: Colors.blue),
                title: const Text('Xem chi tiết'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToTripDetail(trip);
                },
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.edit, color: Colors.orange),
                title: const Text('Chỉnh sửa'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToEditTrip(trip);
                },
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.share, color: Colors.green),
                title: const Text('Chia sẻ'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chức năng chia sẻ đang phát triển')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.trash, color: Colors.red),
                title: const Text('Xóa'),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmDialog(trip);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmDialog(TripPlan trip) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xóa kế hoạch'),
          content: Text('Bạn có chắc chắn muốn xóa "${trip.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chức năng xóa đang phát triển')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Xóa', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

// Model classes
class TripPlan {
  final String id;
  final String title;
  final String destination;
  final String startDate;
  final String endDate;
  final String duration;
  final double budget;
  final int travelers;
  final TripStatus status;
  final String imageUrl;
  final int activities;
  final double progress;

  TripPlan({
    required this.id,
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.budget,
    required this.travelers,
    required this.status,
    required this.imageUrl,
    required this.activities,
    required this.progress,
  });
}

enum TripStatus {
  completed,
  ongoing,
  planned,
}