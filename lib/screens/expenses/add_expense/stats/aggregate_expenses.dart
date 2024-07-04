import 'package:expense_repository/expense_repository.dart';
import 'package:intl/intl.dart';

Map<String, double> aggregateExpensesByDay(List<Expense> expenses) {
  Map<String, double> aggregatedExpenses = {};

  final now = DateTime.now();
  final weekAgo = now.subtract(const Duration(days: 7));

  for (int i = 1; i < 8; i++) {
    final date = weekAgo.add(Duration(days: i));
    final dayLabel = DateFormat('E')
        .format(date); // Change 'EEEE' to 'E' for abbreviated day names
    aggregatedExpenses[dayLabel] = 0.0;
  }

  for (var expense in expenses) {
    if (expense.date.isAfter(weekAgo) &&
        expense.date.isBefore(now.add(const Duration(days: 1)))) {
      String dayLabel = DateFormat('E').format(
          expense.date); // Change 'EEEE' to 'E' for abbreviated day names
      aggregatedExpenses[dayLabel] =
          (aggregatedExpenses[dayLabel] ?? 0) + expense.amount;
    }
  }

  print(aggregatedExpenses);
  return aggregatedExpenses;
}
