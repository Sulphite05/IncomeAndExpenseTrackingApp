import 'package:expense_repository/expense_repository.dart';

abstract class ExpenseRepository {
  Future<void> createCategory(ExpCategory category);    // Create

  Future<List<ExpCategory>> getCategory();              // Read

  Future<void> deleteCategory(String categoryId);       // Update

  Future<void> updateCategory(ExpCategory category);    // Delete

  // The CRUD Commands

  Future<void> createExpense(Expense expense);          // Create

  Stream<List<Expense>> getExpenses();                  // Read

  Future<void> updateExpense(Expense expense);          // Update

  Future<void> deleteExpense(String expenseId);         // Delete
}
