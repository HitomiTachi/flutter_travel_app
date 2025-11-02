import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/color_constants.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/core/constants/textstyle_constants.dart';
import 'package:flutter_travels_apps/representation/widgets/common/app_bar_container.dart';
import 'package:flutter_travels_apps/representation/widgets/common/empty_state_widget.dart';
import 'package:flutter_travels_apps/data/models/expense_model.dart';
import 'package:flutter_travels_apps/data/models/trip_plan_detail_model.dart';
import 'package:flutter_travels_apps/services/budget_service.dart';
import 'package:flutter_travels_apps/services/trip_plan_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class TripBudgetScreen extends StatefulWidget {
  static const String routeName = '/trip_budget_screen';

  final String tripPlanId;

  const TripBudgetScreen({super.key, required this.tripPlanId});

  @override
  State<TripBudgetScreen> createState() => _TripBudgetScreenState();
}

class _TripBudgetScreenState extends State<TripBudgetScreen> {
  final BudgetService _budgetService = BudgetService();
  final TripPlanService _tripPlanService = TripPlanService();
  int _selectedDay = 0; // 0 = all days
  ExpenseCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Quản lý ngân sách',
      implementLeading: true,
      child: StreamBuilder<TripPlanDetailModel?>(
        stream: _tripPlanService.getTripPlanStream(widget.tripPlanId),
        builder: (context, tripPlanSnapshot) {
          if (!tripPlanSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final tripPlan = tripPlanSnapshot.data;
          if (tripPlan == null) {
            return Center(child: Text('Không tìm thấy kế hoạch'));
          }

          return Column(
            children: [
              // Budget summary card
              _buildBudgetSummaryCard(tripPlan),
              SizedBox(height: kDefaultPadding),
              // Filters
              _buildFilters(),
              SizedBox(height: kDefaultPadding),
              // Expenses list
              Expanded(child: _buildExpensesList(tripPlan)),
              // Add expense button
              _buildAddExpenseButton(tripPlan),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBudgetSummaryCard(TripPlanDetailModel tripPlan) {
    return StreamBuilder<double>(
      stream: _budgetService.getTotalSpending(widget.tripPlanId).asStream(),
      builder: (context, spendingSnapshot) {
        final totalSpending = spendingSnapshot.data ?? 0.0;
        final remainingBudget = tripPlan.budget - totalSpending;
        final percentage = tripPlan.budget > 0
            ? (totalSpending / tripPlan.budget).clamp(0.0, 1.0)
            : 0.0;
        final isOverBudget = totalSpending > tripPlan.budget;

        return Container(
          margin: EdgeInsets.all(kDefaultPadding),
          padding: EdgeInsets.all(kDefaultPadding * 1.5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isOverBudget
                  ? [Colors.red.shade400, Colors.red.shade600]
                  : [ColorPalette.primaryColor, ColorPalette.secondColor],
            ),
            borderRadius: BorderRadius.circular(kTopPadding),
            boxShadow: [
              BoxShadow(
                color: (isOverBudget ? Colors.red : ColorPalette.primaryColor)
                    .withOpacity(0.3),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ngân sách',
                    style: TextStyles.defaultStyle.copyWith(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  if (isOverBudget)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning, size: 16, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            'Vượt ngân sách',
                            style: TextStyles.defaultStyle.copyWith(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(height: kItemPadding),
              Text(
                NumberFormat('#,###').format(tripPlan.budget) + ' VNĐ',
                style: TextStyles.defaultStyle.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: kDefaultPadding),
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: percentage,
                  minHeight: 8,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    percentage > 1.0 ? Colors.red : Colors.white,
                  ),
                ),
              ),
              SizedBox(height: kDefaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đã chi',
                        style: TextStyles.defaultStyle.copyWith(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        NumberFormat('#,###').format(totalSpending) + ' VNĐ',
                        style: TextStyles.defaultStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        isOverBudget ? 'Vượt quá' : 'Còn lại',
                        style: TextStyles.defaultStyle.copyWith(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        NumberFormat('#,###').format(
                              isOverBudget ? -remainingBudget : remainingBudget,
                            ) +
                            ' VNĐ',
                        style: TextStyles.defaultStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilters() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<int>(
              value: _selectedDay,
              decoration: InputDecoration(
                labelText: 'Ngày',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kItemPadding),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: kItemPadding,
                  vertical: kItemPadding,
                ),
              ),
              items: [
                DropdownMenuItem(value: 0, child: Text('Tất cả các ngày')),
                // TODO: Generate days from trip plan
                DropdownMenuItem(value: 1, child: Text('Ngày 1')),
                DropdownMenuItem(value: 2, child: Text('Ngày 2')),
              ],
              onChanged: (value) {
                setState(() => _selectedDay = value ?? 0);
              },
            ),
          ),
          SizedBox(width: kItemPadding),
          Expanded(
            child: DropdownButtonFormField<ExpenseCategory?>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Loại',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kItemPadding),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: kItemPadding,
                  vertical: kItemPadding,
                ),
              ),
              items: [
                DropdownMenuItem<ExpenseCategory?>(
                  value: null,
                  child: Text('Tất cả'),
                ),
                ...ExpenseCategory.values.map(
                  (category) => DropdownMenuItem<ExpenseCategory?>(
                    value: category,
                    child: Text(category.label),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() => _selectedCategory = value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesList(TripPlanDetailModel tripPlan) {
    return StreamBuilder<List<ExpenseModel>>(
      stream: _selectedDay == 0
          ? _budgetService.getExpensesStream(widget.tripPlanId)
          : _budgetService.getExpensesByDayStream(
              widget.tripPlanId,
              _selectedDay,
            ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        }

        final expenses = snapshot.data ?? [];
        final filteredExpenses = _selectedCategory == null
            ? expenses
            : expenses.where((e) => e.category == _selectedCategory).toList();

        if (filteredExpenses.isEmpty) {
          return const EmptyStateWidget(
            icon: FontAwesomeIcons.receipt,
            title: 'Chưa có chi tiêu nào',
            subtitle: 'Thêm chi phí để theo dõi ngân sách chuyến đi',
            iconSize: 64,
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(kDefaultPadding),
          itemCount: filteredExpenses.length,
          itemBuilder: (context, index) {
            return _buildExpenseCard(filteredExpenses[index]);
          },
        );
      },
    );
  }

  Widget _buildExpenseCard(ExpenseModel expense) {
    return Card(
      margin: EdgeInsets.only(bottom: kItemPadding),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: ColorPalette.primaryColor.withOpacity(0.1),
          child: Icon(
            _getCategoryIcon(expense.category),
            color: ColorPalette.primaryColor,
          ),
        ),
        title: Text(expense.description),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(expense.category.label),
            Text(
              DateFormat('dd/MM/yyyy HH:mm').format(expense.expenseDate),
              style: TextStyles.defaultStyle.copyWith(
                fontSize: 12,
                color: ColorPalette.subTitleColor,
              ),
            ),
          ],
        ),
        trailing: Text(
          NumberFormat('#,###').format(expense.amount) + ' VNĐ',
          style: TextStyles.defaultStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorPalette.primaryColor,
          ),
        ),
        onTap: () {
          // TODO: Show edit expense dialog
        },
      ),
    );
  }

  IconData _getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.transport:
        return FontAwesomeIcons.car;
      case ExpenseCategory.accommodation:
        return FontAwesomeIcons.bed;
      case ExpenseCategory.dining:
        return FontAwesomeIcons.utensils;
      case ExpenseCategory.sightseeing:
        return FontAwesomeIcons.camera;
      case ExpenseCategory.shopping:
        return FontAwesomeIcons.bagShopping;
      case ExpenseCategory.entertainment:
        return FontAwesomeIcons.gamepad;
      case ExpenseCategory.other:
        return FontAwesomeIcons.tag;
    }
  }

  Widget _buildAddExpenseButton(TripPlanDetailModel tripPlan) {
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
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            // TODO: Show add expense dialog
            _showAddExpenseDialog(tripPlan);
          },
          icon: Icon(FontAwesomeIcons.plus),
          label: Text('Thêm chi tiêu'),
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
    );
  }

  void _showAddExpenseDialog(TripPlanDetailModel tripPlan) {
    // TODO: Implement add expense dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thêm chi tiêu'),
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
