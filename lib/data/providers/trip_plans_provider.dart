import 'package:flutter_travels_apps/data/models/trip_plan.dart';

class TripPlansDataProvider {
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
        title: 'Phượt Sapa mùa lúa chín',
        destination: 'Sapa, Lào Cai',
        startDate: '20 Dec 2024',
        endDate: '23 Dec 2024',
        duration: '4 ngày 3 đêm',
        budget: 4200000,
        travelers: 4,
        status: TripStatus.ongoing,
        imageUrl: 'assets/images/img2.jpg',
        activities: 15,
        progress: 0.6,
      ),
      TripPlan(
        id: '3',
        title: 'Nghỉ dưỡng Đà Nẵng',
        destination: 'Đà Nẵng, Việt Nam',
        startDate: '10 Jan 2025',
        endDate: '15 Jan 2025',
        duration: '6 ngày 5 đêm',
        budget: 6800000,
        travelers: 2,
        status: TripStatus.planned,
        imageUrl: 'assets/images/img3.jpg',
        activities: 18,
        progress: 0.3,
      ),
      TripPlan(
        id: '4',
        title: 'Khám phá Phú Quốc',
        destination: 'Phú Quốc, Kiên Giang',
        startDate: '22 Feb 2025',
        endDate: '26 Feb 2025',
        duration: '5 ngày 4 đêm',
        budget: 5500000,
        travelers: 6,
        status: TripStatus.planned,
        imageUrl: 'assets/images/imgHotel.jpg',
        activities: 20,
        progress: 0.8,
      ),
      TripPlan(
        id: '5',
        title: 'Trekking Fansipan',
        destination: 'Sapa, Lào Cai',
        startDate: '05 Aug 2024',
        endDate: '08 Aug 2024',
        duration: '4 ngày 3 đêm',
        budget: 3200000,
        travelers: 3,
        status: TripStatus.completed,
        imageUrl: 'assets/images/imgHotel2.jpg',
        activities: 10,
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