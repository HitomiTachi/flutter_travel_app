/// Helper class để quản lý navigation giữa các tab trong MainApp
/// Sử dụng pattern Singleton để đảm bảo chỉ có một instance duy nhất
class NavigationHelper {
  // Singleton instance
  static final NavigationHelper _instance = NavigationHelper._internal();
  factory NavigationHelper() => _instance;
  NavigationHelper._internal();

  // Callback để chuyển tab
  Function(int, Map<String, dynamic>?)? _onTabChanged;

  /// Đăng ký callback khi tab thay đổi
  /// Gọi từ MainApp để nhận thông báo khi cần chuyển tab
  void registerTabChangeCallback(Function(int, Map<String, dynamic>?) callback) {
    _onTabChanged = callback;
  }

  /// Hủy đăng ký callback
  void unregisterTabChangeCallback() {
    _onTabChanged = null;
  }

  /// Chuyển đến tab chỉ định với optional arguments
  /// 0 = Home, 1 = Map, 2 = Like, 3 = Profile
  /// [arguments] - Map chứa các tham số bổ sung cho screen (vd: initialTab, showAll)
  void navigateToTab(int tabIndex, {Map<String, dynamic>? arguments}) {
    if (_onTabChanged != null) {
      _onTabChanged!(tabIndex, arguments);
    }
  }

  /// Constants cho các tab index để dễ quản lý
  static const int homeTab = 0;
  static const int mapTab = 1;
  static const int likeTab = 2;
  static const int profileTab = 3;

  /// Helper methods để chuyển đến từng tab cụ thể
  void goToHome() => navigateToTab(homeTab);
  void goToMap() => navigateToTab(mapTab);
  
  /// Chuyển đến Like tab với options
  /// [initialTab] - Tab con bên trong LikeScreen (0: Địa điểm, 1: Bình luận, 2: Kế hoạch)
  /// [showAll] - Hiển thị tất cả items thay vì chỉ favorites
  void goToLike({int? initialTab, bool? showAll}) {
    final args = <String, dynamic>{};
    if (initialTab != null) args['initialTab'] = initialTab;
    if (showAll != null) args['showAll'] = showAll;
    navigateToTab(likeTab, arguments: args.isNotEmpty ? args : null);
  }
  
  void goToProfile() => navigateToTab(profileTab);
}