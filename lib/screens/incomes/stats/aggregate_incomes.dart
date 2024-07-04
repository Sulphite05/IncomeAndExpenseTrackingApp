import 'package:income_repository/income_repository.dart';
import 'package:intl/intl.dart';

Map<String, double> aggregateIncomesByDay(List<Income> incomes) {
  Map<String, double> aggregatedIncomes = {};

  final now = DateTime.now();
  final weekAgo = now.subtract(const Duration(days: 7));

  for (int i = 1; i < 8; i++) {
    final date = weekAgo.add(Duration(days: i));
    final dayLabel = DateFormat('E')
        .format(date); // Change 'EEEE' to 'E' for abbreviated day names
    aggregatedIncomes[dayLabel] = 0.0;
  }

  for (var income in incomes) {
    if (income.date.isAfter(weekAgo) &&
        income.date.isBefore(now.add(const Duration(days: 1)))) {
      String dayLabel = DateFormat('E').format(
          income.date); // Change 'EEEE' to 'E' for abbreviated day names
      aggregatedIncomes[dayLabel] =
          (aggregatedIncomes[dayLabel] ?? 0) + income.amount;
    }
  }

  print(aggregatedIncomes);
  return aggregatedIncomes;
}
