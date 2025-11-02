import 'package:flutter_travels_apps/data/models/notification_model.dart';

class NotificationDataProvider {
  // Mock data cho thông báo
  static List<NotificationModel> getMockNotifications() {
    final now = DateTime.now();
    
    return [
      NotificationModel(
        id: '1',
        title: 'Chuyến đi sắp bắt đầu!',
        message: 'Chuyến đi "Khám phá Đà Lạt" của bạn sẽ bắt đầu vào ngày mai. Đừng quên chuẩn bị hành lý nhé!',
        type: NotificationType.trip,
        timestamp: now.subtract(Duration(minutes: 30)),
        isRead: false,
        imageUrl: 'assets/images/dalat.jpeg',
        actionUrl: '/trip_detail',
        metadata: {'tripId': 'trip_001'},
      ),
      NotificationModel(
        id: '2',
        title: 'Đặt phòng thành công',
        message: 'Bạn đã đặt thành công 1 phòng tại Sapa Charm Hotel. Mã đặt phòng: #BK12345',
        type: NotificationType.booking,
        timestamp: now.subtract(Duration(hours: 2)),
        isRead: false,
        imageUrl: 'assets/images/sapa.jpeg',
        actionUrl: '/booking_detail',
        metadata: {'bookingId': 'BK12345'},
      ),
      NotificationModel(
        id: '3',
        title: '🎉 Khuyến mãi đặc biệt!',
        message: 'Giảm 30% cho tất cả các tour du lịch trong tháng này. Đừng bỏ lỡ cơ hội!',
        type: NotificationType.promotion,
        timestamp: now.subtract(Duration(hours: 5)),
        isRead: false,
        imageUrl: 'assets/images/halong.jpeg',
        actionUrl: '/promotions',
      ),
      NotificationModel(
        id: '4',
        title: 'Đánh giá mới',
        message: 'Nguyễn Văn A đã đánh giá 5 sao cho chuyến đi của bạn. Xem ngay!',
        type: NotificationType.review,
        timestamp: now.subtract(Duration(days: 1)),
        isRead: true,
        actionUrl: '/reviews',
        metadata: {'reviewId': 'rev_001'},
      ),
      NotificationModel(
        id: '5',
        title: 'Lượt thích mới',
        message: '10 người đã thích bài viết "Khám phá ẩm thực Hội An" của bạn',
        type: NotificationType.like,
        timestamp: now.subtract(Duration(days: 1)),
        isRead: true,
        actionUrl: '/article_detail',
        metadata: {'articleId': 'art_001'},
      ),
      NotificationModel(
        id: '6',
        title: 'Cập nhật hệ thống',
        message: 'Phiên bản mới v2.0 đã có sẵn với nhiều tính năng hấp dẫn. Cập nhật ngay!',
        type: NotificationType.system,
        timestamp: now.subtract(Duration(days: 2)),
        isRead: true,
        actionUrl: '/update',
      ),
      NotificationModel(
        id: '7',
        title: 'Nhắc nhở thanh toán',
        message: 'Bạn có 1 hóa đơn chưa thanh toán cho chuyến đi "Phú Quốc 3N2Đ". Hạn thanh toán: 20/11/2025',
        type: NotificationType.booking,
        timestamp: now.subtract(Duration(days: 3)),
        isRead: true,
        imageUrl: 'assets/images/phuquoc.jpeg',
        actionUrl: '/payment',
        metadata: {'invoiceId': 'inv_001'},
      ),
      NotificationModel(
        id: '8',
        title: 'Chúc mừng!',
        message: 'Bạn đã hoàn thành 10 chuyến đi. Nhận ngay phiếu giảm giá 200.000đ cho chuyến đi tiếp theo!',
        type: NotificationType.system,
        timestamp: now.subtract(Duration(days: 5)),
        isRead: true,
        actionUrl: '/rewards',
      ),
      NotificationModel(
        id: '9',
        title: 'Địa điểm mới',
        message: 'Đà Nẵng vừa được thêm vào danh sách yêu thích của bạn',
        type: NotificationType.like,
        timestamp: now.subtract(Duration(days: 7)),
        isRead: true,
        imageUrl: 'assets/images/danang.jpeg',
      ),
      NotificationModel(
        id: '10',
        title: 'Lời nhắc',
        message: 'Đừng quên đánh giá chuyến đi "Nha Trang 4N3Đ" để giúp người khác có trải nghiệm tốt hơn!',
        type: NotificationType.review,
        timestamp: now.subtract(Duration(days: 8)),
        isRead: true,
        actionUrl: '/write_review',
        metadata: {'tripId': 'trip_002'},
      ),
    ];
  }

  // Filter notifications by read status
  static List<NotificationModel> getUnreadNotifications() {
    return getMockNotifications().where((n) => !n.isRead).toList();
  }

  static List<NotificationModel> getReadNotifications() {
    return getMockNotifications().where((n) => n.isRead).toList();
  }

  // Get notification count
  static int getUnreadCount() {
    return getUnreadNotifications().length;
  }

  // Group notifications by date
  static Map<String, List<NotificationModel>> groupByDate(List<NotificationModel> notifications) {
    final Map<String, List<NotificationModel>> grouped = {};
    final now = DateTime.now();
    
    for (var notification in notifications) {
      final difference = now.difference(notification.timestamp);
      String key;
      
      if (difference.inDays == 0) {
        key = 'Hôm nay';
      } else if (difference.inDays == 1) {
        key = 'Hôm qua';
      } else if (difference.inDays < 7) {
        key = '${difference.inDays} ngày trước';
      } else {
        key = 'Cũ hơn';
      }
      
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(notification);
    }
    
    return grouped;
  }
}
