import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:flutter_travels_apps/data/models/notification_model.dart';
import 'package:flutter_travels_apps/data/mock/notification_data_provider.dart';
import 'package:flutter_travels_apps/representation/widgets/common/app_bar_container.dart';
import 'package:flutter_travels_apps/representation/widgets/common/empty_state_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_travels_apps/core/helpers/images_helpers.dart';

class NotificationScreen extends StatefulWidget {
  static const String routeName = '/notification_screen';
  
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<NotificationModel> _allNotifications = [];
  List<NotificationModel> _unreadNotifications = [];
  List<NotificationModel> _readNotifications = [];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadNotifications() {
    setState(() {
      _allNotifications = NotificationDataProvider.getMockNotifications();
      _unreadNotifications = NotificationDataProvider.getUnreadNotifications();
      _readNotifications = NotificationDataProvider.getReadNotifications();
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
          // Tab bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kMediumPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(kItemPadding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: ColorPalette.primaryColor,
              labelStyle: TextStyles.defaultStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyles.defaultStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              indicator: BoxDecoration(
                color: ColorPalette.primaryColor,
                borderRadius: BorderRadius.circular(kTopPadding),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Chưa đọc'),
                      if (_unreadNotifications.isNotEmpty) ...[
                        SizedBox(width: kMinPadding),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: kTopPadding,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: ColorPalette.yellowColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_unreadNotifications.length}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Tab(text: 'Đã đọc'),
              ],
            ),
          ),

          // Mark all as read button
          if (_unreadNotifications.isNotEmpty && _tabController.index == 0)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _markAllAsRead,
                  icon: Icon(
                    FontAwesomeIcons.checkDouble,
                    size: 14,
                    color: ColorPalette.primaryColor,
                  ),
                  label: Text(
                    'Đánh dấu tất cả đã đọc',
                    style: TextStyles.defaultStyle.copyWith(
                      color: ColorPalette.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),

          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Unread notifications
                _buildNotificationList(_unreadNotifications),
                
                // Read notifications
                _buildNotificationList(_readNotifications),
              ],
            ),
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
            // Date header
            Padding(
              padding: EdgeInsets.symmetric(vertical: kTopPadding),
              child: Text(
                key,
                style: TextStyles.defaultStyle.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.subTitleColor,
                ),
              ),
            ),
            
            // Notification items
            ...items.map((notification) => _buildNotificationItem(notification)).toList(),
          ],
        );
      },
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteNotification(notification),
      background: Container(
        margin: EdgeInsets.only(bottom: kDefaultPadding),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(kItemPadding),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: kMediumPadding),
        child: Icon(
          FontAwesomeIcons.trash,
          color: Colors.white,
          size: 20,
        ),
      ),
      child: InkWell(
        onTap: () {
          if (!notification.isRead) {
            _markAsRead(notification);
          }
          // TODO: Navigate to action URL
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Mở: ${notification.actionUrl ?? "N/A"}'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(kItemPadding),
        child: Container(
          margin: EdgeInsets.only(bottom: kDefaultPadding),
          padding: EdgeInsets.all(kDefaultPadding),
          decoration: BoxDecoration(
            color: notification.isRead 
              ? Colors.white 
              : ColorPalette.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(kItemPadding),
            border: Border.all(
              color: notification.isRead 
                ? ColorPalette.dividerColor 
                : ColorPalette.primaryColor.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: notification.isRead 
              ? [] 
              : [
                  BoxShadow(
                    color: ColorPalette.primaryColor.withOpacity(0.08),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon/Image
              _buildNotificationIcon(notification),
              
              SizedBox(width: kDefaultPadding),
              
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
                            style: TextStyles.defaultStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: EdgeInsets.only(left: kMinPadding),
                            decoration: BoxDecoration(
                              color: ColorPalette.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    
                    SizedBox(height: kMinPadding),
                    
                    Text(
                      notification.message,
                      style: TextStyles.defaultStyle.copyWith(
                        fontSize: 13,
                        color: ColorPalette.subTitleColor,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    SizedBox(height: kTopPadding),
                    
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.clock,
                          size: 12,
                          color: ColorPalette.subTitleColor,
                        ),
                        SizedBox(width: kMinPadding),
                        Text(
                          notification.timeAgo,
                          style: TextStyles.defaultStyle.copyWith(
                            fontSize: 12,
                            color: ColorPalette.subTitleColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(NotificationModel notification) {
    if (notification.imageUrl != null && notification.imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(kTopPadding),
        child: ImageHelper.loadFromAsset(
          notification.imageUrl!,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      );
    }

    IconData icon;
    Color color;
    
    switch (notification.type) {
      case NotificationType.trip:
        icon = FontAwesomeIcons.plane;
        color = Colors.blue;
        break;
      case NotificationType.booking:
        icon = FontAwesomeIcons.bed;
        color = Colors.green;
        break;
      case NotificationType.review:
        icon = FontAwesomeIcons.star;
        color = ColorPalette.yellowColor;
        break;
      case NotificationType.like:
        icon = FontAwesomeIcons.heart;
        color = Colors.pink;
        break;
      case NotificationType.promotion:
        icon = FontAwesomeIcons.tag;
        color = Colors.orange;
        break;
      case NotificationType.system:
        icon = FontAwesomeIcons.bell;
        color = ColorPalette.primaryColor;
        break;
    }

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(kTopPadding),
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  Widget _buildEmptyState() {
    return const EmptyStateWidget(
      icon: FontAwesomeIcons.bellSlash,
      title: 'Không có thông báo',
      subtitle: 'Bạn chưa có thông báo nào',
      iconSize: 50,
    );
  }
}
