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

  // Categorized classification mappings
  final Map<String, int> _japaneseStaffCounts = {};
  final Map<String, int> _intlStudentCounts = {};

  DateTime get selectedDay => _selectedDay;
  String? get selectedTimeSlot => _selectedTimeSlot;
  bool get isFormVisible => _isFormVisible;
  String get currentLocale => _currentLocale;
  bool get isLoading => _isLoading;

  // Combines counts to ensure slot stays visible if EITHER type has slots available
  Map<String, int> get slotBookingCounts {
    final Map<String, int> totalCounts = {};
    for (var slot in _allTimeSlots) {
      int total =
          (_japaneseStaffCounts[slot] ?? 0) + (_intlStudentCounts[slot] ?? 0);
      if (total > 0) {
        totalCounts[slot] = total;
      }
    }
    return totalCounts;
  }

  // Explicit helper getters for categorized metrics
  Map<String, int> get japaneseStaffCounts => _japaneseStaffCounts;
  Map<String, int> get intlStudentCounts => _intlStudentCounts;

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
        .where((slot) => (slotBookingCounts[slot] ?? 0) > 0)
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
      _calculateSlotsForSelectedDay();
      return;
    }

    _isLoading = true;
    _japaneseStaffCounts.clear();
    _intlStudentCounts.clear();
    _cachedSharepointItems.clear();
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(_powerAutomateUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"targetDate": _selectedDay.toIso8601String()}),
      );

      if (response.statusCode == 200) {
        _cachedSharepointItems = jsonDecode(response.body);
        _calculateSlotsForSelectedDay();
      }
    } catch (networkError) {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _calculateSlotsForSelectedDay() {
    _japaneseStaffCounts.clear();
    _intlStudentCounts.clear();

    // === ADDED: RESET EXPLICIT DYNAMIC CONTAINERS DURING CALCULATION ===
    _slotCountries.clear();
    _slotLanguages.clear();

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
        // --- POWER AUTOMATE CHOICE COLUMN EXTRACTION LAYER ---
        bool isJapaneseStaff = false;
        var staffData = item['staff'];
        String staffValue = staffData?.toString().trim() ?? '';

        if (staffData != null) {
          if (staffData is Map && staffData['Value'] != null) {
            // Configuration A: Standard Dynamic Content Object -> {"Value": "ja"}
            String value = staffData['Value'].toString().toLowerCase().trim();
            isJapaneseStaff = (value == 'ja' || value.contains('japanese'));
          } else if (staffData is List) {
            // Configuration B: Multi-Choice array layout -> [{"Value": "ja"}]
            isJapaneseStaff = staffData.any((element) {
              if (element is Map && element['Value'] != null) {
                String val = element['Value'].toString().toLowerCase().trim();
                return (val == 'ja' || val.contains('japanese'));
              }
              return element.toString().toLowerCase().trim() == 'ja';
            });
          } else {
            // Configuration C: Evaluates raw text payload strings or dynamic text variants
            String rawString = staffData.toString().toLowerCase().trim();
            isJapaneseStaff =
                (rawString == 'ja' ||
                rawString == 'japanese' ||
                rawString.contains('"value":"ja"') ||
                rawString.contains('日本語'));
          }
        }

        // === ADDED: DATA EXTRACTION FOR COUNTRIES & LANGUAGES ===
        String? itemCountry;
        var countryData = item['country'];
        if (countryData != null) {
          itemCountry = (countryData is Map && countryData['Value'] != null)
              ? countryData['Value'].toString().trim()
              : countryData.toString().trim();
        }

        List<String> itemLanguages = [];
        // 1. Extract raw staff text name language part (e.g. "swahili" from "swahili - sw")
        if (staffValue.isNotEmpty && !staffValue.contains('{')) {
          String parsedStaffLang = staffValue.split('-').first.trim();
          if (parsedStaffLang.isNotEmpty) {
            itemLanguages.add(parsedStaffLang);
          }
        }

        var langData = item['possibleTargerLanguages']; // Exact spelling matched
        if (langData != null) {
          String rawLangs = (langData is Map && langData['Value'] != null)
              ? langData['Value'].toString()
              : langData.toString();
          if (rawLangs.isNotEmpty) {
            itemLanguages = rawLangs.split(',').map((e) => e.trim()).toList();
          }
        }

        for (String slot in _allTimeSlots) {
          DateTime slotStart = _parseSlotTimeToDateTime(
            _selectedDay,
            slot,
            false,
          );
          DateTime slotEnd = _parseSlotTimeToDateTime(
            _selectedDay,
            slot,
            true,
          );

          // Evaluates if the dynamic booking item overlaps this 30-min window
          if (start.isBefore(slotEnd) && end.isAfter(slotStart)) {
            if (isJapaneseStaff) {
              _japaneseStaffCounts[slot] =
                  (_japaneseStaffCounts[slot] ?? 0) + 1;
            } else {
              _intlStudentCounts[slot] = (_intlStudentCounts[slot] ?? 0) + 1;
            }

            // Bind unique dynamic country data tags per slot
            if (itemCountry != null && itemCountry.isNotEmpty) {
              _slotCountries.putIfAbsent(slot, () => []);
              if (!_slotCountries[slot]!.contains(itemCountry)) {
                _slotCountries[slot]!.add(itemCountry);
              }
            }

            // Bind unique target languages parameters per slot
            if (itemLanguages.isNotEmpty) {
              _slotLanguages.putIfAbsent(slot, () => []);
              for (var lang in itemLanguages) {
                if (!_slotLanguages[slot]!.contains(lang)) {
                  _slotLanguages[slot]!.add(lang);
                }
              }
            }
          }
        }
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  int getTotalStaffCountForSlot(String slot) {
    return (_japaneseStaffCounts[slot] ?? 0) + (_intlStudentCounts[slot] ?? 0);
  }

  int getJapaneseStaffCountForSlot(String slot) {
    return _japaneseStaffCounts[slot] ?? 0;
  }

  int getIntlStudentCountForSlot(String slot) {
    return _intlStudentCounts[slot] ?? 0;
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
        'verify_btn': 'Submit reservation request',
        'required': 'Required field',
        'invalid_email': 'Enter a valid email address',
        'select_loc': 'Please select a location',
        'select_purpose': 'Please select a purpose',
        'select_lang': 'Please select a target language',
        'success_msg': 'Reservation submitted successfully!',
        'slots_header': 'Available 30-Min Slots',
        'loading': 'Syncing with SharePoint Matrix...',
        'ja_staff_label': 'Japanese students',
        'intl_staff_label': 'International students',
        'pref_title': 'Preferred Staff Type',
        'pref_anyone': 'No Preference (Anyone)',
        'pref_japanese': 'Japanese Students Only',
        'pref_intl': 'International Students Only',
        'sectionTitle': 'Staff Preferences',
        'labelAnyone': 'No Preference (Anyone)',
        'labelJapanese': 'Japanese Students',
        'labelIntl': 'International Students'
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
        'verify_btn': '予約リクエストを送信',
        'required': '必須項目です',
        'invalid_email': '有効なメールアドレスを入力してください',
        'select_loc': '場所を選択してください',
        'select_purpose': '目的を選択してください',
        'select_lang': '対象言語を選択してください',
        'success_msg': '予約が正常に送信されました！',
        'slots_header': '予約可能な時間枠（30分単位）',
        'loading': 'SharePointデータベースと同期中...',
        'ja_staff_label': '日本人学生',
        'intl_staff_label': '留学生',
        'pref_title': '希望するスタッフタイプ',
        'pref_anyone': '指定なし (誰でも)',
        'pref_japanese': '日本人学生のみ',
        'pref_intl': '留学生のみ',
        'sectionTitle': '希望するスタッフタイプ',
        'labelAnyone': '指定なし (誰でも)',
        'labelJapanese': '日本人学生',
        'labelIntl': '留学生'
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

  // =========================================================================
  // === NEW ADDITIONS ONLY: APPENDED MISSING FEATURES WITHOUT MODIFICATION ===
  // =========================================================================

  final Map<String, List<String>> _slotCountries = {};
  final Map<String, List<String>> _slotLanguages = {};

  List<String> getCountriesForSlot(String slot) => _slotCountries[slot] ?? [];
  List<String> getLanguagesForSlot(String slot) => _slotLanguages[slot] ?? [];

  // Expanded localization support for dynamic languages display
  final Map<String, Map<String, String>> _langDisplayMap = {
    'english': {'en': 'English - en', 'ja': '英語 - en'},
    'japanese': {'en': 'Japanese - ja', 'ja': '日本語 - ja'},
    'chinese': {'en': 'Mandarin Chinese - zh', 'ja': '中国語（繁体） - zh'},
    'spanish': {'en': 'Spanish - es', 'ja': 'スペイン語 - es'},
    'swahili': {'en': 'Swahili - sw', 'ja': 'スワヒリ語 - sw'},
    'kikuyu': {'en': 'Kikuyu - ki', 'ja': 'キクユ語 - ki'},
  };

  List<String> getDynamicTargetLanguages() {
    if (_selectedTimeSlot == null) return [];
    final rawLanguages = _slotLanguages[_selectedTimeSlot] ?? [];
    
    return rawLanguages.map((lang) {
      final key = lang.toLowerCase().trim();
      if (_langDisplayMap.containsKey(key)) {
        return _langDisplayMap[key]![_currentLocale]!;
      }
      return lang;
    }).toList();
  }

  Future<bool> sendBookingPayload(Map<String, dynamic> payload, {String? customUrl}) async {
    final url = (customUrl != null && customUrl.isNotEmpty) ? customUrl : _powerAutomateUrl;
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
      return response.statusCode == 200 || response.statusCode == 202;
    } catch (e) {
      debugPrint("Error pipeline call failed: $e");
      return false;
    }
  }
}