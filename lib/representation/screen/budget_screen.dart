import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/helpers/local_storage_helper.dart';
import 'package:flutter_travels_apps/representation/widgets/app_bar_container.dart';

class BudgetScreen extends StatefulWidget {
  static const String routeName = '/budget_screen';
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _category = 'Ăn uống';

  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final data = LocalStorageHelper.getValue('budget_items');
    if (data is List) {
      _items = data.cast<Map<String, dynamic>>();
    }
    setState(() {});
  }

  void _save() {
    LocalStorageHelper.setValue('budget_items', _items);
  }

  int get _total => _items.fold<int>(0, (sum, e) => sum + (e['amount'] as int));

  Map<String, int> get _byCategory {
    final map = <String, int>{};
    for (final e in _items) {
      final c = e['category'] as String;
      final a = e['amount'] as int;
      map[c] = (map[c] ?? 0) + a;
    }
    return map;
  }

  void _addItem() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final amount = int.parse(_amountController.text.trim());
    final note = _noteController.text.trim();
    _items.add({
      'amount': amount,
      'note': note,
      'category': _category,
      'time': DateTime.now().toIso8601String(),
    });
    _amountController.clear();
    _noteController.clear();
    _save();
    setState(() {});
  }

  void _removeItem(int index) {
    _items.removeAt(index);
    _save();
    setState(() {});
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Ngân sách chuyến đi',
      implementLeading: true,
      child: Column(
        children: [
          const SizedBox(height: kMediumPadding),
          _buildSummaryCard(),
          const SizedBox(height: kMediumPadding),
          _buildFormCard(),
          const SizedBox(height: kMediumPadding),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final byCat = _byCategory;
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
            'Tổng chi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            '${_total} đ',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColorPalette.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: byCat.entries
                .map((e) => _chip('${e.key}: ${e.value} đ'))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
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
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _category,
                    decoration: const InputDecoration(
                      labelText: 'Hạng mục',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Ăn uống',
                        child: Text('Ăn uống'),
                      ),
                      DropdownMenuItem(
                        value: 'Di chuyển',
                        child: Text('Di chuyển'),
                      ),
                      DropdownMenuItem(
                        value: 'Lưu trú',
                        child: Text('Lưu trú'),
                      ),
                      DropdownMenuItem(
                        value: 'Giải trí',
                        child: Text('Giải trí'),
                      ),
                      DropdownMenuItem(value: 'Khác', child: Text('Khác')),
                    ],
                    onChanged: (v) =>
                        setState(() => _category = v ?? _category),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Số tiền (đ)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Nhập số tiền';
                      if (int.tryParse(v.trim()) == null) return 'Không hợp lệ';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Ghi chú',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.primaryColor,
                ),
                child: const Text(
                  'Thêm khoản chi',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    if (_items.isEmpty) {
      return const Center(child: Text('Chưa có khoản chi nào.'));
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (context, index) {
        final e = _items[index];
        return Dismissible(
          key: ValueKey(e['time']),
          background: Container(color: Colors.redAccent),
          onDismissed: (_) => _removeItem(index),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 8,
            ),
            title: Text(
              '${e['category']} - ${e['amount']} đ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(e['note'] ?? ''),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _removeItem(index),
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemCount: _items.length,
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: ColorPalette.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: ColorPalette.textColor, fontSize: 12),
      ),
    );
  }
}
