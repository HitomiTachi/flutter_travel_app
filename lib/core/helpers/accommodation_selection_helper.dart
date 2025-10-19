import 'package:flutter_travels_apps/data/models/accommodation_model.dart';

class AccommodationSelectionHelper {
  static AccommodationModel? _selectedAccommodation;
  static bool _shouldNavigateToTripCreation = false;
  
  static AccommodationModel? get selectedAccommodation => _selectedAccommodation;
  
  static void setSelectedAccommodation(AccommodationModel? accommodation) {
    _selectedAccommodation = accommodation;
    _shouldNavigateToTripCreation = true; // Đánh dấu cần chuyển tab
  }
  
  static void clearSelection() {
    _selectedAccommodation = null;
    _shouldNavigateToTripCreation = false;
  }
  
  static bool get hasSelection => _selectedAccommodation != null;
  
  static bool get shouldNavigateToTripCreation => _shouldNavigateToTripCreation;
  
  static void markNavigationHandled() {
    _shouldNavigateToTripCreation = false;
  }
  
  static String getDisplayText() {
    if (hasSelection) {
      return '${_selectedAccommodation!.name} - ${_selectedAccommodation!.type}';
    }
    return 'Khách sạn, Homestay, Resort nổi bật...';
  }
}