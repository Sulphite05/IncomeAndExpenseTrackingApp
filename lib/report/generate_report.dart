import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:developer' show log;
import 'get_report_data.dart';

Future<File> generateCsvReport(String userId, int year) async {
  List<List<dynamic>> rows = [
    ["Month", "Total Income", "Total Expense", "Total Balance"],
  ];

  for (int monthIndex = 1; monthIndex <= 12; monthIndex++) {
    MonthlyReport report = await generateMonthlyReport(
        userId, year, monthIndex);
    rows.add([
      "$year-$monthIndex",
      report.totalIncome,
      report.totalExpense,
      report.totalIncome - report.totalExpense,
    ]);
  }

  String csv = const ListToCsvConverter().convert(rows);

  final directory = await getApplicationDocumentsDirectory();
  log(directory.path);
  final path = "${directory.path}/report_${userId}_$year.csv";
  final file = File(path);
  return file.writeAsString(csv);
}
