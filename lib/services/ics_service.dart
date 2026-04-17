import 'package:web/web.dart' as web;
import 'dart:convert';
import '../models/models.dart';
import 'package:intl/intl.dart';

class ICSService {
  static void exportToICS(StaffMember staff, List<AvailabilityBlock> blocks) {
    StringBuffer ics = StringBuffer();
    ics.writeln('BEGIN:VCALENDAR');
    ics.writeln('VERSION:2.0');
    ics.writeln('PRODID:-//GCL Personnel//NONSGML v1.0//EN');
    ics.writeln('CALSCALE:GREGORIAN');
    ics.writeln('METHOD:PUBLISH');
    ics.writeln('X-WR-CALNAME:GCL Availability - ${staff.name}');

    for (var block in blocks) {
      if (block.staffId != staff.id) continue;
      
      DateTime start = block.startTime;
      DateTime end = start.add(const Duration(minutes: 30));

      String startStr = _formatDateTime(start);
      String endStr = _formatDateTime(end);

      ics.writeln('BEGIN:VEVENT');
      ics.writeln('UID:${block.id}@gcl.org');
      ics.writeln('DTSTAMP:${_formatDateTime(DateTime.now())}');
      ics.writeln('DTSTART:$startStr');
      ics.writeln('DTEND:$endStr');
      ics.writeln('SUMMARY:GCL Shift (${block.modality})');
      ics.writeln('DESCRIPTION:Staff Member: ${staff.name}\\nModality: ${block.modality}');
      ics.writeln('STATUS:CONFIRMED');
      ics.writeln('END:VEVENT');
    }

    ics.writeln('END:VCALENDAR');

    _downloadICSWeb(ics.toString(), "GCL_Availability_${staff.name.replaceAll(' ', '_')}.ics");
  }

  static String _formatDateTime(DateTime dt) {
    // ICS format: yyyyMMddTHHmmssZ
    return DateFormat("yyyyMMdd'T'HHmmss'Z'").format(dt.toUtc());
  }

  static void _downloadICSWeb(String content, String fileName) {
    final bytes = utf8.encode(content);
    final base64String = base64Encode(bytes);
    final anchor = web.HTMLAnchorElement()
      ..href = 'data:text/calendar;base64,$base64String'
      ..download = fileName
      ..style.display = 'none';
      
    web.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
  }
}
