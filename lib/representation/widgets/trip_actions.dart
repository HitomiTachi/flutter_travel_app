import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/data/models/trip_plan.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ============================================================================
// TRIP ACTIONS & DIALOGS
// ============================================================================
class TripActionsHelper {
  /// Hiển thị bottom sheet với các tùy chọn cho trip
  static void showTripOptions(
    BuildContext context,
    TripPlan trip, {
    required VoidCallback onViewDetail,
    required VoidCallback onEdit,
    required VoidCallback onShare,
    required VoidCallback onDelete,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
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
                  onViewDetail();
                },
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.penToSquare, color: Colors.orange),
                title: const Text('Chỉnh sửa'),
                onTap: () {
                  Navigator.pop(context);
                  onEdit();
                },
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.share, color: Colors.green),
                title: const Text('Chia sẻ'),
                onTap: () {
                  Navigator.pop(context);
                  onShare();
                },
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.trash, color: Colors.red),
                title: const Text('Xóa'),
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Hiển thị dialog xác nhận xóa trip
  static void showDeleteConfirmDialog(
    BuildContext context,
    TripPlan trip,
    VoidCallback onConfirm,
  ) {
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
                onConfirm();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Xóa', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  /// Hiển thị dialog xác nhận lặp lại trip
  static void showRepeatTripDialog(
    BuildContext context,
    TripPlan trip,
    VoidCallback onConfirm,
  ) {
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
                onConfirm();
              },
              child: const Text('Tạo mới'),
            ),
          ],
        );
      },
    );
  }

  /// Hiển thị snackbar cho các chức năng chưa implement
  static void showNotImplementedSnackBar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Chức năng $feature đang phát triển'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ============================================================================
// TRIP FORMATTING UTILITIES
// ============================================================================
class TripFormatHelpers {
  /// Format currency theo định dạng Việt Nam
  static String formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M VNĐ';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K VNĐ';
    }
    return '${amount.toStringAsFixed(0)} VNĐ';
  }

  /// Format progress percentage
  static String formatProgress(double progress) {
    return '${(progress * 100).toInt()}%';
  }

  /// Get status display text
  static String getStatusText(TripStatus status) {
    return status.displayText;
  }

  /// Get status color
  static Color getStatusColor(TripStatus status) {
    switch (status) {
      case TripStatus.completed:
        return const Color(0xFF10B981);
      case TripStatus.ongoing:
        return const Color(0xFFF59E0B);
      case TripStatus.planned:
        return const Color(0xFF3B82F6);
    }
  }

  /// Get status icon
  static IconData getStatusIcon(TripStatus status) {
    switch (status) {
      case TripStatus.completed:
        return FontAwesomeIcons.check;
      case TripStatus.ongoing:
        return FontAwesomeIcons.locationArrow;
      case TripStatus.planned:
        return FontAwesomeIcons.calendar;
    }
  }
}

// ============================================================================
// TRIP VALIDATION UTILITIES
// ============================================================================
class TripValidationHelpers {
  /// Kiểm tra trip có hợp lệ không
  static bool isValidTrip(TripPlan trip) {
    return trip.title.isNotEmpty &&
           trip.destination.isNotEmpty &&
           trip.budget > 0 &&
           trip.travelers > 0;
  }

  /// Kiểm tra có thể edit trip không
  static bool canEditTrip(TripPlan trip) {
    return trip.status != TripStatus.completed;
  }

  /// Kiểm tra có thể delete trip không
  static bool canDeleteTrip(TripPlan trip) {
    return true; // Có thể xóa tất cả trips
  }

  /// Kiểm tra có cần hiển thị progress không
  static bool shouldShowProgress(TripPlan trip) {
    return trip.status != TripStatus.completed;
  }
}