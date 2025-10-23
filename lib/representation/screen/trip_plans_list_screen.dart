import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/data/models/trip_plan_list_model.dart';
import 'package:flutter_travels_apps/data/mock/trip_plans_list_data_provider.dart';
import 'package:flutter_travels_apps/representation/widgets/trip_cards.dart';
import 'package:flutter_travels_apps/representation/widgets/trip_components.dart';
import 'package:flutter_travels_apps/providers/trip_helpers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';

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
  TripStatus? selectedStatus;
  List<TripPlan> tripPlans = [];
  
  @override
  void initState() {
    super.initState();
  tripPlans = TripPlansListDataProvider.getSampleTripPlans();
    
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

  List<TripPlan> get filteredTrips {
    if (selectedStatus == null) {
  return tripPlans;
    }
  return tripPlans.where((trip) => trip.status == selectedStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: AppBarContainerWidget(
        titleString: 'Kế Hoạch Chuyến Đi',
        implementLeading: true,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: _buildTripPlansListWithHeader(),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildTripPlansListWithHeader() {
    final trips = filteredTrips;
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        TripQuickStats(
          trips: tripPlans,
          onViewAll: () {},
        ),
        const SizedBox(height: 20),
        TripFilterChips(
          selectedStatus: selectedStatus,
          onFilterChanged: (status) {
            setState(() {
              selectedStatus = status;
              selectedFilter = status?.displayText ?? 'Tất cả';
            });
          },
        ),
        const SizedBox(height: 16),
        if (trips.isEmpty)
          Container(
            alignment: Alignment.center,
            height: 200,
            child: TripEmptyState(
              onButtonPressed: _navigateToCreateTrip,
            ),
          )
        else ...trips.asMap().entries.map((entry) {
          final index = entry.key;
          final trip = entry.value;
          return AnimatedContainer(
            duration: Duration(milliseconds: 200 + (index * 100)),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TripPlanCard(
              trip: trip,
              onTap: () => _navigateToTripDetail(trip),
              onMenuTap: () => _showTripOptions(trip),
              onActionTap: () => _handleTripAction(trip),
            ),
          );
        }).toList(),
      ],
    );
  }

  // ...existing code...

  // ...existing code...

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

  void _navigateToTripDetail(TripPlan trip) {
  final tripData = trip.toTripPlanData();
    Navigator.pushNamed(
      context,
      '/detailed_trip_plan_screen',
      arguments: tripData,
    );
  }

  void _navigateToCreateTrip() {
    Navigator.pushNamed(
      context, 
      '/trip_creation_screen',
      arguments: {'fromTripList': true},
    );
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
    TripActionsHelper.showNotImplementedSnackBar(context, 'chỉnh sửa');
  }

  void _showRepeatTripDialog(TripPlan trip) {
  TripActionsHelper.showRepeatTripDialog(context, trip, () {
      _navigateToCreateTrip();
    });
  }

  void _showTripOptions(TripPlan trip) {
    TripActionsHelper.showTripOptions(
      context,
      trip,
      onViewDetail: () => _navigateToTripDetail(trip),
      onEdit: () => _navigateToEditTrip(trip),
      onShare: () => TripActionsHelper.showNotImplementedSnackBar(context, 'chia sẻ'),
      onDelete: () => _showDeleteConfirmDialog(trip),
    );
  }

  void _showDeleteConfirmDialog(TripPlan trip) {
  TripActionsHelper.showDeleteConfirmDialog(context, trip, () {
      TripActionsHelper.showNotImplementedSnackBar(context, 'xóa');
    });
  }
}