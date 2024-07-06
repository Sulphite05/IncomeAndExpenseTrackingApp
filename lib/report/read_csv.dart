import 'dart:io';
import 'dart:developer' show log;

Future<String> readCsvFileContent(File file) async {
  try {
    if (await file.exists()) {
      return await file.readAsString();
    } else {
      throw Exception("File not found");
    }
  } catch (e) {
    log('Error reading CSV file: $e');
    return '';
  }
}
