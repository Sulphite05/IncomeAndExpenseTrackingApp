import 'package:flutter/material.dart';
import 'package:csv/csv.dart';

class CsvDisplayPage extends StatelessWidget {
  final String csvContent;

  CsvDisplayPage({super.key, required this.csvContent});

  List<List<dynamic>> _parseCsvData() {
    return CsvToListConverter().convert(csvContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CSV Viewer')),
      body: Builder(
        builder: (context) {
          final data = _parseCsvData();
          if (data.isEmpty) {
            return Center(child: Text('No data found.'));
          }

          final headers = data.first; // Assuming the first row contains headers
          final rows = data.sublist(1); // The rest are data rows

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: headers
                  .map((header) => DataColumn(label: Text(header.toString())))
                  .toList(),
              rows: rows.map((row) {
                return DataRow(
                  cells: row
                      .map((cell) => DataCell(Text(cell.toString())))
                      .toList(),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
