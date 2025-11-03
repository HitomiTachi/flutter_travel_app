import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/providers/like_filter_provider.dart';
import 'package:flutter_travels_apps/data/models/popular_destination.dart';
import 'package:flutter_travels_apps/data/mock/destination_data_provider.dart';
import 'package:flutter_travels_apps/representation/widgets/like_widgets/like_place_items.dart';
import 'package:flutter_travels_apps/representation/widgets/common/empty_state_widget.dart';

/// Tab hiển thị danh sách địa danh
class PlacesTab extends StatelessWidget {
  final bool grid;
  final bool editMode;
  final Set<String> selectedIds;
  final String keyword;
  final int filterIndex;
  final List<String> filters;
  final List<PopularDestination> destinations;
  final ValueChanged<String> onToggleSelect;
  final ScrollController scrollController;

  const PlacesTab({
    super.key,
    required this.grid,
    required this.editMode,
    required this.selectedIds,
    required this.keyword,
    required this.filterIndex,
    required this.filters,
    required this.destinations,
    required this.onToggleSelect,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    // Bước 1: Lọc theo từ khóa tìm kiếm
    final searchFiltered = destinations.where((dest) {
      if (keyword.isEmpty) return true;
      final matchText = dest.name.toLowerCase().contains(keyword.toLowerCase()) ||
                       dest.country.toLowerCase().contains(keyword.toLowerCase()) ||
                       dest.description.toLowerCase().contains(keyword.toLowerCase());
      return matchText;
    }).toList();

    // Bước 2: Áp dụng filter theo category
    final filtered = filterIndex == 0 
        ? searchFiltered
        : DestinationDataProvider.filterByCategory(searchFiltered, filters[filterIndex]);

    if (filtered.isEmpty) {
      return const EmptyStateWidget(title: LikeFilterProvider.emptyPlaces);
    }

    if (grid) {
      return GridView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(kDefaultPadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: LikeFilterProvider.gridAspectRatioPlace,
          crossAxisSpacing: kDefaultPadding,
          mainAxisSpacing: kDefaultPadding,
        ),
        itemCount: filtered.length,
        itemBuilder: (context, index) => PlaceCard(
          destination: filtered[index],
          editMode: editMode,
          selected: selectedIds.contains(filtered[index].id),
          onTap: () => onToggleSelect(filtered[index].id),
          onLongPress: () => onToggleSelect(filtered[index].id),
        ),
      );
    }

    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.all(kDefaultPadding),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: kDefaultPadding),
      itemBuilder: (context, index) => PlaceTile(
        destination: filtered[index],
        editMode: editMode,
        selected: selectedIds.contains(filtered[index].id),
        onTap: () => onToggleSelect(filtered[index].id),
        onLongPress: () => onToggleSelect(filtered[index].id),
      ),
    );
  }
}
