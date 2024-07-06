import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> readCsvFileContent(File file) async {
  try {

    if (await file.exists()) {
      return await file.readAsString();
    } else {
      throw Exception("File not found");
    }
  } catch (e) {
    print('Error reading CSV file: $e');
    return '';
  }
}
