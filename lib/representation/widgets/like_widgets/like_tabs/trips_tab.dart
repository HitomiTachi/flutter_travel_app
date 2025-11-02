import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/providers/like_filter_provider.dart';
import 'package:flutter_travels_apps/data/models/trip_plan_list_model.dart';
import 'package:flutter_travels_apps/representation/widgets/like_widgets/like_trip_items.dart';
import 'package:flutter_travels_apps/representation/widgets/common/empty_state_widget.dart';

/// Tab hiển thị danh sách lịch trình
class TripsTab extends StatelessWidget {
  final bool grid;
  final bool editMode;
  final Set<String> selectedIds;
  final String keyword;
  final List<TripPlan> data;
  final ValueChanged<String> onToggleSelect;
  final ScrollController scrollController;

  const TripsTab({
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
      if (keyword.isEmpty) return true;
      final matchText = trip.title.toLowerCase().contains(keyword.toLowerCase()) ||
                       trip.destination.toLowerCase().contains(keyword.toLowerCase());
      return matchText;
    }).toList();

    if (filtered.isEmpty) {
      return const EmptyStateWidget(title: LikeFilterProvider.emptyTrips);
    }

    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.all(kDefaultPadding),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: kDefaultPadding),
      itemBuilder: (context, index) => TripCard(
        item: filtered[index],
        editMode: editMode,
        selected: selectedIds.contains(filtered[index].id),
        onTap: () => onToggleSelect(filtered[index].id),
        onLongPress: () => onToggleSelect(filtered[index].id),
      ),
    );
  }
}
