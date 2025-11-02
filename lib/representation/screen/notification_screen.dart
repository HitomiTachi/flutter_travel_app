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
  List<NotificationModel> _allNotifications = [];
  int _unreadCount = 0;
  
  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() {
      _allNotifications = NotificationDataProvider.getMockNotifications();
      _unreadCount = _allNotifications.where((n) => !n.isRead).length;
    });
  }

  void _markAsRead(NotificationModel notification) {
    setState(() {
      final index = _allNotifications.indexWhere((n) => n.id == notification.id);
      if (index != -1) {
        _allNotifications[index] = notification.copyWith(isRead: true);
        _loadNotifications();
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      _allNotifications = _allNotifications.map((n) => n.copyWith(isRead: true)).toList();
      _loadNotifications();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã đánh dấu tất cả là đã đọc'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: ColorPalette.primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteNotification(NotificationModel notification) {
    setState(() {
      _allNotifications.removeWhere((n) => n.id == notification.id);
      _loadNotifications();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa thông báo'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red.shade400,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Thông báo',
      implementLeading: true,
      child: Column(
        children: [
          // Nút đánh dấu tất cả đã đọc
          if (_unreadCount > 0)
            Padding(
              padding: EdgeInsets.fromLTRB(kDefaultPadding, kMediumPadding, kDefaultPadding, kTopPadding),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: _markAllAsRead,
                    icon: Icon(
                      FontAwesomeIcons.checkDouble,
                      size: 12,
                      color: ColorPalette.primaryColor,
                    ),
                    label: Text(
                      'Đánh dấu tất cả đã đọc',
                      style: TextStyles.defaultStyle.copyWith(
                        fontSize: 12,
                        color: ColorPalette.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: ColorPalette.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$_unreadCount chưa đọc',
                      style: TextStyles.defaultStyle.copyWith(
                        fontSize: 12,
                        color: ColorPalette.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Danh sách thông báo
          Expanded(
            child: _buildNotificationList(_allNotifications),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationModel> notifications) {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    final grouped = NotificationDataProvider.groupByDate(notifications);
    
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kTopPadding),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final key = grouped.keys.elementAt(index);
        final items = grouped[key]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header ngày tháng
            Padding(
              padding: EdgeInsets.only(left: 4, bottom: kTopPadding, top: index == 0 ? 0 : kMediumPadding),
              child: Text(
                key,
                style: TextStyles.defaultStyle.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: ColorPalette.subTitleColor,
                ),
              ),
            ),
            
            // Các thông báo
            ...items.map((notification) => _buildNotificationCard(notification)).toList(),
          ],
        );
      },
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteNotification(notification),
      background: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(kItemPadding),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: kMediumPadding),
        child: Icon(
          FontAwesomeIcons.trash,
          color: Colors.white,
          size: 18,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          if (!notification.isRead) {
            _markAsRead(notification);
          }
          // TODO: Điều hướng đến chi tiết
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Mở: ${notification.actionUrl ?? "N/A"}'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(14),
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
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: ColorPalette.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
              
              SizedBox(height: 6),
              
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
              
              SizedBox(height: 10),
              
              // Thời gian
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.clock,
                    size: 11,
                    color: ColorPalette.subTitleColor.withOpacity(0.7),
                  ),
                  SizedBox(width: 5),
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

  Widget _buildEmptyState() {
    return Center(
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
