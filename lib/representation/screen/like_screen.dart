import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:flutter_travels_apps/core/helpers/asset_helper.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:flutter_travels_apps/data/mock/destination_data_provider.dart';
import 'package:flutter_travels_apps/data/mock/article_data_provider.dart';
import 'package:flutter_travels_apps/data/models/popular_destination.dart';
import 'package:flutter_travels_apps/data/models/featured_article.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({Key? key}) : super(key: key);
  static const routeName = '/like_screen';

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> with TickerProviderStateMixin {
  final _searchCtl = TextEditingController();
  bool _grid = true;
  bool _editMode = false;
  final Set<String> _selectedIds = {};
  final _chips = const ['Tất cả', 'Việt Nam', 'Biển', 'Núi', 'Ẩm thực'];
  int _chipIndex = 0;
  late TabController _tabController;
  bool _showAll = false;

  // IDs của các items được yêu thích
  late Set<String> _likedPlaceIds;
  late Set<String> _likedArticleIds;
  final List<Map<String, dynamic>> _likedTrips = [
    {'id': 't1', 'image': AssetHelper.image3, 'title': 'Phú Quốc 4N3Đ', 'days': 4, 'stops': 9},
  ];

  @override
  void initState() {
    super.initState();
    // Load IDs mặc định từ providers (đơn giản hơn)
    _likedPlaceIds = DestinationDataProvider.getDefaultFavoriteIds();
    _likedArticleIds = ArticleDataProvider.getDefaultFavoriteIds();
    
    // Initialize TabController với initial index
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get initial tab from route arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['initialTab'] != null) {
      final initialTab = args['initialTab'] as int;
      _tabController.index = initialTab;
      if (args['showAll'] == true) _showAll = true;
    }
  }

  // Getters gọn gàng sử dụng methods từ providers
  List<PopularDestination> get _likedPlaces {
    if (_showAll) return DestinationDataProvider.getPopularDestinations();
    return DestinationDataProvider.getDestinationsByIds(_likedPlaceIds);
  }

  List<FeaturedArticle> get _likedArticles {
    if (_showAll) return ArticleDataProvider.getFeaturedArticles();
    return ArticleDataProvider.getArticlesByIds(_likedArticleIds);
  }

  @override
  void dispose() {
    _searchCtl.dispose();
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
      // Xóa khỏi các set IDs
      _likedPlaceIds.removeWhere((id) => _selectedIds.contains(id));
      _likedArticleIds.removeWhere((id) => _selectedIds.contains(id));
      _likedTrips.removeWhere((e) => _selectedIds.contains(e['id']));
      _selectedIds.clear();
      _editMode = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xoá khỏi danh sách yêu thích')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: AppBarContainerWidget(
        // ====== HEADER tuỳ biến của bạn ======
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
        // ====== BODY bắt đầu tại content margin-top 156 của AppBarContainerWidget ======
        child: Stack(
          children: [
            Column(
              children: [
                // Search nổi (đồng bộ style)
                Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(12),
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
                const SizedBox(height: 12),

                // Chips lọc ngang
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, i) => ChoiceChip(
                      label: Text(
                        _chips[i],
                        style: TextStyles.defaultStyle.semiBold.copyWith(
                          color: _chipIndex == i ? Colors.white : ColorPalette.primaryColor,
                        ),
                      ),
                      selected: _chipIndex == i,
                      onSelected: (_) => setState(() => _chipIndex = i),
                      selectedColor: ColorPalette.primaryColor,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    ),
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemCount: _chips.length,
                  ),
                ),
                const SizedBox(height: 12),

                // Tabs
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicator: BoxDecoration(
                      color: ColorPalette.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: ColorPalette.primaryColor,
                    labelStyle: TextStyles.defaultStyle.semiBold,
                    tabs: const [
                      Tab(text: 'Địa điểm'),
                      Tab(text: 'Bài viết'),
                      Tab(text: 'Lịch trình'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Nội dung tabs
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _PlacesTab(
                        grid: _grid,
                        editMode: _editMode,
                        selectedIds: _selectedIds,
                        keyword: _searchCtl.text,
                        filterIndex: _chipIndex,
                        chips: _chips,
                        destinations: _likedPlaces,
                        onToggleSelect: _toggleSelect,
                      ),
                      _ArticlesTab(
                        grid: _grid,
                        editMode: _editMode,
                        selectedIds: _selectedIds,
                        keyword: _searchCtl.text,
                        filterIndex: _chipIndex,
                        chips: _chips,
                        articles: _likedArticles,
                        onToggleSelect: _toggleSelect,
                      ),
                      _TripsTab(
                        grid: _grid,
                        editMode: _editMode,
                        selectedIds: _selectedIds,
                        keyword: _searchCtl.text,
                        filterIndex: _chipIndex,
                        data: _likedTrips,
                        onToggleSelect: _toggleSelect,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kDefaultPadding), // chừa đáy cho action bar
              ],
            ),

            // Thanh hành động khi chọn nhiều
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
  final List<String> chips;
  final List<PopularDestination> destinations;
  final ValueChanged<String> onToggleSelect;

  const _PlacesTab({
    Key? key,
    required this.grid,
    required this.editMode,
    required this.selectedIds,
    required this.keyword,
    required this.filterIndex,
    required this.chips,
    required this.destinations,
    required this.onToggleSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filtered = destinations.where((dest) {
      final matchText = keyword.isEmpty ||
          dest.name.toLowerCase().contains(keyword.toLowerCase()) ||
          dest.country.toLowerCase().contains(keyword.toLowerCase());
      return matchText;
    }).toList();

    // Áp dụng filter theo chip (sử dụng method từ provider)
    final chipFiltered = filterIndex == 0 
        ? filtered 
        : DestinationDataProvider.filterByCategory(filtered, chips[filterIndex]);

    if (chipFiltered.isEmpty) return const _EmptyState(title: 'Chưa có địa điểm nào được lưu');

    if (grid) {
      return GridView.builder(
        padding: const EdgeInsets.all(kDefaultPadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.9),
        itemCount: chipFiltered.length,
        itemBuilder: (_, i) => _PlaceCard(
          destination: chipFiltered[i],
          selected: selectedIds.contains(chipFiltered[i].id),
          editMode: editMode,
          onLongPress: () => onToggleSelect(chipFiltered[i].id),
          onTap: () => editMode ? onToggleSelect(chipFiltered[i].id) : null,
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(kDefaultPadding),
      itemBuilder: (_, i) => _PlaceTile(
        destination: chipFiltered[i],
        selected: selectedIds.contains(chipFiltered[i].id),
        editMode: editMode,
        onLongPress: () => onToggleSelect(chipFiltered[i].id),
        onTap: () => editMode ? onToggleSelect(chipFiltered[i].id) : null,
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: chipFiltered.length,
    );
  }
}

class _ArticlesTab extends StatelessWidget {
  final bool grid, editMode;
  final Set<String> selectedIds;
  final String keyword;
  final int filterIndex;
  final List<String> chips;
  final List<FeaturedArticle> articles;
  final ValueChanged<String> onToggleSelect;

  const _ArticlesTab({
    Key? key,
    required this.grid,
    required this.editMode,
    required this.selectedIds,
    required this.keyword,
    required this.filterIndex,
    required this.chips,
    required this.articles,
    required this.onToggleSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filtered = articles.where((article) {
      final matchText = keyword.isEmpty ||
          article.title.toLowerCase().contains(keyword.toLowerCase()) ||
          article.subtitle.toLowerCase().contains(keyword.toLowerCase());
      return matchText;
    }).toList();
    
    // Áp dụng filter theo chip (sử dụng method từ provider)
    final chipFiltered = filterIndex == 0 
        ? filtered 
        : ArticleDataProvider.filterByCategory(filtered, chips[filterIndex]);

    if (chipFiltered.isEmpty) return const _EmptyState(title: 'Chưa có bài viết nào được lưu');

    if (grid) {
      return GridView.builder(
        padding: const EdgeInsets.all(kDefaultPadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.78),
        itemCount: chipFiltered.length,
        itemBuilder: (_, i) => _ArticleCard(
          article: chipFiltered[i],
          selected: selectedIds.contains(chipFiltered[i].id),
          editMode: editMode,
          onLongPress: () => onToggleSelect(chipFiltered[i].id),
          onTap: () => editMode ? onToggleSelect(chipFiltered[i].id) : null,
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(kDefaultPadding),
      itemBuilder: (_, i) => _ArticleTile(
        article: chipFiltered[i],
        selected: selectedIds.contains(chipFiltered[i].id),
        editMode: editMode,
        onLongPress: () => onToggleSelect(chipFiltered[i].id),
        onTap: () => editMode ? onToggleSelect(chipFiltered[i].id) : null,
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: chipFiltered.length,
    );
  }
}

class _TripsTab extends StatelessWidget {
  final bool grid, editMode;
  final Set<String> selectedIds;
  final String keyword;
  final int filterIndex;
  final List<Map<String, dynamic>> data;
  final ValueChanged<String> onToggleSelect;

  const _TripsTab({
    Key? key,
    required this.grid,
    required this.editMode,
    required this.selectedIds,
    required this.keyword,
    required this.filterIndex,
    required this.data,
    required this.onToggleSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filtered = data.where((e) {
      final matchText = keyword.isEmpty ||
          (e['title'] as String).toLowerCase().contains(keyword.toLowerCase());
      return matchText;
    }).toList();

    if (filtered.isEmpty) return const _EmptyState(title: 'Chưa có lịch trình nào được lưu');

    return ListView.separated(
      padding: const EdgeInsets.all(kDefaultPadding),
      itemBuilder: (_, i) => _TripCard(
        item: filtered[i],
        selected: selectedIds.contains(filtered[i]['id']),
        editMode: editMode,
        onLongPress: () => onToggleSelect(filtered[i]['id'] as String),
        onTap: () => editMode ? onToggleSelect(filtered[i]['id'] as String) : null,
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
                _Thumb(image: article.imageUrl, height: 120, width: double.infinity, borderRadius: BorderRadius.zero),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: TextStyles.defaultStyle.semiBold),
                      const SizedBox(height: 6),
                      Text(article.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: TextStyles.defaultStyle.setTextSize(13).subTitleTextColor),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.menu_book, size: kDefaultIconSize, color: ColorPalette.subTitleColor),
                          const SizedBox(width: 4),
                          Text('${article.readTime} phút', style: TextStyles.defaultStyle.setTextSize(12).subTitleTextColor),
                        ],
                      ),
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
                          const Icon(Icons.menu_book, size: kDefaultIconSize, color: ColorPalette.subTitleColor),
                          const SizedBox(width: 4),
                          Text('${article.readTime} phút', style: TextStyles.defaultStyle.setTextSize(12).subTitleTextColor),
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
  final Map<String, dynamic> item;
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
                  _Thumb(image: item['image'], height: 70, width: 100, borderRadius: BorderRadius.circular(10)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title'], maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: TextStyles.defaultStyle.semiBold),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14, color: ColorPalette.subTitleColor),
                            const SizedBox(width: 4),
                            Text('${item['days']} ngày', style: TextStyles.defaultStyle.setTextSize(12).subTitleTextColor),
                            const SizedBox(width: 12),
                            const Icon(Icons.place, size: 14, color: ColorPalette.subTitleColor),
                            const SizedBox(width: 4),
                            Text('${item['stops']} điểm dừng', style: TextStyles.defaultStyle.setTextSize(12).subTitleTextColor),
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
