import 'package:expense_repository/expense_repository.dart';

abstract class ExpenseRepository {
  Future<void> createCategory(ExpCategory category); // Create

  Stream<List<ExpCategory>> getCategories(
      {String? categoryId}); // Read All

  Future<void> deleteCategory(String categoryId); // Update

  Future<void> updateCategory(ExpCategory category); // Delete

  // The CRUD Commands

  Future<void> createExpense(Expense expense); // Create

  Stream<List<Expense>> getExpenses({String? categoryId, DateTime? startDate, DateTime? endDate}); // Read All

  Future<void> updateExpense(Expense expense); // Update

  Future<void> deleteExpense(String expenseId); // Delete
}
