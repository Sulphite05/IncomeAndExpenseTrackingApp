import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:developer' show log;
import 'report.dart';

Future<File> generateCsvReport(
    MonthlyReport report, String userId, DateTime month) async {
  List<List<dynamic>> rows = [
    ["Month", "Total Income", "Total Expense", "Total Balance"],
    [
      "${month.year}-${month.month}",
      report.totalIncome,
      report.totalExpense,
      report.totalIncome - report.totalExpense,
    ],
  ];

  String csv = const ListToCsvConverter().convert(rows);

  final directory = await getApplicationDocumentsDirectory();
  log(directory.path);
  final path =
      "${directory.path}/report_${userId}_${month.year}_${month.month}.csv";
  final file = File(path);

  return file.writeAsString(csv);
}
