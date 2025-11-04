import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/providers/like_filter_provider.dart';
import 'package:flutter_travels_apps/data/models/featured_article.dart';
import 'package:flutter_travels_apps/data/mock/article_data_provider.dart';
import 'package:flutter_travels_apps/representation/widgets/like_widgets/like_article_items.dart';
import 'package:flutter_travels_apps/representation/widgets/common/empty_state_widget.dart';

/// Tab hiển thị danh sách bình luận
class ArticlesTab extends StatelessWidget {
  final bool grid;
  final bool editMode;
  final Set<String> selectedIds;
  final String keyword;
  final int filterIndex;
  final List<String> filters;
  final List<FeaturedArticle> articles;
  final ValueChanged<String> onToggleSelect;
  final ScrollController scrollController;

  const ArticlesTab({
    super.key,
    required this.grid,
    required this.editMode,
    required this.selectedIds,
    required this.keyword,
    required this.filterIndex,
    required this.filters,
    required this.articles,
    required this.onToggleSelect,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    // Bước 1: Lọc theo từ khóa tìm kiếm
    final searchFiltered = articles.where((article) {
      if (keyword.isEmpty) return true;
      final matchText = article.title.toLowerCase().contains(keyword.toLowerCase()) ||
                       article.subtitle.toLowerCase().contains(keyword.toLowerCase());
      return matchText;
    }).toList();
    
    // Bước 2: Áp dụng filter theo category
    final filtered = filterIndex == 0 
        ? searchFiltered
        : ArticleDataProvider.filterByCategory(searchFiltered, filters[filterIndex]);

    if (filtered.isEmpty) {
      return const EmptyStateWidget(title: LikeFilterProvider.emptyArticles);
    }

    if (grid) {
      return GridView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(kDefaultPadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: LikeFilterProvider.gridAspectRatioArticle,
          crossAxisSpacing: kDefaultPadding,
          mainAxisSpacing: kDefaultPadding,
        ),
        itemCount: filtered.length,
        itemBuilder: (context, index) => ArticleCard(
          article: filtered[index],
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
      itemBuilder: (context, index) => ArticleTile(
        article: filtered[index],
        editMode: editMode,
        selected: selectedIds.contains(filtered[index].id),
        onTap: () => onToggleSelect(filtered[index].id),
        onLongPress: () => onToggleSelect(filtered[index].id),
      ),
    );
  }
}
