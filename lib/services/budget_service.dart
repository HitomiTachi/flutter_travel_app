import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/models/expense_model.dart';
import 'trip_plan_service.dart';

class BudgetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TripPlanService _tripPlanService = TripPlanService();

  // Tạo expense
  Future<String> createExpense({
    required String tripPlanId,
    required int day,
    required String description,
    required double amount,
    required ExpenseCategory category,
    required DateTime expenseDate,
    String? activityId,
    String? notes,
    String? receiptImageUrl,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final expense = ExpenseModel(
      id: '', // Sẽ được tạo tự động
      tripPlanId: tripPlanId,
      day: day,
      activityId: activityId,
      description: description,
      amount: amount,
      category: category,
      expenseDate: expenseDate,
      notes: notes,
      receiptImageUrl: receiptImageUrl,
      createdAt: DateTime.now(),
    );

    final docRef = await _firestore
        .collection('expenses')
        .add(expense.toFirestore());

    // Cập nhật actualSpent của trip plan
    await _updateTripPlanSpending(tripPlanId);

    return docRef.id;
  }

  // Cập nhật expense
  Future<void> updateExpense(
    String expenseId, {
    String? description,
    double? amount,
    ExpenseCategory? category,
    DateTime? expenseDate,
    String? notes,
    String? receiptImageUrl,
  }) async {
    final expenseDoc = await _firestore
        .collection('expenses')
        .doc(expenseId)
        .get();

    if (!expenseDoc.exists) throw Exception('Expense not found');

    final expense = ExpenseModel.fromFirestore(expenseDoc);

    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (description != null) updates['description'] = description;
    if (amount != null) updates['amount'] = amount;
    if (category != null) updates['category'] = category.firestoreValue;
    if (expenseDate != null) {
      updates['expenseDate'] = Timestamp.fromDate(expenseDate);
    }
    if (notes != null) updates['notes'] = notes;
    if (receiptImageUrl != null) updates['receiptImageUrl'] = receiptImageUrl;

    await _firestore.collection('expenses').doc(expenseId).update(updates);

    // Cập nhật actualSpent của trip plan
    await _updateTripPlanSpending(expense.tripPlanId);
  }

  // Xóa expense
  Future<void> deleteExpense(String expenseId) async {
    final expenseDoc = await _firestore
        .collection('expenses')
        .doc(expenseId)
        .get();

    if (!expenseDoc.exists) throw Exception('Expense not found');

    final expense = ExpenseModel.fromFirestore(expenseDoc);

    await _firestore.collection('expenses').doc(expenseId).delete();

    // Cập nhật actualSpent của trip plan
    await _updateTripPlanSpending(expense.tripPlanId);
  }

  // Lấy expenses theo trip plan
  Stream<List<ExpenseModel>> getExpensesStream(String tripPlanId) {
    return _firestore
        .collection('expenses')
        .where('tripPlanId', isEqualTo: tripPlanId)
        .orderBy('expenseDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ExpenseModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Lấy expenses theo ngày
  Stream<List<ExpenseModel>> getExpensesByDayStream(
    String tripPlanId,
    int day,
  ) {
    return _firestore
        .collection('expenses')
        .where('tripPlanId', isEqualTo: tripPlanId)
        .where('day', isEqualTo: day)
        .orderBy('expenseDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ExpenseModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Lấy expenses theo category
  Stream<Map<ExpenseCategory, List<ExpenseModel>>> getExpensesByCategoryStream(
    String tripPlanId,
  ) {
    return _firestore
        .collection('expenses')
        .where('tripPlanId', isEqualTo: tripPlanId)
        .snapshots()
        .map((snapshot) {
          final expenses = snapshot.docs
              .map((doc) => ExpenseModel.fromFirestore(doc))
              .toList();

          final Map<ExpenseCategory, List<ExpenseModel>> grouped = {};
          for (var expense in expenses) {
            grouped.putIfAbsent(expense.category, () => []).add(expense);
          }

          return grouped;
        });
  }

  // Tính tổng chi tiêu theo category
  Future<Map<ExpenseCategory, double>> getTotalByCategory(
    String tripPlanId,
  ) async {
    final snapshot = await _firestore
        .collection('expenses')
        .where('tripPlanId', isEqualTo: tripPlanId)
        .get();

    final Map<ExpenseCategory, double> totals = {};
    for (var doc in snapshot.docs) {
      final expense = ExpenseModel.fromFirestore(doc);
      totals[expense.category] =
          (totals[expense.category] ?? 0.0) + expense.amount;
    }

    return totals;
  }

  // Tính tổng chi tiêu
  Future<double> getTotalSpending(String tripPlanId) async {
    final snapshot = await _firestore
        .collection('expenses')
        .where('tripPlanId', isEqualTo: tripPlanId)
        .get();

    double total = 0.0;
    for (var doc in snapshot.docs) {
      final expense = ExpenseModel.fromFirestore(doc);
      total += expense.amount;
    }

    return total;
  }

  // Cập nhật actualSpent của trip plan
  Future<void> _updateTripPlanSpending(String tripPlanId) async {
    final totalSpending = await getTotalSpending(tripPlanId);

    await _firestore.collection('trip_plans').doc(tripPlanId).update({
      'actualSpent': totalSpending,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Kiểm tra vượt ngân sách
  Future<bool> isOverBudget(String tripPlanId) async {
    final tripPlan = await _tripPlanService.getTripPlan(tripPlanId);
    if (tripPlan == null) return false;

    final totalSpending = await getTotalSpending(tripPlanId);
    return totalSpending > tripPlan.budget;
  }

  // Lấy cảnh báo ngân sách
  Future<Map<String, dynamic>> getBudgetAlert(String tripPlanId) async {
    final tripPlan = await _tripPlanService.getTripPlan(tripPlanId);
    if (tripPlan == null) {
      return {'isOverBudget': false, 'remainingBudget': 0.0, 'percentage': 0.0};
    }

    final totalSpending = await getTotalSpending(tripPlanId);
    final remainingBudget = tripPlan.budget - totalSpending;
    final percentage = (totalSpending / tripPlan.budget).clamp(0.0, 1.0);
    final isOverBudget = totalSpending > tripPlan.budget;

    return {
      'isOverBudget': isOverBudget,
      'remainingBudget': remainingBudget,
      'percentage': percentage,
      'totalSpending': totalSpending,
      'budget': tripPlan.budget,
    };
  }
}
