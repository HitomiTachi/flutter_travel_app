import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  static const String routeName = '/notifications_screen';

  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> _notifications = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() {
      _isLoading = true;
    });

    // Mock data - trong thực tế sẽ load từ API hoặc local storage
    _notifications = [
      NotificationItem(
        id: '1',
        title: 'Chuyến đi sắp tới',
        message:
            'Chuyến đi đến Hạ Long Bay của bạn sẽ bắt đầu trong 3 ngày nữa',
        type: NotificationType.trip,
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        icon: FontAwesomeIcons.calendarCheck,
        color: Colors.blue,
      ),
      NotificationItem(
        id: '2',
        title: 'Đề xuất địa điểm',
        message:
            'Chúng tôi tìm thấy một số địa điểm phù hợp với sở thích của bạn',
        type: NotificationType.recommendation,
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        icon: FontAwesomeIcons.bell,
        color: Colors.green,
      ),
      NotificationItem(
        id: '3',
        title: 'Ưu đãi đặc biệt',
        message: 'Giảm 20% cho đặt phòng khách sạn tại Đà Lạt trong tháng này',
        type: NotificationType.promotion,
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        icon: FontAwesomeIcons.tag,
        color: Colors.orange,
      ),
      NotificationItem(
        id: '4',
        title: 'Nhắc nhở checklist',
        message: 'Đừng quên kiểm tra checklist trước khi đi nhé!',
        type: NotificationType.reminder,
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        icon: FontAwesomeIcons.listCheck,
        color: Colors.purple,
      ),
      NotificationItem(
        id: '5',
        title: 'Thời tiết tại điểm đến',
        message:
            'Dự báo thời tiết tại Phú Quốc: Nắng đẹp, 28°C trong 7 ngày tới',
        type: NotificationType.weather,
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        icon: FontAwesomeIcons.cloudSun,
        color: Colors.lightBlue,
      ),
    ];

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();
    });
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((n) => n.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Đã xóa thông báo'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Thông Báo',
      implementLeading: true,
      child: Column(
        children: [
          const SizedBox(height: kMediumPadding),
          // Header với mark all as read
          if (_notifications.isNotEmpty) _buildHeader(),
          const SizedBox(height: kMediumPadding),
          // Notifications list
          Expanded(child: _buildNotificationsList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: kMediumPadding,
        vertical: kDefaultPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$_unreadCount thông báo chưa đọc',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Đánh dấu tất cả đã đọc',
                style: TextStyle(
                  color: ColorPalette.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.bellSlash, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Chưa có thông báo nào',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Các thông báo mới sẽ xuất hiện ở đây',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    final isUnread = !notification.isRead;

    return Dismissible(
      key: Key(notification.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteNotification(notification.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isUnread
              ? Border.all(
                  color: ColorPalette.primaryColor.withOpacity(0.3),
                  width: 2,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _markAsRead(notification.id),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: notification.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      notification.icon,
                      color: notification.color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isUnread
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            if (isUnread)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: ColorPalette.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.message,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatTime(notification.createdAt),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Action button
                  IconButton(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onPressed: () => _showNotificationOptions(notification),
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Vừa xong';
        }
        return '${difference.inMinutes} phút trước';
      }
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays == 1) {
      return 'Hôm qua';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  void _showNotificationOptions(NotificationItem notification) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(kMediumPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  notification.isRead
                      ? FontAwesomeIcons.envelope
                      : FontAwesomeIcons.envelopeOpen,
                  color: ColorPalette.primaryColor,
                ),
                title: Text(
                  notification.isRead ? 'Đánh dấu chưa đọc' : 'Đánh dấu đã đọc',
                ),
                onTap: () {
                  Navigator.pop(context);
                  _markAsRead(notification.id);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Xóa thông báo',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _deleteNotification(notification.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

enum NotificationType { trip, recommendation, promotion, reminder, weather }

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final IconData icon;
  final Color color;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.icon,
    required this.color,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    bool? isRead,
    DateTime? createdAt,
    IconData? icon,
    Color? color,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }
}
