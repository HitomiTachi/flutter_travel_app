import 'package:flutter_travels_apps/data/models/notification_model.dart';

class NotificationDataProvider {
  // Mock data cho thông báo
  static List<NotificationModel> getMockNotifications() {
    final now = DateTime.now();
    
    return [
      NotificationModel(
        id: '1',
        title: 'Top 10 địa điểm check-in hot nhất Đà Lạt 2025',
        message: 'Khám phá những góc sống ảo mới toanh tại thành phố ngàn hoa. Từ đồi chè Cầu Đất đến làng cù lần, mỗi nơi đều có câu chuyện riêng.',
        type: NotificationType.promotion,
        timestamp: now.subtract(Duration(minutes: 30)),
        isRead: false,
        actionUrl: '/blog/dalat-checkin',
        metadata: {'category': 'travel_tips'},
      ),
      NotificationModel(
        id: '2',
        title: 'Bí quyết săn vé máy bay giá rẻ mùa cao điểm',
        message: 'Chia sẻ kinh nghiệm đặt vé sớm, theo dõi flash sale và những thủ thuật giúp bạn tiết kiệm đến 50% chi phí bay.',
        type: NotificationType.system,
        timestamp: now.subtract(Duration(hours: 2)),
        isRead: false,
        actionUrl: '/blog/cheap-flights',
        metadata: {'category': 'budget_tips'},
      ),
      NotificationModel(
        id: '3',
        title: 'Hành trình khám phá ẩm thực đường phố Sài Gòn',
        message: 'Từ bánh mì Huỳnh Hoa đến bún riêu cô Giang, cùng thưởng thức những món ăn đặc trưng làm nên thương hiệu ẩm thực Sài Gòn.',
        type: NotificationType.promotion,
        timestamp: now.subtract(Duration(hours: 5)),
        isRead: false,
        actionUrl: '/blog/saigon-food',
      ),
      NotificationModel(
        id: '4',
        title: 'Kinh nghiệm du lịch bụi Đông Nam Á 1 tháng',
        message: 'Review chi tiết lộ trình Việt Nam - Campuchia - Thái Lan - Lào với budget chỉ 15 triệu cho 30 ngày khám phá.',
        type: NotificationType.trip,
        timestamp: now.subtract(Duration(days: 1)),
        isRead: true,
        actionUrl: '/blog/southeast-asia',
        metadata: {'category': 'travel_guide'},
      ),
      NotificationModel(
        id: '5',
        title: 'Checklist chuẩn bị hành lý cho chuyến đi biển',
        message: 'Danh sách đầy đủ những món đồ cần thiết: từ kem chống nắng, túi chống nước đến phụ kiện chụp ảnh không thể thiếu.',
        type: NotificationType.like,
        timestamp: now.subtract(Duration(days: 1)),
        isRead: true,
        actionUrl: '/blog/beach-packing',
        metadata: {'category': 'travel_tips'},
      ),
      NotificationModel(
        id: '6',
        title: 'Những homestay view núi tuyệt đẹp ở Sapa',
        message: 'Tổng hợp top 15 homestay có view ruộng bậc thang đẹp nhất, giá từ 200k-500k/người/đêm, phục vụ ăn uống cực ngon.',
        type: NotificationType.booking,
        timestamp: now.subtract(Duration(days: 2)),
        isRead: true,
        actionUrl: '/blog/sapa-homestay',
      ),
      NotificationModel(
        id: '7',
        title: 'Cẩm nang chinh phục đỉnh Fansipan cho người mới',
        message: 'Hướng dẫn chi tiết về trang phục, thể lực cần chuẩn bị, lộ trình leo núi và những lưu ý quan trọng khi chinh phục nóc nhà Đông Dương.',
        type: NotificationType.trip,
        timestamp: now.subtract(Duration(days: 3)),
        isRead: true,
        actionUrl: '/blog/fansipan-guide',
        metadata: {'category': 'adventure'},
      ),
      NotificationModel(
        id: '8',
        title: 'Phá đảo Phú Quốc chỉ với 5 triệu đồng',
        message: 'Lịch trình 4 ngày 3 đêm tiết kiệm nhưng vẫn trải nghiệm đầy đủ: lặn ngắm san hô, check-in cáp treo, thưởng thức hải sản tươi ngon.',
        type: NotificationType.promotion,
        timestamp: now.subtract(Duration(days: 5)),
        isRead: true,
        actionUrl: '/blog/phuquoc-budget',
      ),
      NotificationModel(
        id: '9',
        title: 'Review chi tiết resort 5 sao Đà Nẵng',
        message: 'Trải nghiệm thực tế tại các resort view biển đẳng cấp: phòng ốc, dịch vụ, buffet sáng và những tiện ích đáng giá đồng tiền.',
        type: NotificationType.review,
        timestamp: now.subtract(Duration(days: 7)),
        isRead: true,
        actionUrl: '/blog/danang-resort',
      ),
      NotificationModel(
        id: '10',
        title: 'Bí mật về văn hóa và phong tục người dân tộc miền núi',
        message: 'Tìm hiểu về lễ hội, trang phục truyền thống và những điều thú vị khi đến thăm các bản làng H\'Mông, Dao, Tày ở Tây Bắc Việt Nam.',
        type: NotificationType.like,
        timestamp: now.subtract(Duration(days: 8)),
        isRead: true,
        actionUrl: '/blog/highland-culture',
        metadata: {'category': 'culture'},
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
