import 'package:expense_repository/expense_repository.dart';

abstract class ExpenseRepository {
  Future<void> createCategory(ExpCategory category);

  Future<List<ExpCategory>> getCategory();

  Future<void> createExpense(Expense expense);

  Future<List<Expense>> getExpenses();
}
