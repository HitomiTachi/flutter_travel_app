import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/representation/widgets/common/app_bar_container.dart';
import 'package:flutter_travels_apps/representation/widgets/common/empty_state_widget.dart';
import 'package:flutter_travels_apps/services/search_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GlobalSearchScreen extends StatefulWidget {
  static const String routeName = '/global_search_screen';

  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final SearchService _searchService = SearchService();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  List<String> _suggestions = [];
  List<String> _searchHistory = [];
  bool _isLoading = false;
  bool _showHistory = true;

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadSearchHistory() {
    setState(() {
      _searchHistory = _searchService.getSearchHistory();
    });
  }

  void _onSearchChanged() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showHistory = true;
      });
      _loadSuggestions('');
      return;
    }

    _loadSuggestions(query);
  }

  void _loadSuggestions(String query) async {
    final suggestions = await _searchService.getSearchSuggestions(query);
    setState(() {
      _suggestions = suggestions;
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _showHistory = false;
    });

    try {
      final results = await _searchService.globalSearch(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchSubmitted(String query) {
    _performSearch(query);
    _searchController.text = query;
  }

  void _onSuggestionTapped(String suggestion) {
    _searchController.text = suggestion;
    _performSearch(suggestion);
  }

  void _onHistoryItemTapped(String item) {
    _searchController.text = item;
    _performSearch(item);
  }

  void _clearSearchHistory() {
    _searchService.clearSearchHistory();
    setState(() {
      _searchHistory = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Tìm kiếm',
      child: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(kDefaultPadding),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm điểm đến, khách sạn...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: ColorPalette.subTitleColor,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchResults = [];
                              _showHistory = true;
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorPalette.dividerColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorPalette.dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorPalette.primaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: _onSearchSubmitted,
              ),
            ),
          ),

          // Results
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_showHistory && _searchController.text.isEmpty) {
      return _buildSearchHistory();
    }

    if (_suggestions.isNotEmpty &&
        _searchController.text.isNotEmpty &&
        _searchResults.isEmpty) {
      return _buildSuggestions();
    }

    if (_searchResults.isEmpty && _searchController.text.isNotEmpty) {
      return const EmptyStateWidget(
        icon: Icons.search_off,
        title: 'Không tìm thấy kết quả',
        subtitle: 'Thử từ khóa khác hoặc kiểm tra lại chính tả',
        iconSize: 64,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return _buildSearchResultItem(_searchResults[index]);
      },
    );
  }

  Widget _buildSearchHistory() {
    if (_searchHistory.isEmpty) {
      return const EmptyStateWidget(
        icon: FontAwesomeIcons.clockRotateLeft,
        title: 'Chưa có lịch sử tìm kiếm',
        iconSize: 48,
      );
    }

    return ListView(
      padding: EdgeInsets.all(kDefaultPadding),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lịch sử tìm kiếm',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorPalette.textColor,
              ),
            ),
            TextButton(
              onPressed: _clearSearchHistory,
              child: Text('Xóa tất cả'),
            ),
          ],
        ),
        SizedBox(height: 16),
        ..._searchHistory.map(
          (item) => ListTile(
            leading: Icon(Icons.history, color: ColorPalette.subTitleColor),
            title: Text(item),
            onTap: () => _onHistoryItemTapped(item),
            trailing: IconButton(
              icon: Icon(Icons.close, size: 20),
              onPressed: () {
                setState(() {
                  _searchHistory.remove(item);
                  final tempHistory = List<String>.from(_searchHistory);
                  _searchService.clearSearchHistory();
                  tempHistory.forEach(
                    (h) => _searchService.addToSearchHistory(h),
                  );
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestions() {
    return ListView(
      padding: EdgeInsets.all(kDefaultPadding),
      children: [
        Text(
          'Gợi ý',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ColorPalette.textColor,
          ),
        ),
        SizedBox(height: 16),
        ..._suggestions.map(
          (suggestion) => ListTile(
            leading: Icon(Icons.search, color: ColorPalette.subTitleColor),
            title: Text(suggestion),
            onTap: () => _onSuggestionTapped(suggestion),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResultItem(Map<String, dynamic> result) {
    final type = result['type'] as String;
    final name = result['name'] as String;
    final description = result['description'] as String? ?? '';
    final imageUrl = result['imageUrl'] as String?;
    final rating = result['rating'] as double? ?? 0.0;

    return Card(
      margin: EdgeInsets.only(bottom: kDefaultPadding),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to detail screen based on type
        },
        borderRadius: BorderRadius.circular(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 120,
                        height: 120,
                        color: ColorPalette.dividerColor,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 120,
                        height: 120,
                        color: ColorPalette.dividerColor,
                        child: Icon(Icons.image),
                      ),
                    )
                  : Container(
                      width: 120,
                      height: 120,
                      color: ColorPalette.dividerColor,
                      child: Icon(Icons.image, size: 40),
                    ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          type == 'hotel'
                              ? FontAwesomeIcons.hotel
                              : FontAwesomeIcons.mapPin,
                          size: 14,
                          color: ColorPalette.primaryColor,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorPalette.textColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    if (description.isNotEmpty)
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorPalette.subTitleColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    SizedBox(height: 8),
                    if (rating > 0)
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(
                            rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ColorPalette.textColor,
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
      ),
    );
  }
}
