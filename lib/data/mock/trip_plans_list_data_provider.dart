import 'package:flutter_travels_apps/data/models/trip_plan_list_model.dart';

class TripPlansListDataProvider {
  static List<TripPlan> getSampleTripPlans() {
    return [
      // ...existing sample data from trip_plans_provider.dart...
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
