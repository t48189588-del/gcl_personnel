import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';

class DataImportService {
  /// Picks a JSON file and returns its content as a String.
  /// Returns null if selection was cancelled.
  static Future<String?> pickJsonFile() async {
    // Attempting to use FilePicker.pickFiles
    // If this fails in analysis, it might be due to a version mismatch or environment.
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      return utf8.decode(result.files.single.bytes!);
    }
    return null;
  }

  /// Picks a CSV file and returns its content as a List of Lists.
  /// Returns null if selection was cancelled.
  static Future<List<List<dynamic>>?> pickCsvFile() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      final csvString = utf8.decode(result.files.single.bytes!);
      return const CsvToListConverter().convert(csvString);
    }
    return null;
  }
}
