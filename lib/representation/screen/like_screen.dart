import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:flutter_travels_apps/data/mock/destination_data_provider.dart';
import 'package:flutter_travels_apps/data/mock/article_data_provider.dart';
import 'package:flutter_travels_apps/data/mock/trip_plans_list_data_provider.dart';
import 'package:flutter_travels_apps/data/models/popular_destination.dart';
import 'package:flutter_travels_apps/data/models/featured_article.dart';
import 'package:flutter_travels_apps/data/models/trip_plan_list_model.dart';
import 'package:flutter_travels_apps/representation/widgets/like_filter_section.dart';

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

  // Filter state - Tất cả filters gộp chung theo từng tab
  final Map<int, List<String>> _filtersByTab = {
    0: ['Tất cả', 'Biển', 'Núi', 'Ẩm thực'],           // Địa danh
    1: ['Tất cả', 'Kinh nghiệm', 'Review', 'Gợi ý lịch trình'], // Bài viết
    2: ['Tất cả'],                                      // Lịch trình
  };
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
                allFilters: _filtersByTab[_tabController.index] ?? ['Tất cả'],
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
                    _PlacesTab(
                      grid: _grid,
                      editMode: _editMode,
                      selectedIds: _selectedIds,
                      keyword: _searchCtl.text,
                      filterIndex: _selectedFilterIndex,
                      filters: _filtersByTab[0]!,
                      destinations: _destinations,
                      onToggleSelect: _toggleSelect,
                      scrollController: _scrollController,
                    ),
                    // Tab 1: Bài viết
                    _ArticlesTab(
                      grid: _grid,
                      editMode: _editMode,
                      selectedIds: _selectedIds,
                      keyword: _searchCtl.text,
                      filterIndex: _selectedFilterIndex,
                      filters: _filtersByTab[1]!,
                      articles: _articles,
                      onToggleSelect: _toggleSelect,
                      scrollController: _scrollController,
                    ),
                    // Tab 2: Lịch trình
                    _TripsTab(
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

/// ================== TABS ==================

class _PlacesTab extends StatelessWidget {
  final bool grid, editMode;
  final Set<String> selectedIds;
  final String keyword;
  final int filterIndex;
  final List<String> filters;
  final List<PopularDestination> destinations;
  final ValueChanged<String> onToggleSelect;
  final ScrollController scrollController;

  const _PlacesTab({
    Key? key,
    required this.grid,
    required this.editMode,
    required this.selectedIds,
    required this.keyword,
    required this.filterIndex,
    required this.filters,
    required this.destinations,
    required this.onToggleSelect,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Bước 1: Lọc theo từ khóa tìm kiếm
    final searchFiltered = destinations.where((dest) {
      final matchText = keyword.isEmpty ||
          dest.name.toLowerCase().contains(keyword.toLowerCase()) ||
          dest.country.toLowerCase().contains(keyword.toLowerCase()) ||
          dest.description.toLowerCase().contains(keyword.toLowerCase());
      return matchText;
    }).toList();

    // Bước 2: Áp dụng filter
    final filtered = filterIndex == 0 
        ? searchFiltered 
        : DestinationDataProvider.filterByCategory(searchFiltered, filters[filterIndex]);

    if (filtered.isEmpty) return const _EmptyState(title: 'Không tìm thấy địa điểm nào');

    if (grid) {
      return GridView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(kDefaultPadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.9),
        itemCount: filtered.length,
        itemBuilder: (_, i) => _PlaceCard(
          destination: filtered[i],
          selected: selectedIds.contains(filtered[i].id),
          editMode: editMode,
          onLongPress: () => onToggleSelect(filtered[i].id),
          onTap: () => editMode ? onToggleSelect(filtered[i].id) : null,
        ),
      );
    }
    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.all(kDefaultPadding),
      itemBuilder: (_, i) => _PlaceTile(
        destination: filtered[i],
        selected: selectedIds.contains(filtered[i].id),
        editMode: editMode,
        onLongPress: () => onToggleSelect(filtered[i].id),
        onTap: () => editMode ? onToggleSelect(filtered[i].id) : null,
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: filtered.length,
    );
  }
}

class _ArticlesTab extends StatelessWidget {
  final bool grid, editMode;
  final Set<String> selectedIds;
  final String keyword;
  final int filterIndex;
  final List<String> filters;
  final List<FeaturedArticle> articles;
  final ValueChanged<String> onToggleSelect;
  final ScrollController scrollController;

  const _ArticlesTab({
    Key? key,
    required this.grid,
    required this.editMode,
    required this.selectedIds,
    required this.keyword,
    required this.filterIndex,
    required this.filters,
    required this.articles,
    required this.onToggleSelect,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Bước 1: Lọc theo từ khóa tìm kiếm
    final searchFiltered = articles.where((article) {
      final matchText = keyword.isEmpty ||
          article.title.toLowerCase().contains(keyword.toLowerCase()) ||
          article.subtitle.toLowerCase().contains(keyword.toLowerCase());
      return matchText;
    }).toList();
    
    // Bước 2: Áp dụng filter
    final filtered = filterIndex == 0 
        ? searchFiltered 
        : ArticleDataProvider.filterByCategory(searchFiltered, filters[filterIndex]);

    if (filtered.isEmpty) return const _EmptyState(title: 'Không tìm thấy bài viết nào');

    if (grid) {
      return GridView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(kDefaultPadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.78),
        itemCount: filtered.length,
        itemBuilder: (_, i) => _ArticleCard(
          article: filtered[i],
          selected: selectedIds.contains(filtered[i].id),
          editMode: editMode,
          onLongPress: () => onToggleSelect(filtered[i].id),
          onTap: () => editMode ? onToggleSelect(filtered[i].id) : null,
        ),
      );
    }
    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.all(kDefaultPadding),
      itemBuilder: (_, i) => _ArticleTile(
        article: filtered[i],
        selected: selectedIds.contains(filtered[i].id),
        editMode: editMode,
        onLongPress: () => onToggleSelect(filtered[i].id),
        onTap: () => editMode ? onToggleSelect(filtered[i].id) : null,
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: filtered.length,
    );
  }
}

class _TripsTab extends StatelessWidget {
  final bool grid, editMode;
  final Set<String> selectedIds;
  final String keyword;
  final List<TripPlan> data;
  final ValueChanged<String> onToggleSelect;
  final ScrollController scrollController;

  const _TripsTab({
    Key? key,
    required this.grid,
    required this.editMode,
    required this.selectedIds,
    required this.keyword,
    required this.data,
    required this.onToggleSelect,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Chỉ lọc theo từ khóa (lịch trình không có sub filter)
    final filtered = data.where((trip) {
      final matchText = keyword.isEmpty ||
          trip.title.toLowerCase().contains(keyword.toLowerCase()) ||
          trip.destination.toLowerCase().contains(keyword.toLowerCase());
      return matchText;
    }).toList();

    if (filtered.isEmpty) return const _EmptyState(title: 'Không tìm thấy lịch trình nào');

    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.all(kDefaultPadding),
      itemBuilder: (_, i) => _TripCard(
        item: filtered[i],
        selected: selectedIds.contains(filtered[i].id),
        editMode: editMode,
        onLongPress: () => onToggleSelect(filtered[i].id),
        onTap: () => editMode ? onToggleSelect(filtered[i].id) : null,
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: filtered.length,
    );
  }
}

/// ================== ITEM WIDGETS ==================

class _SelectableMark extends StatelessWidget {
  final bool visible;
  final bool selected;
  const _SelectableMark({required this.visible, required this.selected, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: selected ? ColorPalette.primaryColor : Colors.white,
          border: Border.all(color: ColorPalette.primaryColor, width: 1.2),
          borderRadius: BorderRadius.circular(10),
        ),
        width: 22, height: 22,
        child: Icon(selected ? Icons.check : Icons.circle_outlined,
            size: 14, color: selected ? Colors.white : ColorPalette.primaryColor),
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final PopularDestination destination;
  final bool editMode;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const _PlaceCard({
    Key? key,
    required this.destination,
    required this.editMode,
    required this.selected,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Thumb(image: destination.imageUrl, height: 120, width: double.infinity, borderRadius: BorderRadius.zero),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(destination.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: TextStyles.defaultStyle.semiBold),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 14, color: ColorPalette.subTitleColor),
                                const SizedBox(width: 4),
                                Text(destination.country, style: TextStyles.defaultStyle.setTextSize(12).subTitleTextColor),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.star, color: ColorPalette.yellowColor, size: kDefaultIconSize),
                      const SizedBox(width: 4),
                      Text('${destination.rating}', style: TextStyles.defaultStyle.semiBold),
                    ],
                  ),
                ),
              ],
            ),
            _SelectableMark(visible: editMode, selected: selected),
          ],
        ),
      ),
    );
  }
}

class _PlaceTile extends StatelessWidget {
  final PopularDestination destination;
  final bool editMode;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const _PlaceTile({
    Key? key,
    required this.destination,
    required this.editMode,
    required this.selected,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1.5,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              _Thumb(image: destination.imageUrl, height: 70, width: 100, borderRadius: BorderRadius.circular(10)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(destination.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyles.defaultStyle.semiBold),
                    const SizedBox(height: 2),
                    Text(destination.country, style: TextStyles.defaultStyle.setTextSize(12).subTitleTextColor),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, color: ColorPalette.yellowColor, size: kDefaultIconSize),
                        const SizedBox(width: 4),
                        Text('${destination.rating}', style: TextStyles.defaultStyle.semiBold),
                      ],
                    ),
                  ],
                ),
              ),
              _SelectableMark(visible: editMode, selected: selected),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final FeaturedArticle article;
  final bool editMode;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const _ArticleCard({
    Key? key,
    required this.article,
    required this.editMode,
    required this.selected,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      color: Colors.white,
      borderRadius: BorderRadius.circular(kItemPadding + 2),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _Thumb(
                    image: article.imageUrl,
                    height: double.infinity,
                    width: double.infinity,
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(kTopPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          article.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.defaultStyle.semiBold.fontCaption,
                        ),
                        const SizedBox(height: kMinPadding - 1),
                        Text(
                          article.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.defaultStyle.fontCaption.copyWith(fontSize: 11).subTitleTextColor,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(Icons.person_outline, size: kDefaultIconSize - 4, color: ColorPalette.subTitleColor),
                            const SizedBox(width: kMinPadding - 1),
                            Expanded(
                              child: Text(
                                article.author,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.defaultStyle.fontCaption.copyWith(fontSize: 11).subTitleTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _SelectableMark(visible: editMode, selected: selected),
          ],
        ),
      ),
    );
  }
}

class _ArticleTile extends StatelessWidget {
  final FeaturedArticle article;
  final bool editMode;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const _ArticleTile({
    Key? key,
    required this.article,
    required this.editMode,
    required this.selected,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1.5,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              _Thumb(image: article.imageUrl, height: 70, width: 100, borderRadius: BorderRadius.circular(10)),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: TextStyles.defaultStyle.semiBold),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: kDefaultIconSize, color: ColorPalette.subTitleColor),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              article.author,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.defaultStyle.setTextSize(12).subTitleTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              _SelectableMark(visible: editMode, selected: selected),
            ],
          ),
        ),
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final TripPlan item;
  final bool editMode;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const _TripCard({
    Key? key,
    required this.item,
    required this.editMode,
    required this.selected,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  _Thumb(image: item.imageUrl, height: 70, width: 100, borderRadius: BorderRadius.circular(10)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: TextStyles.defaultStyle.semiBold),
                        const SizedBox(height: 4),
                        Text(item.destination, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: TextStyles.defaultStyle.setTextSize(12).subTitleTextColor),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14, color: ColorPalette.subTitleColor),
                            const SizedBox(width: 4),
                            Text(item.duration, style: TextStyles.defaultStyle.setTextSize(12).subTitleTextColor),
                            const SizedBox(width: 12),
                            const Icon(Icons.place, size: 14, color: ColorPalette.subTitleColor),
                            const SizedBox(width: 4),
                            Text('${item.activities} hoạt động', style: TextStyles.defaultStyle.setTextSize(12).subTitleTextColor),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _SelectableMark(visible: editMode, selected: selected),
          ],
        ),
      ),
    );
  }
}

/// ================== COMMON ==================

class _Thumb extends StatelessWidget {
  final String image;
  final double height;
  final double width;
  final BorderRadiusGeometry borderRadius;

  const _Thumb({
    Key? key,
    required this.image,
    required this.height,
    required this.width,
    required this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.asset(image, height: height, width: width, fit: BoxFit.cover),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  const _EmptyState({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite_border, size: 56, color: ColorPalette.subTitleColor),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center,
                style: TextStyles.defaultStyle.setTextSize(14).subTitleTextColor),
          ],
        ),
      ),
    );
  }
}
