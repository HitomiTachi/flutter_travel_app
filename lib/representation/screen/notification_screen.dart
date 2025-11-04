import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:flutter_travels_apps/data/models/notification_model.dart';
import 'package:flutter_travels_apps/data/mock/notification_data_provider.dart';
import 'package:flutter_travels_apps/representation/widgets/common/app_bar_container.dart';
import 'package:flutter_travels_apps/representation/widgets/common/empty_state_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationScreen extends StatefulWidget {
  static const String routeName = '/notification_screen';

  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late List<NotificationModel> _allNotifications;
  late int _unreadCount;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    _allNotifications = NotificationDataProvider.getMockNotifications();
    _unreadCount = _allNotifications.where((n) => !n.isRead).length;
  }

  void _markAsRead(NotificationModel notification) {
    final index = _allNotifications.indexWhere((n) => n.id == notification.id);
    if (index != -1) {
      setState(() {
        _allNotifications[index] = notification.copyWith(isRead: true);
        _unreadCount = _allNotifications.where((n) => !n.isRead).length;
      });
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (int i = 0; i < _allNotifications.length; i++) {
        if (!_allNotifications[i].isRead) {
          _allNotifications[i] = _allNotifications[i].copyWith(isRead: true);
        }
      }
      _unreadCount = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã đánh dấu tất cả là đã đọc'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: ColorPalette.primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteNotification(NotificationModel notification) {
    final index = _allNotifications.indexWhere((n) => n.id == notification.id);
    if (index != -1) {
      setState(() {
        _allNotifications.removeAt(index);
        if (!notification.isRead) _unreadCount--;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Đã xóa thông báo'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade400,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Thông báo',
      implementLeading: true,
      child: Column(
        children: [
          if (_unreadCount > 0)
            _ActionBar(
              unreadCount: _unreadCount,
              onMarkAllRead: _markAllAsRead,
            ),

          // Danh sách thông báo
          Expanded(child: _buildNotificationList(_allNotifications)),
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationModel> notifications) {
    if (notifications.isEmpty) {
      return const _EmptyStateWidget();
    }

    final grouped = NotificationDataProvider.groupByDate(notifications);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kTopPadding,
      ),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final key = grouped.keys.elementAt(index);
        final items = grouped[key]!;

        return _DateGroup(
          dateLabel: key,
          notifications: items,
          isFirstGroup: index == 0,
          onMarkAsRead: _markAsRead,
          onDelete: _deleteNotification,
        );
      },
    );
  }
}

class _ActionBar extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onMarkAllRead;

  const _ActionBar({required this.unreadCount, required this.onMarkAllRead});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        kDefaultPadding,
        kMediumPadding,
        kDefaultPadding,
        kTopPadding,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: ColorPalette.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(kItemPadding),
        border: Border.all(
          color: ColorPalette.primaryColor.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            FontAwesomeIcons.bell,
            size: 14,
            color: ColorPalette.primaryColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Bạn có $unreadCount thông báo chưa đọc',
              style: TextStyles.defaultStyle.copyWith(
                fontSize: 13,
                color: ColorPalette.textColor,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onMarkAllRead,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: ColorPalette.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    FontAwesomeIcons.checkDouble,
                    size: 11,
                    color: Colors.white,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Đánh dấu đã đọc',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateGroup extends StatelessWidget {
  final String dateLabel;
  final List<NotificationModel> notifications;
  final bool isFirstGroup;
  final Function(NotificationModel) onMarkAsRead;
  final Function(NotificationModel) onDelete;

  const _DateGroup({
    required this.dateLabel,
    required this.notifications,
    required this.isFirstGroup,
    required this.onMarkAsRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header ngày tháng
        Padding(
          padding: EdgeInsets.only(
            left: 4,
            bottom: kTopPadding,
            top: isFirstGroup ? 0 : kMediumPadding,
          ),
          child: Text(
            dateLabel,
            style: TextStyles.defaultStyle.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: ColorPalette.subTitleColor,
            ),
          ),
        ),

        // ✅ TỐI ƯU: Dùng ListView.builder thay vì map
        ...notifications.map(
          (notification) => _NotificationCard(
            notification: notification,
            onMarkAsRead: () => onMarkAsRead(notification),
            onDelete: () => onDelete(notification),
          ),
        ),
      ],
    );
  }
}

/// ✅ TỐI ƯU: Extract notification card widget
class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onMarkAsRead;
  final VoidCallback onDelete;

  const _NotificationCard({
    required this.notification,
    required this.onMarkAsRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(kItemPadding),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: kMediumPadding),
        child: const Icon(
          FontAwesomeIcons.trash,
          color: Colors.white,
          size: 18,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          if (!notification.isRead) {
            onMarkAsRead();
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Mở: ${notification.actionUrl ?? "N/A"}'),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(kItemPadding),
            border: Border.all(
              color: notification.isRead
                  ? Colors.black.withOpacity(0.03)
                  : ColorPalette.primaryColor.withOpacity(0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: notification.isRead
                    ? Colors.black.withOpacity(0.02)
                    : ColorPalette.primaryColor.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title với badge chưa đọc
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      notification.title,
                      style: TextStyles.defaultStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!notification.isRead) ...[
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: ColorPalette.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 6),

              // Message
              Text(
                notification.message,
                style: TextStyles.defaultStyle.copyWith(
                  fontSize: 13,
                  color: ColorPalette.subTitleColor,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 10),

              // Thời gian
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.clock,
                    size: 11,
                    color: ColorPalette.subTitleColor.withOpacity(0.7),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    notification.timeAgo,
                    style: TextStyles.defaultStyle.copyWith(
                      fontSize: 12,
                      color: ColorPalette.subTitleColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(kDefaultPadding),
        child: EmptyStateWidget(
          icon: FontAwesomeIcons.bellSlash,
          title: 'Không có thông báo',
          subtitle: 'Bạn chưa có thông báo nào',
          iconSize: 50,
        ),
      ),
    );
  }
}
