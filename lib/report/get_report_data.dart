import 'package:expense_repository/expense_repository.dart';
import 'package:income_repository/income_repository.dart';

class MonthlyReport {
  final int totalIncome;
  final int totalExpense;

  MonthlyReport({required this.totalIncome, required this.totalExpense});
}

Future<MonthlyReport> generateMonthlyReport(
    String userId, int year, int month) async {
  DateTime startDate = DateTime(year, month, 1);
  DateTime endDate = DateTime(year, month + 1, 0);

  List<ExpenseEntity> expenses = await FirebaseExpenseRepo()
      .fetchMonthlyExpenses(userId, startDate, endDate);
  List<IncomeEntity> incomes = await FirebaseIncomeRepo()
      .fetchMonthlyIncomes(userId, startDate, endDate);

  int totalIncome = incomes.fold(0, (sum, item) => sum + item.amount); //aggregation
  int totalExpense = expenses.fold(0, (sum, item) => sum + item.amount);

  return MonthlyReport(totalIncome: totalIncome, totalExpense: totalExpense);
}
