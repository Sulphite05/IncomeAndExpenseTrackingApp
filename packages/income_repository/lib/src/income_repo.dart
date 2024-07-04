
import 'package:income_repository/income_repository.dart';

abstract class IncomeRepository {
  Future<void> createCategory(IncCategory category); // Create

  Stream<List<IncCategory>> getCategories(
      {String? categoryId}); // Read All

  Future<void> deleteCategory(String categoryId); // Update

  Future<void> updateCategory(IncCategory category); // Delete

  // The CRUD Commands

  Future<void> createIncome(Income income); // Create

  Stream<List<Income>> getIncomes({String? categoryId}); // Read All

  Future<void> updateIncome(Income income); // Update

  Future<void> deleteIncome(String incomeId); // Delete
}
