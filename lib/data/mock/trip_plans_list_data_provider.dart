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
