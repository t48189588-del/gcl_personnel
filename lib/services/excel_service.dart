import 'package:excel/excel.dart';
import 'package:web/web.dart' as web;
import 'dart:convert';
import '../models/models.dart';
import 'package:intl/intl.dart';

class ExcelService {
  static void exportStaffData(List<StaffMember> staff) {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Staff Information'];
    excel.delete('Sheet1'); // Remove default sheet

    // Add headers
    List<String> headers = [
      'Name',
      'Native Language',
      'Fluent Languages',
      'Degree',
      'Modality Preference',
      'Availability Rate',
      'Events Participation',
      'Provided Assistance',
      'Comm Preference'
    ];
    
    sheetObject.appendRow(headers.map((e) => TextCellValue(e)).toList());

    for (var s in staff) {
      List<CellValue> row = [
        TextCellValue(s.name),
        TextCellValue(s.nativeLanguage),
        TextCellValue(s.fluentLanguages.join(', ')),
        TextCellValue(s.degree),
        TextCellValue(s.modalityPreference),
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

  static void exportMasterCalendarMonthly(DateTime month, List<StaffMember> juniorStaff, List<AvailabilityBlock> allBlocks) {
    var excel = Excel.createExcel();
    String sheetName = DateFormat('MMMM yyyy').format(month);
    Sheet sheetObject = excel[sheetName];
    excel.delete('Sheet1');

    // Headers: Column 1: Date, Column 2: Time, C3 onwards: Junior Staff Names
    List<CellValue> headers = [
      TextCellValue('Date'),
      TextCellValue('Time'),
    ];
    for (var staff in juniorStaff) {
      headers.add(TextCellValue(staff.name));
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
            if (block.modality == 'Online') symbol = '○';
            else if (block.modality == 'Both') symbol = '○ (In-Person)';
            else symbol = '(In-Person)';
            
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
