import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AllServicesScreen extends StatefulWidget {
  const AllServicesScreen({Key? key}) : super(key: key);

  static const String routeName = '/all_services_screen';

  @override
  State<AllServicesScreen> createState() => _AllServicesScreenState();
}

class _AllServicesScreenState extends State<AllServicesScreen> {
  final List<ServiceCategory> _serviceCategories = [
    ServiceCategory(
      title: 'Lập Kế Hoạch',
      icon: FontAwesomeIcons.calendarCheck,
      color: Colors.blue,
      services: [
        ServiceItem(
          title: 'Tạo Kế Hoạch Chuyến Đi',
          description: 'Lên kế hoạch chi tiết cho chuyến đi của bạn',
          icon: FontAwesomeIcons.route,
          route: '/trip_creation_screen',
          color: Colors.blue,
        ),
        ServiceItem(
          title: 'Danh Sách Chuyến Đi',
          description: 'Xem và quản lý tất cả kế hoạch chuyến đi',
          icon: FontAwesomeIcons.list,
          route: '/trip_plans_list_screen',
          color: Colors.blue,
        ),
        ServiceItem(
          title: 'Checklist Trước Khi Đi',
          description: 'Danh sách đồ dùng cần chuẩn bị',
          icon: FontAwesomeIcons.listCheck,
          route: '/travel_checklist_screen',
          color: Colors.orange,
        ),
        ServiceItem(
          title: 'Quản Lý Ngân Sách',
          description: 'Theo dõi chi tiêu chuyến đi',
          icon: FontAwesomeIcons.wallet,
          route: '/budget_screen',
          color: Colors.teal,
        ),
      ],
    ),
    ServiceCategory(
      title: 'Tiện Ích',
      icon: FontAwesomeIcons.wrench,
      color: Colors.green,
      services: [
        ServiceItem(
          title: 'Bản Đồ',
          description: 'Xem bản đồ và tìm địa điểm',
          icon: FontAwesomeIcons.map,
          route: '/map_screen',
          color: Colors.green,
        ),
        ServiceItem(
          title: 'Đổi Tiền & Máy Tính',
          description: 'Chuyển đổi tiền tệ và tính tiền tip',
          icon: FontAwesomeIcons.moneyBill1,
          route: '/currency_converter_screen',
          color: Colors.green,
        ),
      ],
    ),
    ServiceCategory(
      title: 'Khách Sạn & Nơi Ở',
      icon: FontAwesomeIcons.hotel,
      color: Colors.purple,
      services: [
        ServiceItem(
          title: 'Tìm Khách Sạn',
          description: 'Tìm kiếm và đặt phòng khách sạn',
          icon: FontAwesomeIcons.bed,
          route: '/hotel_screen',
          color: Colors.purple,
        ),
        ServiceItem(
          title: 'Nơi Lưu Trú',
          description: 'Khách sạn, homestay, villa...',
          icon: FontAwesomeIcons.house,
          route: '/accommodation_list_screen',
          color: Colors.purple,
        ),
      ],
    ),
    ServiceCategory(
      title: 'Cài Đặt & Tài Khoản',
      icon: FontAwesomeIcons.gear,
      color: Colors.grey,
      services: [
        ServiceItem(
          title: 'Hồ Sơ Cá Nhân',
          description: 'Thông tin và thiết lập tài khoản',
          icon: FontAwesomeIcons.user,
          route: '/profile_screen',
          color: Colors.indigo,
        ),
        ServiceItem(
          title: 'Thông Tin Cá Nhân',
          description: 'Chỉnh sửa thông tin cá nhân',
          icon: FontAwesomeIcons.userPen,
          route: '/personal_info_screen',
          color: Colors.indigo,
        ),
        ServiceItem(
          title: 'Cài Đặt',
          description: 'Thiết lập ứng dụng',
          icon: FontAwesomeIcons.sliders,
          route: '/settings_screen',
          color: Colors.grey,
        ),
        ServiceItem(
          title: 'Danh Sách Yêu Thích',
          description: 'Địa điểm và chuyến đi đã lưu',
          icon: FontAwesomeIcons.heart,
          route: '/like_screen',
          color: Colors.red,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Tất Cả Dịch Vụ',
      implementLeading: true,
      child: ListView.builder(
        padding: const EdgeInsets.all(kMediumPadding),
        itemCount: _serviceCategories.length,
        itemBuilder: (context, categoryIndex) {
          final category = _serviceCategories[categoryIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề danh mục
              Padding(
                padding: EdgeInsets.only(
                  top: categoryIndex > 0 ? kTopPadding : 0,
                  bottom: kDefaultPadding,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: category.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        category.icon,
                        color: category.color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      category.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
              // Lưới dịch vụ
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: category.services.length,
                itemBuilder: (context, serviceIndex) {
                  final service = category.services[serviceIndex];
                  return _buildServiceCard(service);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildServiceCard(ServiceItem service) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, service.route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: service.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(service.icon, color: service.color, size: 28),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                service.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                service.description,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCategory {
  final String title;
  final IconData icon;
  final Color color;
  final List<ServiceItem> services;

  ServiceCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.services,
  });
}

class ServiceItem {
  final String title;
  final String description;
  final IconData icon;
  final String route;
  final Color color;

  ServiceItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    required this.color,
  });
}
