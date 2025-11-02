import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:flutter_travels_apps/representation/widgets/common/app_bar_container.dart';
import 'package:flutter_travels_apps/representation/widgets/common/empty_state_widget.dart';
import 'package:flutter_travels_apps/data/models/packing_item_model.dart';
import 'package:flutter_travels_apps/services/packing_checklist_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PackingChecklistScreen extends StatefulWidget {
  static const String routeName = '/packing_checklist_screen';

  final String tripPlanId;

  const PackingChecklistScreen({super.key, required this.tripPlanId});

  @override
  State<PackingChecklistScreen> createState() => _PackingChecklistScreenState();
}

class _PackingChecklistScreenState extends State<PackingChecklistScreen> {
  final PackingChecklistService _checklistService = PackingChecklistService();
  PackingItemType? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Checklist hành lý',
      implementLeading: true,
      child: Column(
        children: [
          // Filter chips
          _buildFilterChips(),
          SizedBox(height: kDefaultPadding),
          // Checklist items
          Expanded(child: _buildChecklistItems()),
          // Add item button
          _buildAddItemButton(),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          FilterChip(
            label: Text('Tất cả'),
            selected: _selectedCategory == null,
            onSelected: (selected) {
              setState(() => _selectedCategory = null);
            },
          ),
          SizedBox(width: kItemPadding),
          ...PackingItemType.values.map(
            (type) => Padding(
              padding: EdgeInsets.only(right: kItemPadding),
              child: FilterChip(
                label: Text(type.label),
                selected: _selectedCategory == type,
                onSelected: (selected) {
                  setState(() => _selectedCategory = selected ? type : null);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItems() {
    return StreamBuilder<List<PackingItemModel>>(
      stream: _checklistService.getChecklistStream(widget.tripPlanId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        }

        final items = snapshot.data ?? [];
        final filteredItems = _selectedCategory == null
            ? items
            : items.where((item) => item.type == _selectedCategory).toList();

        if (filteredItems.isEmpty) {
          return const EmptyStateWidget(
            icon: FontAwesomeIcons.suitcase,
            title: 'Checklist trống',
            subtitle: 'Thêm items hoặc tạo từ template',
            iconSize: 64,
          );
        }

        // Group by type
        final Map<PackingItemType, List<PackingItemModel>> grouped = {};
        for (var item in filteredItems) {
          grouped.putIfAbsent(item.type, () => []).add(item);
        }

        return ListView.builder(
          padding: EdgeInsets.all(kDefaultPadding),
          itemCount: grouped.length,
          itemBuilder: (context, index) {
            final category = grouped.keys.toList()[index];
            final categoryItems = grouped[category]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_selectedCategory == null)
                  Padding(
                    padding: EdgeInsets.only(bottom: kItemPadding),
                    child: Text(
                      category.label,
                      style: TextStyles.defaultStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.textColor,
                      ),
                    ),
                  ),
                ...categoryItems.map((item) => _buildItemCard(item)),
                SizedBox(height: kItemPadding),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildItemCard(PackingItemModel item) {
    return Card(
      margin: EdgeInsets.only(bottom: kItemPadding),
      child: CheckboxListTile(
        value: item.isChecked,
        onChanged: (value) async {
          try {
            await _checklistService.toggleItem(item.id);
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Lỗi: ${e.toString()}')));
          }
        },
        title: Text(
          item.name,
          style: TextStyles.defaultStyle.copyWith(
            decoration: item.isChecked
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: item.isChecked
                ? ColorPalette.subTitleColor
                : ColorPalette.textColor,
          ),
        ),
        subtitle: Row(
          children: [
            if (item.quantity > 1)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ColorPalette.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'x${item.quantity}',
                  style: TextStyles.defaultStyle.copyWith(
                    fontSize: 12,
                    color: ColorPalette.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (item.notes != null && item.notes!.isNotEmpty) ...[
              SizedBox(width: 8),
              Icon(Icons.note, size: 16, color: ColorPalette.subTitleColor),
            ],
          ],
        ),
        secondary: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, size: 20),
              onPressed: () {
                // TODO: Show edit item dialog
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, size: 20, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Xóa item'),
                    content: Text('Bạn có chắc muốn xóa "${item.name}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Hủy'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('Xóa', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  try {
                    await _checklistService.deleteItem(item.id);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi: ${e.toString()}')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddItemButton() {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Show create from template dialog
                _showTemplateDialog();
              },
              icon: Icon(FontAwesomeIcons.list),
              label: Text('Template'),
              style: OutlinedButton.styleFrom(
                foregroundColor: ColorPalette.primaryColor,
                side: BorderSide(color: ColorPalette.primaryColor),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kTopPadding),
                ),
              ),
            ),
          ),
          SizedBox(width: kItemPadding),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Show add custom item dialog
                _showAddItemDialog();
              },
              icon: Icon(FontAwesomeIcons.plus),
              label: Text('Thêm mới'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kTopPadding),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTemplateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tạo checklist từ template'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TripType.values
              .map(
                (type) => ListTile(
                  title: Text(type.label),
                  onTap: () async {
                    Navigator.pop(context);
                    try {
                      await _checklistService.createChecklistFromTemplate(
                        widget.tripPlanId,
                        type,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Đã tạo checklist từ template')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lỗi: ${e.toString()}')),
                      );
                    }
                  },
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thêm item mới'),
        content: Text('Tính năng đang phát triển...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
