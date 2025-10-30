import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/helpers/local_storage_helper.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TravelChecklistScreen extends StatefulWidget {
  static const String routeName = '/travel_checklist_screen';

  final String? tripId;
  final String? tripName;

  const TravelChecklistScreen({Key? key, this.tripId, this.tripName})
    : super(key: key);

  @override
  State<TravelChecklistScreen> createState() => _TravelChecklistScreenState();
}

class _TravelChecklistScreenState extends State<TravelChecklistScreen> {
  String _selectedTemplate = 'Du lịch biển';
  List<ChecklistItem> _items = [];

  // Templates theo loại chuyến đi
  final Map<String, List<String>> _templates = {
    'Du lịch biển': [
      'Áo tắm',
      'Kem chống nắng',
      'Kính râm',
      'Mũ/ nón',
      'Khăn tắm',
      'Dép',
      'Máy ảnh dưới nước',
      'Đồ dùng cá nhân',
    ],
    'Du lịch núi': [
      'Giày leo núi',
      'Áo khoác ấm',
      'Tất dày',
      'Balo',
      'Đèn pin',
      'Bản đồ',
      'Kem chống côn trùng',
      'Thuốc giảm đau',
    ],
    'Du lịch công tác': [
      'Quần áo công sở',
      'Laptop',
      'Sạc điện thoại',
      'Tài liệu công việc',
      'Thẻ tín dụng',
      'Máy tính bảng',
      'Tai nghe',
      'Chứng minh thư',
    ],
    'Du lịch Châu Âu': [
      'Hộ chiếu',
      'Visa',
      'Đổi tiền',
      'Adapter điện',
      'Áo khoác',
      'Giày đi bộ',
      'Máy ảnh',
      'Sim card quốc tế',
    ],
    'Camping/ Cắm trại': [
      'Lều',
      'Túi ngủ',
      'Bếp gas',
      'Đèn pin',
      'Dao',
      'Dây thừng',
      'Bình nước',
      'Thức ăn khô',
    ],
    'Checklist cơ bản': [
      'Giấy tờ tùy thân',
      'Vé máy bay/ tàu',
      'Đặt phòng khách sạn',
      'Tiền mặt',
      'Thẻ tín dụng',
      'Máy ảnh',
      'Sạc điện thoại',
      'Quần áo',
      'Giày dép',
      'Thuốc men',
      'Vật dụng vệ sinh',
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadChecklist();
  }

  void _loadChecklist() {
    final savedItems = LocalStorageHelper.getValue(
      'checklist_${widget.tripId ?? "default"}',
    );
    if (savedItems != null && savedItems is List) {
      _items = savedItems
          .map((item) => ChecklistItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      // Load từ template
      _loadTemplate();
    }
    setState(() {});
  }

  void _loadTemplate() {
    final templateItems = _templates[_selectedTemplate] ?? [];
    _items = templateItems.map((name) => ChecklistItem(name: name)).toList();
  }

  void _saveChecklist() {
    LocalStorageHelper.setValue(
      'checklist_${widget.tripId ?? "default"}',
      _items.map((item) => item.toJson()).toList(),
    );
  }

  void _addCustomItem(String name) {
    setState(() {
      _items.add(ChecklistItem(name: name));
      _saveChecklist();
    });
  }

  void _toggleItem(int index) {
    setState(() {
      _items[index].isChecked = !_items[index].isChecked;
      _saveChecklist();
    });
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
      _saveChecklist();
    });
  }

  void _changeTemplate(String template) {
    setState(() {
      _selectedTemplate = template;
      _loadTemplate();
      _saveChecklist();
    });
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _items.where((item) => item.isChecked).length;
    final totalCount = _items.length;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return AppBarContainerWidget(
      titleString: widget.tripName != null
          ? 'Checklist: ${widget.tripName}'
          : 'Checklist Trước Khi Đi',
      implementLeading: true,
      child: Column(
        children: [
          const SizedBox(height: kMediumPadding),

          // Progress Card
          _buildProgressCard(completedCount, totalCount, progress),

          const SizedBox(height: kMediumPadding),

          // Template Selector
          _buildTemplateSelector(),

          const SizedBox(height: kMediumPadding),

          // Checklist Items
          Expanded(child: _buildChecklistList()),

          // Add Item Button
          Container(
            margin: const EdgeInsets.all(kMediumPadding),
            child: ElevatedButton.icon(
              onPressed: _showAddItemDialog,
              icon: const Icon(Icons.add),
              label: const Text('Thêm mục tùy chỉnh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: kMediumPadding,
                  vertical: kDefaultPadding,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: kDefaultBorderRadius,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(int completed, int total, double progress) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      padding: const EdgeInsets.all(kMediumPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tiến độ chuẩn bị',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.textColor,
                ),
              ),
              Text(
                '$completed/$total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: progress == 1.0
                      ? Colors.green
                      : ColorPalette.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 1.0 ? Colors.green : ColorPalette.primaryColor,
              ),
            ),
          ),
          if (progress == 1.0)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 6),
                  const Text(
                    'Sẵn sàng lên đường!',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTemplateSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      padding: const EdgeInsets.all(kMediumPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chọn template',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorPalette.textColor,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _templates.keys.map((template) {
              final isSelected = template == _selectedTemplate;
              return GestureDetector(
                onTap: () => _changeTemplate(template),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ColorPalette.primaryColor
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? ColorPalette.primaryColor
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    template,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistList() {
    if (_items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.listCheck, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Chưa có mục nào trong checklist',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Chọn template hoặc thêm mục tùy chỉnh',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return Dismissible(
          key: ValueKey(item.name + index.toString()),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => _deleteItem(index),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: CheckboxListTile(
              value: item.isChecked,
              onChanged: (value) => _toggleItem(index),
              title: Text(
                item.name,
                style: TextStyle(
                  fontSize: 16,
                  decoration: item.isChecked
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: item.isChecked
                      ? Colors.grey[500]
                      : ColorPalette.textColor,
                ),
              ),
              activeColor: ColorPalette.primaryColor,
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
        );
      },
    );
  }

  void _showAddItemDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm mục mới'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Nhập tên mục cần chuẩn bị...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  _addCustomItem(controller.text.trim());
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.primaryColor,
              ),
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );
  }
}

class ChecklistItem {
  final String name;
  bool isChecked;

  ChecklistItem({required this.name, this.isChecked = false});

  Map<String, dynamic> toJson() {
    return {'name': name, 'isChecked': isChecked};
  }

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      name: json['name'] as String,
      isChecked: json['isChecked'] as bool? ?? false,
    );
  }
}
