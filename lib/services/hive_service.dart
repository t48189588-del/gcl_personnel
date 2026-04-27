import 'package:hive_flutter/hive_flutter.dart';
import '../models/models.dart';
import 'logger_service.dart';

class HiveService {
  static const String staffBoxName = 'staff_box';
  static const String blocksBoxName = 'blocks_box';
  static const String configBoxName = 'config_box';
  static const String reportsBoxName = 'reports_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(staffBoxName);
    await Hive.openBox(blocksBoxName);
    await Hive.openBox(configBoxName);
    await Hive.openBox(reportsBoxName);
    await LoggerService.init();

    // Seed mock data if empty
    var staffBox = Hive.box(staffBoxName);
    if (staffBox.isEmpty) {
      for (int i = 1; i <= 20; i++) {
        var staff = StaffMember.createMock(i);
        staffBox.put(staff.id, staff.toJson());
      }
    }

    var configBox = Hive.box(configBoxName);
    if (configBox.isEmpty) {
      configBox.put('hours', OperatingHours(
        weeklySchedule: List.generate(7, (index) => DaySchedule(weekday: index + 1))
      ).toJson());
    }
  }

  // Staff
  static List<StaffMember> getStaff() {
    var box = Hive.box(staffBoxName);
    return box.values.map((e) => StaffMember.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  static void saveStaff(StaffMember staff) {
    var box = Hive.box(staffBoxName);
    box.put(staff.id, staff.toJson());
  }

  // Blocks
  static List<AvailabilityBlock> getBlocks() {
    var box = Hive.box(blocksBoxName);
    return box.values.map((e) => AvailabilityBlock.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  static void saveBlock(AvailabilityBlock block) {
    var box = Hive.box(blocksBoxName);
    box.put(block.id, block.toJson());
  }

  static void removeBlock(String id) {
    var box = Hive.box(blocksBoxName);
    box.delete(id);
  }

  // Config
  static OperatingHours getOperatingHours() {
    var box = Hive.box(configBoxName);
    var data = box.get('hours');
    if (data == null) {
      return OperatingHours(
        weeklySchedule: List.generate(7, (index) => DaySchedule(weekday: index + 1))
      );
    }
    return OperatingHours.fromJson(Map<String, dynamic>.from(data as Map));
  }

  static void saveOperatingHours(OperatingHours hours) {
    var box = Hive.box(configBoxName);
    box.put('hours', hours.toJson());
  }

  // Reports
  static List<WorkingReport> getReports() {
    var box = Hive.box(reportsBoxName);
    return box.values.map((e) => WorkingReport.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  static void saveReport(WorkingReport report) {
    var box = Hive.box(reportsBoxName);
    box.put(report.id, report.toJson());
  }
}
