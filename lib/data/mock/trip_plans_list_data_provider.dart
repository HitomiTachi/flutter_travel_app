import 'package:flutter_travels_apps/data/models/trip_plan_list_model.dart';

class TripPlansListDataProvider {
  static List<TripPlan> getSampleTripPlans() {
    return [
      TripPlan(
        id: '1',
        title: 'Khám phá Hà Nội',
        destination: 'Hà Nội, Việt Nam',
        startDate: '15 Nov 2024',
        endDate: '18 Nov 2024',
        duration: '4 ngày 3 đêm',
        budget: 3500000,
        travelers: 2,
        status: TripStatus.completed,
        imageUrl: 'assets/images/img1.jpg',
        activities: 12,
        progress: 1.0,
      ),
      TripPlan(
        id: '2',
        title: 'Phú Quốc Nghỉ Dưỡng',
        destination: 'Phú Quốc, Kiên Giang',
        startDate: '20 Dec 2024',
        endDate: '24 Dec 2024',
        duration: '5 ngày 4 đêm',
        budget: 8500000,
        travelers: 4,
        status: TripStatus.planned,
        imageUrl: 'assets/images/img2.jpg',
        activities: 15,
        progress: 0.3,
      ),
      TripPlan(
        id: '3',
        title: 'Hành Trình Miền Trung',
        destination: 'Đà Nẵng - Hội An - Huế',
        startDate: '05 Jan 2025',
        endDate: '11 Jan 2025',
        duration: '7 ngày 6 đêm',
        budget: 12000000,
        travelers: 3,
        status: TripStatus.ongoing,
        imageUrl: 'assets/images/img3.jpg',
        activities: 20,
        progress: 0.65,
      ),
      TripPlan(
        id: '4',
        title: 'Đà Lạt Lãng Mạn',
        destination: 'Đà Lạt, Lâm Đồng',
        startDate: '14 Feb 2025',
        endDate: '16 Feb 2025',
        duration: '3 ngày 2 đêm',
        budget: 4500000,
        travelers: 2,
        status: TripStatus.planned,
        imageUrl: 'assets/images/img1.jpg',
        activities: 8,
        progress: 0.1,
      ),
      TripPlan(
        id: '5',
        title: 'Sapa Chinh Phục',
        destination: 'Sapa, Lào Cai',
        startDate: '01 Mar 2025',
        endDate: '05 Mar 2025',
        duration: '5 ngày 4 đêm',
        budget: 6500000,
        travelers: 6,
        status: TripStatus.planned,
        imageUrl: 'assets/images/img2.jpg',
        activities: 14,
        progress: 0.2,
      ),
      TripPlan(
        id: '6',
        title: 'Vịnh Hạ Long',
        destination: 'Hạ Long, Quảng Ninh',
        startDate: '10 Apr 2024',
        endDate: '12 Apr 2024',
        duration: '3 ngày 2 đêm',
        budget: 5500000,
        travelers: 4,
        status: TripStatus.completed,
        imageUrl: 'assets/images/img3.jpg',
        activities: 10,
        progress: 1.0,
      ),
      TripPlan(
        id: '7',
        title: 'Nha Trang Biển Xanh',
        destination: 'Nha Trang, Khánh Hòa',
        startDate: '15 May 2025',
        endDate: '19 May 2025',
        duration: '5 ngày 4 đêm',
        budget: 7500000,
        travelers: 5,
        status: TripStatus.planned,
        imageUrl: 'assets/images/img1.jpg',
        activities: 13,
        progress: 0.4,
      ),
      TripPlan(
        id: '8',
        title: 'Miền Tây Sông Nước',
        destination: 'Cần Thơ - Vĩnh Long',
        startDate: '20 Jun 2025',
        endDate: '23 Jun 2025',
        duration: '4 ngày 3 đêm',
        budget: 4800000,
        travelers: 3,
        status: TripStatus.planned,
        imageUrl: 'assets/images/img2.jpg',
        activities: 11,
        progress: 0.15,
      ),
      TripPlan(
        id: '9',
        title: 'Hà Giang Hùng Vĩ',
        destination: 'Hà Giang',
        startDate: '01 Aug 2025',
        endDate: '08 Aug 2025',
        duration: '8 ngày 7 đêm',
        budget: 9500000,
        travelers: 4,
        status: TripStatus.planned,
        imageUrl: 'assets/images/img3.jpg',
        activities: 18,
        progress: 0.25,
      ),
      TripPlan(
        id: '10',
        title: 'Côn Đảo Hoang Sơ',
        destination: 'Côn Đảo, Bà Rịa - Vũng Tàu',
        startDate: '15 Sep 2024',
        endDate: '18 Sep 2024',
        duration: '4 ngày 3 đêm',
        budget: 10500000,
        travelers: 2,
        status: TripStatus.completed,
        imageUrl: 'assets/images/img1.jpg',
        activities: 9,
        progress: 1.0,
      ),
    ];
  }

  static List<TripPlan> filterTripsByStatus(List<TripPlan> trips, String filter) {
    if (filter == 'Tất cả') return trips;
    TripStatus? filterStatus;
    switch (filter) {
      case 'Hoàn thành':
        filterStatus = TripStatus.completed;
        break;
      case 'Đang thực hiện':
        filterStatus = TripStatus.ongoing;
        break;
      case 'Kế hoạch':
        filterStatus = TripStatus.planned;
        break;
      default:
        return trips;
    }
    return trips.where((trip) => trip.status == filterStatus).toList();
  }

  static List<String> getFilterOptions() {
    return ['Tất cả', 'Hoàn thành', 'Đang thực hiện', 'Kế hoạch'];
  }

  static Map<String, int> getTripStats(List<TripPlan> trips) {
    return {
      'completed': trips.where((t) => t.status == TripStatus.completed).length,
      'ongoing': trips.where((t) => t.status == TripStatus.ongoing).length,
      'planned': trips.where((t) => t.status == TripStatus.planned).length,
    };
  }
}
