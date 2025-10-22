import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/data/models/trip_plan.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ============================================================================
// QUICK STATS WIDGET
// ============================================================================
class TripQuickStats extends StatelessWidget {
  final List<TripPlan> trips;
  final VoidCallback? onViewAll;

  const TripQuickStats({
    Key? key,
    required this.trips,
    this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final completedTrips = trips.where((trip) => trip.status == TripStatus.completed).length;
    final ongoingTrips = trips.where((trip) => trip.status == TripStatus.ongoing).length;
    final plannedTrips = trips.where((trip) => trip.status == TripStatus.planned).length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade50,
            Colors.indigo.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng quan chuyến đi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (onViewAll != null)
                GestureDetector(
                  onTap: onViewAll,
                  child: const Text(
                    'Xem tất cả',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Hoàn thành',
                  completedTrips.toString(),
                  FontAwesomeIcons.check,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'Đang thực hiện',
                  ongoingTrips.toString(),
                  FontAwesomeIcons.locationArrow,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'Kế hoạch',
                  plannedTrips.toString(),
                  FontAwesomeIcons.calendar,
                  Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// FILTER CHIPS WIDGET
// ============================================================================
class TripFilterChips extends StatelessWidget {
  final TripStatus? selectedStatus;
  final Function(TripStatus?) onFilterChanged;

  const TripFilterChips({
    Key? key,
    required this.selectedStatus,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 20),
          _buildFilterChip(
            label: 'Tất cả',
            isSelected: selectedStatus == null,
            onTap: () => onFilterChanged(null),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Kế hoạch',
            isSelected: selectedStatus == TripStatus.planned,
            onTap: () => onFilterChanged(TripStatus.planned),
            color: Colors.blue,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Đang thực hiện',
            isSelected: selectedStatus == TripStatus.ongoing,
            onTap: () => onFilterChanged(TripStatus.ongoing),
            color: Colors.orange,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Hoàn thành',
            isSelected: selectedStatus == TripStatus.completed,
            onTap: () => onFilterChanged(TripStatus.completed),
            color: Colors.green,
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
            ? (color ?? Colors.blue)
            : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
              ? (color ?? Colors.blue)
              : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected 
              ? Colors.white
              : Colors.black87,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// EMPTY STATE WIDGET
// ============================================================================
class TripEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const TripEmptyState({
    Key? key,
    this.title = 'Chưa có chuyến đi nào',
    this.subtitle = 'Hãy tạo chuyến đi đầu tiên của bạn để bắt đầu khám phá thế giới!',
    this.buttonText = 'Tạo chuyến đi mới',
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              FontAwesomeIcons.mapLocationDot,
              size: 48,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onButtonPressed,
              icon: const Icon(FontAwesomeIcons.plus, size: 16),
              label: Text(buttonText),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
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
}