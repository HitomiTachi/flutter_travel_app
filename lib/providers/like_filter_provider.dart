/// Provider tổng hợp: Constants + Logic xử lý filter cho LikeScreen
/// Gộp cả cấu hình và phương thức xử lý vào 1 file để dễ quản lý
class LikeFilterProvider {
  // ============================================================================
  // PHẦN 1: TAB CONFIGURATION - Cấu hình các tab
  // ============================================================================
  
  /// Index của tab Địa danh
  static const int tabPlaces = 0;
  
  /// Index của tab Bài viết
  static const int tabArticles = 1;
  
  /// Index của tab Lịch trình
  static const int tabTrips = 2;

  // ============================================================================
  // PHẦN 2: FILTER OPTIONS - Danh sách filter cho từng tab
  // ============================================================================
  
  /// Danh sách filter cho tab Địa danh
  static const List<String> filtersPlaces = [
    'Tất cả',
    'Biển',
    'Núi',
    'Ẩm thực',
  ];

  /// Danh sách filter cho tab Bài viết
  static const List<String> filtersArticles = [
    'Tất cả',
    'Kinh nghiệm',
    'Review',
    'Gợi ý lịch trình',
  ];

  /// Danh sách filter cho tab Lịch trình
  static const List<String> filtersTrips = [
    'Tất cả',
  ];

  /// Map ánh xạ tab index → danh sách filter tương ứng
  static const Map<int, List<String>> filtersByTab = {
    tabPlaces: filtersPlaces,
    tabArticles: filtersArticles,
    tabTrips: filtersTrips,
  };

  // ============================================================================
  // PHẦN 3: TAB LABELS - Tên hiển thị của các tab
  // ============================================================================
  
  /// Label hiển thị cho tab Địa danh
  static const String labelPlaces = 'Địa danh';
  
  /// Label hiển thị cho tab Bài viết
  static const String labelArticles = 'Bài viết';
  
  /// Label hiển thị cho tab Lịch trình
  static const String labelTrips = 'Lịch trình';

  // ============================================================================
  // PHẦN 4: EMPTY STATE MESSAGES - Thông báo khi không có dữ liệu
  // ============================================================================
  
  /// Thông báo khi tab Địa danh trống
  static const String emptyPlaces = 'Không tìm thấy địa điểm nào';
  
  /// Thông báo khi tab Bài viết trống
  static const String emptyArticles = 'Không tìm thấy bài viết nào';
  
  /// Thông báo khi tab Lịch trình trống
  static const String emptyTrips = 'Không tìm thấy lịch trình nào';

  // ============================================================================
  // PHẦN 5: GRID CONFIGURATION - Cấu hình hiển thị grid
  // ============================================================================
  
  /// Tỷ lệ aspect ratio cho card Địa danh (0.85 = gần vuông)
  static const double gridAspectRatioPlace = 0.85;
  
  /// Tỷ lệ aspect ratio cho card Bài viết (0.78 = cao hơn)
  static const double gridAspectRatioArticle = 0.78;
  
  /// Tỷ lệ aspect ratio cho card Lịch trình (0.9 = trung bình)
  static const double gridAspectRatioTrip = 0.9;

  // ============================================================================
  // PHẦN 6: SCROLL BEHAVIOR - Cấu hình hành vi cuộn
  // ============================================================================
  
  /// Ngưỡng cuộn để ẩn/hiện filter bar (50px)
  static const double scrollThreshold = 50.0;
  
  /// Offset tối thiểu trước khi bắt đầu xử lý scroll (100px)
  static const double minScrollOffset = 100.0;

  // ============================================================================
  // PHẦN 7: HELPER METHODS - Các phương thức xử lý logic
  // ============================================================================

  /// Lấy danh sách filters theo tab index
  /// 
  /// Trả về list filter tương ứng với tab, nếu không tìm thấy trả về ['Tất cả']
  /// 
  /// Ví dụ: getFiltersForTab(0) → ['Tất cả', 'Biển', 'Núi', 'Ẩm thực']
  static List<String> getFiltersForTab(int tabIndex) {
    return filtersByTab[tabIndex] ?? ['Tất cả'];
  }

  /// Kiểm tra có cần hiển thị filter bar không
  /// 
  /// Chỉ hiện filter bar khi có nhiều hơn 1 option
  /// Tab Lịch trình chỉ có 'Tất cả' → không hiện filter bar
  /// 
  /// Ví dụ: shouldShowFilters(0) → true, shouldShowFilters(2) → false
  static bool shouldShowFilters(int tabIndex) {
    final filters = getFiltersForTab(tabIndex);
    return filters.length > 1;
  }

  /// Lấy tên filter hiện tại đang được chọn
  /// 
  /// Nếu filterIndex ngoài phạm vi → trả về filter đầu tiên
  /// 
  /// Ví dụ: getCurrentFilterLabel(0, 2) → 'Núi'
  static String getCurrentFilterLabel(int tabIndex, int filterIndex) {
    final filters = getFiltersForTab(tabIndex);
    if (filterIndex < 0 || filterIndex >= filters.length) {
      return filters.first;
    }
    return filters[filterIndex];
  }

  /// Lấy tên tab theo index
  /// 
  /// Ví dụ: getTabLabel(0) → 'Địa danh'
  static String getTabLabel(int tabIndex) {
    switch (tabIndex) {
      case tabPlaces:
        return labelPlaces;
      case tabArticles:
        return labelArticles;
      case tabTrips:
        return labelTrips;
      default:
        return '';
    }
  }

  /// Lấy thông báo trống theo tab
  /// 
  /// Hiển thị khi danh sách bị filter hết hoặc không có dữ liệu
  /// 
  /// Ví dụ: getEmptyMessage(0) → 'Không tìm thấy địa điểm nào'
  static String getEmptyMessage(int tabIndex) {
    switch (tabIndex) {
      case tabPlaces:
        return emptyPlaces;
      case tabArticles:
        return emptyArticles;
      case tabTrips:
        return emptyTrips;
      default:
        return 'Không tìm thấy dữ liệu';
    }
  }

  /// Lấy tỷ lệ aspect ratio cho GridView theo tab
  /// 
  /// Mỗi tab có tỷ lệ khác nhau để card hiển thị đẹp
  /// 
  /// Ví dụ: getGridAspectRatio(0) → 0.85 (card địa danh gần vuông)
  static double getGridAspectRatio(int tabIndex) {
    switch (tabIndex) {
      case tabPlaces:
        return gridAspectRatioPlace;
      case tabArticles:
        return gridAspectRatioArticle;
      case tabTrips:
        return gridAspectRatioTrip;
      default:
        return 1.0;
    }
  }
}
