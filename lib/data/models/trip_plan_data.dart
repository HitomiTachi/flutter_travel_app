class TripPlanData {
  String destination;
  String departure;
  String startDate;
  String endDate;
  int travelers;
  int destinations;
  int activitiesPerDay;
  double budget;
  bool includeTransport;
  bool includeRestaurants;
  bool includeEntertainment;

  TripPlanData({
    this.destination = 'Hà Nội, Việt Nam',
    this.departure = 'TP. Hồ Chí Minh',
    this.startDate = '13 Feb 2025',
    this.endDate = '20 Feb 2025',
    this.travelers = 2,
    this.destinations = 1,
    this.activitiesPerDay = 3,
    this.budget = 5000000,
    this.includeTransport = true,
    this.includeRestaurants = true,
    this.includeEntertainment = false,
  });

  String get dateRange => '$startDate - $endDate';
  
  // Tự động tính số ngày dựa trên startDate và endDate
  int get totalDays {
    try {
      // Tính toán đơn giản dựa trên format ngày
      // Ví dụ: "13 Feb - 20 Feb 2025" -> 7 ngày
      if (startDate.isNotEmpty && endDate.isNotEmpty) {
        // Parse cơ bản để lấy số ngày
        final startDay = _extractDay(startDate);
        final endDay = _extractDay(endDate);
        
        if (startDay > 0 && endDay > 0 && endDay >= startDay) {
          return endDay - startDay + 1;
        }
      }
      return 7; // Default value
    } catch (e) {
      return 7; // Default value
    }
  }
  
  // Hàm helper để extract ngày từ string
  int _extractDay(String dateStr) {
    try {
      // Extract số từ đầu string, ví dụ: "13 Feb" -> 13
      final parts = dateStr.trim().split(' ');
      if (parts.isNotEmpty) {
        return int.tryParse(parts[0]) ?? 0;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }
  
  String get planSummary => '$travelers Người, $totalDays ngày, $activitiesPerDay hoạt động/ngày';

  // Copy constructor để tạo bản sao
  TripPlanData copyWith({
    String? destination,
    String? departure,
    String? startDate,
    String? endDate,
    int? travelers,
    int? destinations,
    int? activitiesPerDay,
    double? budget,
    bool? includeTransport,
    bool? includeRestaurants,
    bool? includeEntertainment,
  }) {
    return TripPlanData(
      destination: destination ?? this.destination,
      departure: departure ?? this.departure,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      travelers: travelers ?? this.travelers,
      destinations: destinations ?? this.destinations,
      activitiesPerDay: activitiesPerDay ?? this.activitiesPerDay,
      budget: budget ?? this.budget,
      includeTransport: includeTransport ?? this.includeTransport,
      includeRestaurants: includeRestaurants ?? this.includeRestaurants,
      includeEntertainment: includeEntertainment ?? this.includeEntertainment,
    );
  }

  @override
  String toString() {
    return 'TripPlanData(destination: $destination, travelers: $travelers, days: $totalDays)';
  }
}