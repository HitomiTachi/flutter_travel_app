import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_travels_apps/data/models/trip_plan_list_model.dart';
import 'package:flutter_travels_apps/providers/trip_helpers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ============================================================================
// MAIN TRIP CARD COMPONENTS
// ============================================================================
class TripPlanCard extends StatelessWidget {
  final TripPlan trip;
  final VoidCallback onTap;
  final VoidCallback onMenuTap;
  final VoidCallback onActionTap;

  const TripPlanCard({
    super.key,
    required this.trip,
    required this.onTap,
    required this.onMenuTap,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
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
            _buildTripImageHeader(),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Menu
                  _buildTitleRow(),
                  const SizedBox(height: 12),
                  
                  // Status & Progress
                  _buildStatusAndProgress(),
                  const SizedBox(height: 16),
                  
                  // Trip Info
                  _buildTripInfo(),
                  const SizedBox(height: 16),
                  
                  // Action Button
                  _buildActionButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripImageHeader() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.3),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              image: DecorationImage(
                image: NetworkImage(trip.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                ],
              ),
            ),
          ),
          
          // Content on image
          Positioned(
            bottom: 16,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip.destination,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  trip.title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trip.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.locationDot,
                    size: 12,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      trip.destination,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onMenuTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              FontAwesomeIcons.ellipsisVertical,
              size: 16,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusAndProgress() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getStatusIcon(),
                    size: 12,
                    color: _getStatusColor(),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    trip.status.displayText,
                    style: TextStyle(
                      fontSize: 12,
                      color: _getStatusColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${(trip.progress * 100).toInt()}% hoàn thành',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: trip.progress,
          backgroundColor: Colors.grey.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor()),
          minHeight: 4,
        ),
      ],
    );
  }

  Widget _buildTripInfo() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoItem(
            FontAwesomeIcons.calendar,
            trip.duration,
            Colors.blue,
          ),
        ),
        Expanded(
          child: _buildInfoItem(
            FontAwesomeIcons.users,
            '${trip.travelers} người',
            Colors.green,
          ),
        ),
        Expanded(
          child: _buildInfoItem(
            FontAwesomeIcons.dollarSign,
            TripFormatHelpers.formatCurrency(trip.budget),
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 12,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    String buttonText;
    Color buttonColor;
    IconData buttonIcon;

    switch (trip.status) {
      case TripStatus.planned:
        buttonText = 'Bắt đầu chuyến đi';
        buttonColor = Colors.blue;
        buttonIcon = FontAwesomeIcons.play;
        break;
      case TripStatus.ongoing:
        buttonText = 'Tiếp tục chuyến đi';
        buttonColor = Colors.orange;
        buttonIcon = FontAwesomeIcons.locationArrow;
        break;
      case TripStatus.completed:
        buttonText = 'Xem lại chuyến đi';
        buttonColor = Colors.green;
        buttonIcon = FontAwesomeIcons.eye;
        break;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onActionTap,
        icon: Icon(buttonIcon, size: 16),
        label: Text(buttonText),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (trip.status) {
      case TripStatus.completed:
        return const Color(0xFF10B981);
      case TripStatus.ongoing:
        return const Color(0xFFF59E0B);
      case TripStatus.planned:
        return const Color(0xFF3B82F6);
    }
  }

  IconData _getStatusIcon() {
    switch (trip.status) {
      case TripStatus.completed:
        return FontAwesomeIcons.check;
      case TripStatus.ongoing:
        return FontAwesomeIcons.locationArrow;
      case TripStatus.planned:
        return FontAwesomeIcons.calendar;
    }
  }

  // Đã dùng TripFormatHelpers cho formatCurrency, không cần hàm này nữa
}

// ============================================================================
// STATISTICS CARD
// ============================================================================
class TripStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const TripStatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}