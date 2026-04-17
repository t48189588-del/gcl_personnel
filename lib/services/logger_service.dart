import 'package:hive_flutter/hive_flutter.dart';
import '../models/models.dart';

class LoggerService {
  static const String logsBoxName = 'logs_box';

  static Future<void> init() async {
    await Hive.openBox(logsBoxName);
  }

  static void log(String eventType, String description) {
    var box = Hive.box(logsBoxName);
    var entry = LogEntry(
      timestamp: DateTime.now(),
      eventType: eventType,
      description: description,
    );
    box.add(entry.toJson());
  }

  static List<LogEntry> getLogs() {
    var box = Hive.box(logsBoxName);
    return box.values.map((e) => LogEntry.fromJson(Map<String, dynamic>.from(e as Map))).toList()
    ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  static void clearLogs() {
    var box = Hive.box(logsBoxName);
    box.clear();
  }
}
