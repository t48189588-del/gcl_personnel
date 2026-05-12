import 'package:excel/excel.dart';
import 'package:web/web.dart' as web;
import 'dart:convert';
import '../models/models.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';

class ExcelService {
  static void exportStaffData(List<StaffMember> staff, AppLocalizations loc) {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Staff Information'];
    excel.delete('Sheet1'); // Remove default sheet

    // Add headers
    List<String> headers = [
      loc.name,
      loc.nativeLang,
      loc.fluentLanguages,
      loc.degree,
      loc.modality,
      loc.availRate,
      loc.eventsPart,
      loc.assistance,
      loc.commPreference
    ];
    
    sheetObject.appendRow(headers.map((e) => TextCellValue(e)).toList());

    for (var s in staff) {
      List<CellValue> row = [
        TextCellValue(s.name),
        TextCellValue(s.nativeLanguage),
        TextCellValue(s.fluentLanguages.join(', ')),
        TextCellValue(_translateValue(s.degree, loc)),
        TextCellValue(_translateValue(s.modalityPreference, loc)),
        DoubleCellValue(s.availabilityRate),
        IntCellValue(s.eventsParticipation),
        IntCellValue(s.providedAssistance),
        TextCellValue(s.commPreference),
      ];
      sheetObject.appendRow(row);
    }

    var fileBytes = excel.save();
    if (fileBytes != null) {
      _downloadExcelWeb(fileBytes, "Staff_Metrics.xlsx");
    }
  }

  static void exportMasterCalendarMonthly(DateTime month, List<StaffMember> juniorStaff, List<AvailabilityBlock> allBlocks, AppLocalizations loc) {
    var excel = Excel.createExcel();
    String sheetName = DateFormat('MMMM yyyy').format(month);
    Sheet sheetObject = excel[sheetName];
    excel.delete('Sheet1');

    // Headers: Column 1: Date, Column 2: Time, C3 onwards: Junior Staff Names
    List<CellValue> headers = [
      TextCellValue(loc.day),
      TextCellValue(loc.startTime),
    ];
    for (var staff in juniorStaff) {
      headers.add(TextCellValue('${staff.name} (${staff.kanaName})'));
    }
    sheetObject.appendRow(headers);

    // Get days in month
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    
    // Time slots (09:00 to 17:00 as prototype standard)
    List<String> timeSlots = [];
    for (int h = 9; h < 17; h++) {
      timeSlots.add('${h.toString().padLeft(2, '0')}:00');
      timeSlots.add('${h.toString().padLeft(2, '0')}:30');
    }

    for (int day = 1; day <= daysInMonth; day++) {
      DateTime currentDate = DateTime(month.year, month.month, day);
      String dateStr = DateFormat('yyyy-MM-dd').format(currentDate);

      for (var timeSlot in timeSlots) {
        List<CellValue> row = [
          TextCellValue(day == 1 && timeSlot == timeSlots.first ? dateStr : (timeSlot == timeSlots.first ? dateStr : '')),
          TextCellValue(timeSlot),
        ];

        // Fill staff columns
        for (var staff in juniorStaff) {
          // Find if there's a block for this staff, date, and time
          var blocks = allBlocks.where((b) => 
            b.staffId == staff.id && 
            b.startTime.year == currentDate.year &&
            b.startTime.month == currentDate.month &&
            b.startTime.day == currentDate.day &&
            DateFormat('HH:mm').format(b.startTime) == timeSlot
          ).toList();

          if (blocks.isNotEmpty) {
            var block = blocks.first;
            String symbol = '';
            if (block.modality == 'Online') {
              symbol = '○ (${loc.online})';
            } else if (block.modality == 'Both') {
              symbol = '○ (${loc.both})';
            } else {
              symbol = '(${loc.inPerson})';
            }
            
            row.add(TextCellValue(symbol));
            // Excel styling is complex in raw library without a cell reference, 
            // but for PoC we use descriptive text as per "filled with circle for online, highlight for in person".
          } else {
            row.add(TextCellValue(''));
          }
        }
        sheetObject.appendRow(row);
      }
    }

    var fileBytes = excel.save();
    if (fileBytes != null) {
      _downloadExcelWeb(fileBytes, "Master_Calendar_${sheetName.replaceAll(' ', '_')}.xlsx");
    }
  }

  static void exportWorkingReports(StaffMember staff, List<WorkingReport> reports, AppLocalizations loc) {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel[loc.workingReports];
    excel.delete('Sheet1');

    // Header: Name, Kana and Affiliation
    sheetObject.appendRow([
      TextCellValue('${loc.name}: ${staff.name} (${staff.kanaName})'),
      TextCellValue('${loc.affiliation}: ${staff.affiliation}'),
    ]);
    sheetObject.appendRow([]); // Spacer

    // Table Headers
    List<String> headers = [
      loc.day,
      loc.reportDate,
      loc.scheduledTime,
      loc.confirmedStartTime,
      loc.workedHours,
      loc.workDoneLabel
    ];
    sheetObject.appendRow(headers.map((e) => TextCellValue(e)).toList());

    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('yyyy-MM-dd');
    double totalHours = 0;

    for (var r in reports.where((r) => r.isSubmitted)) {
      String sched = '${timeFormat.format(r.scheduledStart)} - ${timeFormat.format(r.scheduledEnd)}';
      String conf = '${timeFormat.format(r.confirmedStart)} - ${timeFormat.format(r.confirmedEnd)}';
      double hours = r.workedHours;
      totalHours += hours;

      List<CellValue> row = [
        TextCellValue(_getLocalizedDay(r.reportDate.weekday, loc)),
        TextCellValue(dateFormat.format(r.reportDate)),
        TextCellValue(sched),
        TextCellValue(conf),
        DoubleCellValue(double.parse(hours.toStringAsFixed(2))),
        TextCellValue(r.workDone),
      ];
      sheetObject.appendRow(row);
    }

    // Total row
    sheetObject.appendRow([]);
    sheetObject.appendRow([
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(loc.totalHours),
      DoubleCellValue(double.parse(totalHours.toStringAsFixed(2))),
    ]);

    var fileBytes = excel.save();
    if (fileBytes != null) {
      _downloadExcelWeb(fileBytes, "Working_Reports_${staff.name.replaceAll(' ', '_')}.xlsx");
    }
  }

  static Future<void> exportAllStaffWorkingReports(List<StaffMember> staffList, List<WorkingReport> allReports, AppLocalizations loc) async {
    for (var staff in staffList) {
      final reports = allReports.where((r) => r.staffId == staff.id).toList();
      if (reports.isNotEmpty) {
        exportWorkingReports(staff, reports, loc);
        // Add a small delay to avoid browser download blocking
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  static String _getLocalizedDay(int weekday, AppLocalizations loc) {
    switch (weekday) {
      case DateTime.monday: return loc.mon;
      case DateTime.tuesday: return loc.tue;
      case DateTime.wednesday: return loc.wed;
      case DateTime.thursday: return loc.thu;
      case DateTime.friday: return loc.fri;
      case DateTime.saturday: return loc.sat;
      case DateTime.sunday: return loc.sun;
      default: return '';
    }
  }

  static String _translateValue(String value, AppLocalizations loc) {
    switch (value) {
      case 'Bachelors': return loc.bachelors;
      case 'Masters': return loc.masters;
      case 'PhD': return loc.phd;
      case 'Research': return loc.research;
      case 'Online': return loc.online;
      case 'In-Person': return loc.inPerson;
      case 'Both': return loc.both;
      case 'Senior': return loc.senior;
      case 'Junior': return loc.junior;
      default: return value;
    }
  }

  static void _downloadExcelWeb(List<int> bytes, String fileName) {
    final base64String = base64Encode(bytes);
    final anchor = web.HTMLAnchorElement()
      ..href = 'data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,$base64String'
      ..download = fileName
      ..style.display = 'none';
      
    web.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
  }
}
