import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookingProvider with ChangeNotifier {
  DateTime _selectedDay = DateTime.now();
  String? _selectedTimeSlot;
  bool _isFormVisible = false;
  String _currentLocale = 'en';
  bool _isLoading = false;

  List<dynamic> _cachedSharepointItems = [];
  Map<String, int> _slotBookingCounts = {};

  DateTime get selectedDay => _selectedDay;
  String? get selectedTimeSlot => _selectedTimeSlot;
  bool get isFormVisible => _isFormVisible;
  String get currentLocale => _currentLocale;
  bool get isLoading => _isLoading;
  Map<String, int> get slotBookingCounts => _slotBookingCounts;

  final String _powerAutomateUrl =
      'https://defaultdbf986a9f2c7470188ce463dec76cb.a4.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/f9a7ba33519541a7826952579b57b3b8/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=ZfI4IxYzXX9WUWNAhA3nWTkXSla4L1Ongx3dJoFJakE';

  final List<String> _allTimeSlots = [
    '09:00 AM - 09:30 AM',
    '09:30 AM - 10:00 AM',
    '10:00 AM - 10:30 AM',
    '10:30 AM - 11:00 AM',
    '11:00 AM - 11:30 AM',
    '11:30 AM - 12:00 PM',
    '12:00 PM - 12:30 PM',
    '12:30 PM - 01:00 PM',
    '01:00 PM - 01:30 PM',
    '01:30 PM - 02:00 PM',
    '02:00 PM - 02:30 PM',
    '02:30 PM - 03:00 PM',
    '03:00 PM - 03:30 PM',
    '03:30 PM - 04:00 PM',
    '04:00 PM - 04:30 PM',
    '04:30 PM - 05:00 PM',
    '05:00 PM - 05:30 PM',
    '05:30 PM - 06:00 PM',
    '06:00 PM - 06:30 PM',
    '06:30 PM - 07:00 PM',
    '07:00 PM - 07:30 PM',
    '07:30 PM - 08:00 PM',
  ];

  List<String> get timeSlots {
    return _allTimeSlots
        .where((slot) => (_slotBookingCounts[slot] ?? 0) > 0)
        .toList();
  }

  List<String> get locations => _currentLocale == 'ja'
      ? ['オンライン [Teams]', 'GCL ラウンジ']
      : ['Online [Teams]', 'GCL Lounge'];

  List<String> get purposes => _currentLocale == 'ja'
      ? ['課題', 'フリートーク・会話', 'プレゼンテーション練習']
      : ['Assignment', 'Conversation', 'Presentation Practice'];

  List<String> get targetLanguages => _currentLocale == 'ja'
      ? ['英語 - en', '日本語 - ja', '中国語（繁体） - zh', 'スペイン語 - es']
      : [
          'English - en',
          'Japanese - ja',
          'Mandarin Chinese - zh',
          'Spanish - es',
        ];

  void setLocale(String localeCode) {
    _currentLocale = (localeCode == 'ja' || localeCode == 'en')
        ? localeCode
        : 'en';
    notifyListeners();
  }

  void selectDay(DateTime day) {
    _selectedDay = day;
    _selectedTimeSlot = null;
    _isFormVisible = false;
    _calculateSlotsForSelectedDay();
  }

  void selectTimeSlot(String slot) {
    _selectedTimeSlot = slot;
    _isFormVisible = true;
    notifyListeners();
  }

  Future<void> fetchSharePointBookings() async {
    if (_cachedSharepointItems.isNotEmpty) {
      print(
        "🎯 [CACHE HIT]: Skipping network request. Utilizing locally stored month dataset mapping.",
      );
      _calculateSlotsForSelectedDay();
      return;
    }

    _isLoading = true;
    _slotBookingCounts.clear();
    _cachedSharepointItems.clear();
    notifyListeners();

    final String payloadData = jsonEncode({
      "targetDate": _selectedDay.toIso8601String(),
    });

    print(
      "========================================================================",
    );
    print(
      "⚡ [FLUTTER NETWORK OUTBOUND]: Initiating API synchronization fetch...",
    );
    print(
      "🔗 Target URL Check: ${_powerAutomateUrl.substring(0, 45.clamp(0, _powerAutomateUrl.length))}...",
    );
    print("📦 Payload Manifest: $payloadData");
    print(
      "========================================================================",
    );

    try {
      final response = await http.post(
        Uri.parse(_powerAutomateUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"targetDate": _selectedDay.toIso8601String()}),
      );

      print(
        "========================================================================",
      );
      print("📡 [FLUTTER NETWORK INBOUND]: Server Handshake Completed!");
      print("🔴 HTTP Response Status Code: ${response.statusCode}");
      print("📄 Raw Response Payload Body Data: ${response.body}");
      print(
        "========================================================================",
      );

      if (response.statusCode == 200) {
        _cachedSharepointItems = jsonDecode(response.body);
        print(
          "💡 Parsed [${_cachedSharepointItems.length}] raw dataset rows into storage cache.",
        );
        _calculateSlotsForSelectedDay();
      }
    } catch (networkError) {
      print(
        "🚨 [CRITICAL NETWORK EXCEPTION CRASH]: Failed to hit endpoint endpoint server.",
      );
      print("Detailed Diagnostic Trace: $networkError");
      _isLoading = false;
      notifyListeners();
    }
  }

  void _calculateSlotsForSelectedDay() {
    _slotBookingCounts.clear();

    for (var item in _cachedSharepointItems) {
      if (item == null ||
          item['startTime'] == null ||
          item['endTime'] == null) {
        continue;
      }

      String startStr = item['startTime'].toString();
      String endStr = item['endTime'].toString();

      if (startStr.isEmpty || endStr.isEmpty) {
        continue;
      }

      DateTime startRaw = DateTime.parse(startStr);
      DateTime endRaw = DateTime.parse(endStr);

      DateTime start = DateTime(
        startRaw.year,
        startRaw.month,
        startRaw.day,
        startRaw.hour,
        startRaw.minute,
      );
      DateTime end = DateTime(
        endRaw.year,
        endRaw.month,
        endRaw.day,
        endRaw.hour,
        endRaw.minute,
      );

      if (start.year == _selectedDay.year &&
          start.month == _selectedDay.month &&
          start.day == _selectedDay.day) {
        for (String slot in _allTimeSlots) {
          DateTime slotStart = _parseSlotTimeToDateTime(
            _selectedDay,
            slot,
            false,
          );
          DateTime slotEnd = _parseSlotTimeToDateTime(_selectedDay, slot, true);

          if ((start.isBefore(slotStart) ||
                  start.isAtSameMomentAs(slotStart)) &&
              end.isAfter(slotStart)) {
            _slotBookingCounts[slot] = (_slotBookingCounts[slot] ?? 0) + 1;
          }
        }
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  int getTotalStaffCountForSlot(String slot) {
    return _slotBookingCounts[slot] ?? 0;
  }

  DateTime _parseSlotTimeToDateTime(
    DateTime baseDate,
    String slotRange,
    bool getEndTime,
  ) {
    final parts = slotRange.split(' - ');
    final targetTime = getEndTime ? parts[1] : parts[0];
    final timeParts = targetTime.split(' ');
    final hhmm = timeParts[0].split(':');

    int hour = int.parse(hhmm[0]);
    int minute = int.parse(hhmm[1]);
    if (timeParts[1] == 'PM' && hour != 12) hour += 12;
    if (timeParts[1] == 'AM' && hour == 12) hour = 0;

    return DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
  }

  String translate(String key) {
    final Map<String, Map<String, String>> localizedValues = {
      'en': {
        'title': 'SharePoint Reservation Portal',
        'prompt':
            'Select a date and an available 30-minute window above to continue.',
        'booking_slot': 'Booking Slot',
        'name': 'Full Name',
        'email': 'Email Address',
        'location': 'Location',
        'purpose': 'Purpose',
        'target_lang': 'Target Language',
        'verify_btn': 'Verify Payload Data',
        'required': 'Required field',
        'invalid_email': 'Enter a valid email address',
        'select_loc': 'Please select a location',
        'select_purpose': 'Please select a purpose',
        'select_lang': 'Please select a target language',
        'success_msg': 'Payload Validated successfully!',
        'slots_header': 'Available 30-Min Slots',
        'loading': 'Syncing with SharePoint Matrix...',
      },
      'ja': {
        'title': 'SharePoint 予約ポータル',
        'prompt': '上のカレンダーから日付と空いている時間枠を選択してください。',
        'booking_slot': '予約枠',
        'name': '氏名（フルネーム）',
        'email': 'メールアドレス',
        'location': '場所',
        'purpose': '利用目的',
        'target_lang': '対象言語',
        'verify_btn': 'ペイロードデータを検証',
        'required': '必須項目です',
        'invalid_email': '有効なメールアドレスを入力してください',
        'select_loc': '場所を選択してください',
        'select_purpose': '目的を選択してください',
        'select_lang': '対象言語を選択してください',
        'success_msg': 'ペイロードの検証に成功しました！',
        'slots_header': '予約可能な時間枠（30分単位）',
        'loading': 'SharePointデータベースと同期中...',
      },
    };
    return localizedValues[_currentLocale]?[key] ?? key;
  }

  DateTime getCalculatedDateTime({required bool getEndTime}) {
    if (_selectedTimeSlot == null) return _selectedDay;
    final parts = _selectedTimeSlot!.split(' - ');
    final targetTimeString = getEndTime ? parts[1] : parts[0];
    final timeParts = targetTimeString.split(' ');
    final hhmm = timeParts[0].split(':');
    int hour = int.parse(hhmm[0]);
    int minute = int.parse(hhmm[1]);
    if (timeParts[1] == 'PM' && hour != 12) hour += 12;
    if (timeParts[1] == 'AM' && hour == 12) hour = 0;
    return DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
      hour,
      minute,
    );
  }
}
