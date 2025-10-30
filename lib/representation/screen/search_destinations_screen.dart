import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/data/mock/destination_data.dart';
import 'package:flutter_travels_apps/data/models/popular_destination.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchDestinationsScreen extends StatefulWidget {
  static const String routeName = '/search_destinations_screen';

  const SearchDestinationsScreen({Key? key}) : super(key: key);

  @override
  State<SearchDestinationsScreen> createState() =>
      _SearchDestinationsScreenState();
}

class _SearchDestinationsScreenState extends State<SearchDestinationsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<PopularDestination> _searchResults = [];
  List<PopularDestination> _allDestinations = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _allDestinations = DestinationData.popularDestinations;
    _searchResults = _allDestinations;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _searchResults = _allDestinations;
      } else {
        _searchResults = _allDestinations
            .where(
              (destination) =>
                  destination.name.toLowerCase().contains(query) ||
                  destination.country.toLowerCase().contains(query) ||
                  destination.description.toLowerCase().contains(query),
            )
            .toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _searchResults = _allDestinations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Tìm Kiếm Địa Điểm',
      implementLeading: true,
      child: Column(
        children: [
          const SizedBox(height: kMediumPadding),
          // Thanh tìm kiếm
          _buildSearchBar(),
          const SizedBox(height: kMediumPadding),
          // Kết quả
          Expanded(child: _buildResultsList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm điểm đến, quốc gia...',
          prefixIcon: const Icon(
            FontAwesomeIcons.magnifyingGlass,
            color: ColorPalette.primaryColor,
          ),
          suffixIcon: _isSearching
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                  color: Colors.grey,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    if (_searchResults.isEmpty && _isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.magnifyingGlass,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Không tìm thấy kết quả',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Thử tìm kiếm với từ khóa khác',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final destination = _searchResults[index];
        return _buildDestinationCard(destination);
      },
    );
  }

  Widget _buildDestinationCard(PopularDestination destination) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Điều hướng tới màn hình chi tiết điểm đến
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Chi tiết ${destination.name}'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
              // Hình ảnh
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(destination.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              // Chi tiết
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        destination.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.locationDot,
                            size: 12,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            destination.country,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.solidStar,
                            size: 14,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            destination.rating.toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${destination.reviewCount} đánh giá)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
