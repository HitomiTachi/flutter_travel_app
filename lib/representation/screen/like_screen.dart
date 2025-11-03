import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:flutter_travels_apps/representation/widgets/common/app_bar_container.dart';
import 'package:flutter_travels_apps/data/mock/destination_data_provider.dart';
import 'package:flutter_travels_apps/data/mock/article_data_provider.dart';
import 'package:flutter_travels_apps/data/mock/trip_plans_list_data_provider.dart';
import 'package:flutter_travels_apps/data/models/popular_destination.dart';
import 'package:flutter_travels_apps/data/models/featured_article.dart';
import 'package:flutter_travels_apps/data/models/trip_plan_list_model.dart';
import 'package:flutter_travels_apps/providers/like_filter_provider.dart';
import 'package:flutter_travels_apps/representation/widgets/like_widgets/like_filter_section.dart';
import 'package:flutter_travels_apps/representation/widgets/like_widgets/like_tabs/places_tab.dart';
import 'package:flutter_travels_apps/representation/widgets/like_widgets/like_tabs/articles_tab.dart';
import 'package:flutter_travels_apps/representation/widgets/like_widgets/like_tabs/trips_tab.dart';

class LikeScreen extends StatefulWidget {
  final Map<String, dynamic>? arguments;
  
  const LikeScreen({Key? key, this.arguments}) : super(key: key);
  static const routeName = '/like_screen';

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> with TickerProviderStateMixin {
  // UI controls
  final _searchCtl = TextEditingController();
  bool _grid = true;
  bool _editMode = false;
  final Set<String> _selectedIds = {};

  // Scroll control for auto-hide filters
  final ScrollController _scrollController = ScrollController();
  bool _showFilters = true;
  double _lastScrollOffset = 0;

  // Filter state
  int _selectedFilterIndex = 0;

  // Tab controller cho 3 nhóm chính
  late TabController _tabController;

  // Dữ liệu từ mock providers - hiển thị tất cả
  late List<PopularDestination> _allDestinations;
  late List<FeaturedArticle> _allArticles;
  late List<TripPlan> _allTrips;

  @override
  void initState() {
    super.initState();
    // Load toàn bộ dữ liệu từ mock providers
    _allDestinations = DestinationDataProvider.getPopularDestinations();
    _allArticles = ArticleDataProvider.getFeaturedArticles();
    _allTrips = TripPlansListDataProvider.getSampleTripPlans();
    
    // Initialize TabController
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);

    // Initialize ScrollController với listener
    _scrollController.addListener(_onScroll);
  }

  // Listener cho scroll để auto-hide filters
  void _onScroll() {
    final currentOffset = _scrollController.offset;
    
    // Chỉ toggle khi scroll đủ xa (> 50px)
    if ((currentOffset - _lastScrollOffset).abs() > 50) {
      // Scroll xuống → ẩn filters
      if (currentOffset > _lastScrollOffset && currentOffset > 100) {
        if (_showFilters) {
          setState(() => _showFilters = false);
        }
      }
      // Scroll lên → hiện filters
      else if (currentOffset < _lastScrollOffset) {
        if (!_showFilters) {
          setState(() => _showFilters = true);
        }
      }
      _lastScrollOffset = currentOffset;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get arguments từ widget hoặc route
    Map<String, dynamic>? args = widget.arguments;
    if (args == null) {
      args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    }
    
    // Apply arguments nếu có
    if (args != null) {
      if (args['initialTab'] != null) {
        final initialTab = args['initialTab'] as int;
        _tabController.index = initialTab;
      }
    }
  }

  // Callback khi đổi tab chính → reset filter
  void _onTabChanged() {
    if (!mounted) return;
    setState(() {
      _selectedFilterIndex = 0; // Reset về "Tất cả"
    });
  }

  // Getters trả về toàn bộ dữ liệu từ mock providers
  List<PopularDestination> get _destinations => _allDestinations;
  List<FeaturedArticle> get _articles => _allArticles;
  List<TripPlan> get _trips => _allTrips;

  @override
  void dispose() {
    _searchCtl.dispose();
    _scrollController.dispose();
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _editMode = !_editMode;
      if (!_editMode) _selectedIds.clear();
    });
  }

  void _toggleSelect(String id) {
    if (!_editMode) return;
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _bulkUnfavorite() {
    setState(() {
      // Xóa items được chọn
      _allDestinations.removeWhere((d) => _selectedIds.contains(d.id));
      _allArticles.removeWhere((a) => _selectedIds.contains(a.id));
      _allTrips.removeWhere((t) => _selectedIds.contains(t.id));
      _selectedIds.clear();
      _editMode = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xoá khỏi danh sách')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      // ====== HEADER giữ nguyên ======
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Khám phá',
                style: TextStyles.defaultStyle.fontHeader.bold.whiteTextColor,
              ),
            ),
            IconButton(
              tooltip: _grid ? 'Hiển thị danh sách' : 'Hiển thị lưới',
              onPressed: () => setState(() => _grid = !_grid),
              icon: Icon(_grid ? Icons.view_list : Icons.grid_view, color: Colors.white),
            ),
            IconButton(
              tooltip: _editMode ? 'Thoát chọn' : 'Chọn nhiều',
              onPressed: _toggleEditMode,
              icon: Icon(_editMode ? Icons.close : Icons.checklist, color: Colors.white),
            ),
          ],
        ),
      ),
      // ====== BODY ======
      child: Stack(
        children: [
          Column(
            children: [
              // Search TextField - giữ nguyên style
              Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(kItemPadding),
                color: Colors.white,
                child: TextField(
                  controller: _searchCtl,
                  onSubmitted: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm…',
                    hintStyle: TextStyles.defaultStyle.subTitleTextColor,
                    prefixIcon: const Icon(Icons.search, size: kDefaultIconSize),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: kItemPadding,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: kDefaultPadding),

              // LikeFilterSection - Tầng 1: TabBar, Tầng 2: Filters
              LikeFilterSection(
                tabController: _tabController,
                allFilters: LikeFilterProvider.getFiltersForTab(_tabController.index),
                selectedFilterIndex: _selectedFilterIndex,
                onFilterSelected: (index) => setState(() => _selectedFilterIndex = index),
                showFilters: _showFilters,
              ),

              const SizedBox(height: kDefaultPadding),

              // Nội dung tabs
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab 0: Địa danh
                    PlacesTab(
                      grid: _grid,
                      editMode: _editMode,
                      selectedIds: _selectedIds,
                      keyword: _searchCtl.text,
                      filterIndex: _selectedFilterIndex,
                      filters: LikeFilterProvider.getFiltersForTab(LikeFilterProvider.tabPlaces),
                      destinations: _destinations,
                      onToggleSelect: _toggleSelect,
                      scrollController: _scrollController,
                    ),
                    // Tab 1: Bài viết
                    ArticlesTab(
                      grid: _grid,
                      editMode: _editMode,
                      selectedIds: _selectedIds,
                      keyword: _searchCtl.text,
                      filterIndex: _selectedFilterIndex,
                      filters: LikeFilterProvider.getFiltersForTab(LikeFilterProvider.tabArticles),
                      articles: _articles,
                      onToggleSelect: _toggleSelect,
                      scrollController: _scrollController,
                    ),
                    // Tab 2: Lịch trình
                    TripsTab(
                      grid: _grid,
                      editMode: _editMode,
                      selectedIds: _selectedIds,
                      keyword: _searchCtl.text,
                      data: _trips,
                      onToggleSelect: _toggleSelect,
                      scrollController: _scrollController,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: kDefaultPadding), // chừa đáy cho action bar
            ],
          ),

          // Thanh hành động khi chọn nhiều - giữ nguyên
          if (_editMode && _selectedIds.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                minimum: const EdgeInsets.all(kDefaultPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => setState(() => _selectedIds.clear()),
                        icon: const Icon(Icons.clear_all),
                        label: Text('Bỏ chọn', style: TextStyles.defaultStyle.semiBold),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: ColorPalette.primaryColor),
                          foregroundColor: ColorPalette.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _bulkUnfavorite,
                        icon: const Icon(Icons.favorite_border),
                        label: Text('Bỏ yêu thích (${_selectedIds.length})',
                            style: TextStyles.defaultStyle.semiBold.whiteTextColor),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
