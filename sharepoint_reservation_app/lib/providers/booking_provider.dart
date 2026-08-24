import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class BookingProvider with ChangeNotifier {
  DateTime _selectedDay = DateTime.now();
  String? _selectedTimeSlot;
  bool _isFormVisible = false;
  String _currentLocale = 'en';
  bool _isLoading = false;

  List<dynamic> _cachedSharepointItems = [];

  // Keep track of which date the cached data belongs to.
  //
  // IMPORTANT:
  // This is now used as the "data has been loaded" marker.
  // The cached list itself may legitimately be empty.
  DateTime? _cachedDate;

  // ---------------------------------------------------------------------------
  // BOOKING COUNTS
  // ---------------------------------------------------------------------------

  final Map<String, int> _japaneseStaffCounts = {};
  final Map<String, int> _intlStudentCounts = {};

  // ---------------------------------------------------------------------------
  // DYNAMIC SLOT DATA
  // ---------------------------------------------------------------------------

  final Map<String, List<String>> _slotCountries = {};
  final Map<String, List<String>> _slotLanguages = {};
  final Map<String, List<String>> _slotStaffNames = {};
  final Map<String, Map<String, List<String>>> _slotCountryStaffNames = {};

  // ---------------------------------------------------------------------------
  // GETTERS
  // ---------------------------------------------------------------------------

  DateTime get selectedDay => _selectedDay;

  String? get selectedTimeSlot => _selectedTimeSlot;

  bool get isFormVisible => _isFormVisible;

  String get currentLocale => _currentLocale;

  bool get isLoading => _isLoading;

  Map<String, int> get japaneseStaffCounts => _japaneseStaffCounts;

  Map<String, int> get intlStudentCounts => _intlStudentCounts;

  Map<String, int> get slotBookingCounts {
    final Map<String, int> totalCounts = {};

    for (final slot in _allTimeSlots) {
      final total =
          (_japaneseStaffCounts[slot] ?? 0) + (_intlStudentCounts[slot] ?? 0);

      if (total > 0) {
        totalCounts[slot] = total;
      }
    }

    return totalCounts;
  }

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

  // ---------------------------------------------------------------------------
  // TIME SLOTS
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // LOCALIZATION
  // ---------------------------------------------------------------------------

  void setLocale(String localeCode) {
    _currentLocale = (localeCode == 'ja' || localeCode == 'en')
        ? localeCode
        : 'en';

    notifyListeners();
  }

  String translate(String key) {
    final Map<String, Map<String, String>> localizedValues = {
      'en': {
        'title': 'GCL Reservation Portal',
        'prompt':
            'Select a date and an available 30-minute window above to continue.',
        'booking_slot': 'Booking Slot',
        'name': 'Full Name',
        'email': 'Kyutech Email Address (@mail.kyutech.jp)',
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
        'labelIntl': 'International Students',
        'jaSupport': 'Do you wish Japanese staff support?',
        'quantity': 'Number of Students',
      },
      'ja': {
        'title': 'GCL 予約ポータル',
        'prompt': '上のカレンダーから日付と空いている時間枠を選択してください。',
        'booking_slot': '予約枠',
        'name': '氏名（フルネーム）',
        'email': '九工大メールアドレスのみ (@mail.kyutech.jp)',
        'location': '場所',
        'purpose': '利用目的',
        'target_lang': '対象言語',
        'verify_btn': '予約リクエストを送信',
        'required': '必須項目です',
        'invalid_email': '有効なメールアドレスを入力してください',
        'select_loc': '場所を選択してください',
        'select_purpose': '目的を選択してください',
        'select_lang': '希望する言語',
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
        'labelIntl': '留学生',
        'jaSupport': '日本人スタッフのサポートを希望しますか？',
        'quantity': '人数',
      },
    };

    return localizedValues[_currentLocale]?[key] ?? key;
  }

  // ---------------------------------------------------------------------------
  // ENDPOINTS
  // ---------------------------------------------------------------------------

  String _getBookingsEndpoint() {
    if (kIsWeb && kReleaseMode) {
      return '/api/booking';
    }

    final localUrl = dotenv.maybeGet('POWER_AUTOMATE_URL_GET');

    if (localUrl == null || localUrl.trim().isEmpty) {
      throw Exception('POWER_AUTOMATE_URL_GET is missing from .env');
    }

    return localUrl.trim();
  }

  String _getReservationEndpoint() {
    if (kIsWeb && kReleaseMode) {
      return '/api/reservation';
    }

    final localUrl = dotenv.maybeGet('POWER_AUTOMATE_URL_POST');

    if (localUrl == null || localUrl.trim().isEmpty) {
      throw Exception('POWER_AUTOMATE_URL_POST is missing from .env');
    }

    return localUrl.trim();
  }

  // ---------------------------------------------------------------------------
  // DATE / SLOT SELECTION
  // ---------------------------------------------------------------------------

  void selectDay(DateTime day) {
    _selectedDay = DateTime(day.year, day.month, day.day);
    _selectedTimeSlot = null;
    _isFormVisible = false;

    /*
     * IMPORTANT:
     *
     * Changing the calendar date does NOT fetch SharePoint data anymore.
     *
     * The provider keeps the complete SharePoint response in
     * _cachedSharepointItems and recalculates the UI from that local data.
     */
    if (_cachedDate != null) {
      _calculateSlotsForSelectedDay();
    } else {
      /*
       * Initial state only.
       *
       * If the provider has not loaded SharePoint data yet, fetch it once.
       */
      fetchSharePointBookings();
    }

    notifyListeners();
  }

  void selectTimeSlot(String slot) {
    _selectedTimeSlot = slot;
    _isFormVisible = true;

    notifyListeners();
  }

  bool _isSameDate(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;

    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // ---------------------------------------------------------------------------
  // FETCH SHAREPOINT BOOKINGS
  // ---------------------------------------------------------------------------

  Future<void> fetchSharePointBookings() async {
    /*
     * THIS IS THE MOST IMPORTANT CHANGE.
     *
     * _cachedDate is now the "already loaded" flag.
     *
     * We intentionally do NOT check whether the cached list is empty because
     * an empty SharePoint response is still a valid response.
     *
     * This guarantees that an empty response does not cause another request
     * every time the calendar changes.
     */
    if (_cachedDate != null) {
      _calculateSlotsForSelectedDay();
      return;
    }

    /*
     * Prevent duplicate requests if multiple widgets call this method while
     * the initial request is still running.
     */
    if (_isLoading) {
      return;
    }

    _isLoading = true;

    _japaneseStaffCounts.clear();
    _intlStudentCounts.clear();
    _slotCountries.clear();
    _slotLanguages.clear();
    _slotStaffNames.clear();
    _slotCountryStaffNames.clear();

    notifyListeners();

    try {
      final endpoint = _getBookingsEndpoint();

      /*
       * IMPORTANT:
       *
       * We are requesting the complete booking dataset.
       *
       * The API / Power Automate flow should return all relevant SharePoint
       * booking records instead of filtering by targetDate.
       *
       * This allows the Flutter provider to handle date filtering locally.
       */
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'loadAll': true}),
      );

      debugPrint('SharePoint API returned HTTP ${response.statusCode}');

      if (response.statusCode != 200) {
        debugPrint('SharePoint API error: ${response.body}');

        _cachedSharepointItems = [];

        /*
         * Do NOT mark the cache as loaded on a failed request.
         *
         * This allows the application to retry if the initial request failed.
         */
        _cachedDate = null;

        _isLoading = false;

        notifyListeners();
        return;
      }

      final decoded = jsonDecode(response.body);

      if (decoded is List) {
        _cachedSharepointItems = List<dynamic>.from(decoded);
      } else if (decoded is Map && decoded['value'] is List) {
        _cachedSharepointItems = List<dynamic>.from(decoded['value']);
      } else {
        debugPrint('Unexpected SharePoint response structure.');

        _cachedSharepointItems = [];
      }

      /*
       * Mark the entire dataset as loaded.
       *
       * We deliberately use the current date only as a non-null marker.
       * It is NOT used to decide whether another API request is necessary.
       */
      _cachedDate = DateTime(
        _selectedDay.year,
        _selectedDay.month,
        _selectedDay.day,
      );

      debugPrint(
        'SharePoint data loaded locally: '
        '${_cachedSharepointItems.length} records',
      );

      /*
       * From this point forward all calendar date changes are local.
       */
      _calculateSlotsForSelectedDay();
    } catch (e, stackTrace) {
      debugPrint('Error fetching SharePoint bookings: $e');

      debugPrintStack(stackTrace: stackTrace);

      _cachedSharepointItems = [];

      /*
       * Leave cache unloaded after an exception so the app can retry.
       */
      _cachedDate = null;

      _isLoading = false;

      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // SHAREPOINT JSON EXTRACTION
  // ---------------------------------------------------------------------------

  String _extractSharePointValue(dynamic data) {
    if (data == null) {
      return '';
    }

    if (data is Map) {
      if (data['Value'] != null) {
        return data['Value'].toString().trim();
      }

      if (data['value'] != null) {
        return data['value'].toString().trim();
      }

      return '';
    }

    if (data is List) {
      final values = <String>[];

      for (final element in data) {
        final value = _extractSharePointValue(element);

        if (value.isNotEmpty) {
          values.add(value);
        }
      }

      return values.join(', ');
    }

    return data.toString().trim();
  }

  List<String> _extractSharePointValues(dynamic data) {
    if (data == null) {
      return [];
    }

    if (data is List) {
      final result = <String>[];

      for (final element in data) {
        /*
         * If this is a normal primitive/string, extract it directly.
         * If it is a SharePoint object, extract Value/value.
         */
        final value = _extractSharePointValue(element);

        if (value.isNotEmpty && !result.contains(value)) {
          result.add(value);
        }
      }

      return result;
    }

    final value = _extractSharePointValue(data);

    if (value.isEmpty) {
      return [];
    }

    return [value];
  }

  // ---------------------------------------------------------------------------
  // STAFF CLASSIFICATION
  // ---------------------------------------------------------------------------

  bool _isJapaneseStaff(dynamic staffData) {
    final values = _extractSharePointValues(staffData);

    for (final value in values) {
      final normalized = value.toLowerCase().trim();

      if (normalized == 'ja' ||
          normalized == 'japanese' ||
          normalized.contains('japanese')) {
        return true;
      }

      if (value.contains('日本')) {
        return true;
      }
    }

    return false;
  }

  // ---------------------------------------------------------------------------
  // SLOT CALCULATION
  // ---------------------------------------------------------------------------

  void _calculateSlotsForSelectedDay() {
    _japaneseStaffCounts.clear();
    _intlStudentCounts.clear();

    _slotCountries.clear();
    _slotLanguages.clear();
    _slotStaffNames.clear();
    _slotCountryStaffNames.clear();

    /*
     * Everything below this point works against LOCAL DATA ONLY.
     *
     * There is no HTTP call anywhere in this method.
     */
    for (final item in _cachedSharepointItems) {
      if (item is! Map) {
        continue;
      }

      final startStr = item['startTime']?.toString().trim() ?? '';
      final endStr = item['endTime']?.toString().trim() ?? '';

      if (startStr.isEmpty || endStr.isEmpty) {
        continue;
      }

      DateTime? startRaw;
      DateTime? endRaw;

      try {
        startRaw = DateTime.parse(startStr);
        endRaw = DateTime.parse(endStr);
      } catch (e) {
        debugPrint('Invalid booking date: $startStr - $endStr');
        continue;
      }

      final start = DateTime(
        startRaw.year,
        startRaw.month,
        startRaw.day,
        startRaw.hour,
        startRaw.minute,
      );

      final end = DateTime(
        endRaw.year,
        endRaw.month,
        endRaw.day,
        endRaw.hour,
        endRaw.minute,
      );

      /*
       * Filter the locally cached dataset by the currently selected calendar
       * date.
       */
      if (start.year != _selectedDay.year ||
          start.month != _selectedDay.month ||
          start.day != _selectedDay.day) {
        continue;
      }

      if (!end.isAfter(start)) {
        continue;
      }

      // -----------------------------------------------------------------------
      // Extract SharePoint fields
      // -----------------------------------------------------------------------

      final countryValues = _extractSharePointValues(item['country']);

      // final languageValues = _extractSharePointValues(
      //   item['possibleTargerLanguages'],
      // );

      final staffName = item['staffName']?.toString().trim() ?? '';

      /*
       * IMPORTANT BUG FIX:
       *
       * The previous provider did:
       *
       * _isJapaneseStaff(item['country'])
       *
       * which is incorrect.
       *
       * Japanese/international classification should come from "staff".
       */
      final isJapaneseStaff = _isJapaneseStaff(item['country']);

      // -----------------------------------------------------------------------
      // Bind booking to every overlapping 30-minute slot.
      // -----------------------------------------------------------------------

      for (final slot in _allTimeSlots) {
        final slotStart = _parseSlotTimeToDateTime(_selectedDay, slot, false);

        final slotEnd = _parseSlotTimeToDateTime(_selectedDay, slot, true);

        final overlaps = start.isBefore(slotEnd) && end.isAfter(slotStart);

        if (!overlaps) {
          continue;
        }

        // ---------------------------------------------------------------------
        // Staff classification
        // ---------------------------------------------------------------------

        if (isJapaneseStaff) {
          _japaneseStaffCounts[slot] = (_japaneseStaffCounts[slot] ?? 0) + 1;
        } else {
          _intlStudentCounts[slot] = (_intlStudentCounts[slot] ?? 0) + 1;
        }

        // ---------------------------------------------------------------------
        // Country + Staff Name relationship
        // ---------------------------------------------------------------------

        for (final country in countryValues) {
          _slotCountries.putIfAbsent(slot, () => []);

          if (!_slotCountries[slot]!.contains(country)) {
            _slotCountries[slot]!.add(country);
          }

          if (staffName.isNotEmpty) {
            _slotCountryStaffNames.putIfAbsent(slot, () => {});

            _slotCountryStaffNames[slot]!.putIfAbsent(country, () => []);

            if (!_slotCountryStaffNames[slot]![country]!.contains(staffName)) {
              _slotCountryStaffNames[slot]![country]!.add(staffName);
            }
          }
        }

        // // ---------------------------------------------------------------------
        // // Target language
        // // ---------------------------------------------------------------------

        // for (final language in languageValues) {
        //   _slotLanguages.putIfAbsent(slot, () => []);

        //   if (!_slotLanguages[slot]!.contains(language)) {
        //     _slotLanguages[slot]!.add(language);
        //   }
        // }

        // ---------------------------------------------------------------------
        // Staff name
        // ---------------------------------------------------------------------

        if (staffName.isNotEmpty) {
          _slotStaffNames.putIfAbsent(slot, () => []);

          if (!_slotStaffNames[slot]!.contains(staffName)) {
            _slotStaffNames[slot]!.add(staffName);
          }
        }
      }
    }

    _isLoading = false;

    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // SLOT DATA GETTERS
  // ---------------------------------------------------------------------------

  int getTotalStaffCountForSlot(String slot) {
    return (_japaneseStaffCounts[slot] ?? 0) + (_intlStudentCounts[slot] ?? 0);
  }

  int getJapaneseStaffCountForSlot(String slot) {
    return _japaneseStaffCounts[slot] ?? 0;
  }

  int getIntlStudentCountForSlot(String slot) {
    return _intlStudentCounts[slot] ?? 0;
  }

  List<String> getCountriesForSlot(String slot) {
    return List.unmodifiable(_slotCountries[slot] ?? []);
  }

  List<String> getLanguagesForSlot(String slot) {
    return List.unmodifiable(_slotLanguages[slot] ?? []);
  }

  List<String> getStaffNamesForSlot(String slot) {
    return List.unmodifiable(_slotStaffNames[slot] ?? []);
  }

  // ---------------------------------------------------------------------------
  // DYNAMIC LANGUAGE DISPLAY
  // ---------------------------------------------------------------------------

  final Map<String, Map<String, String>> _langDisplayMap = {
    'english': {'en': 'English - en', 'ja': '英語 - en'},
    'japanese': {'en': 'Japanese - ja', 'ja': '日本語 - ja'},
    'chinese': {'en': 'Mandarin Chinese - zh', 'ja': '中国語（繁体） - zh'},
    'spanish': {'en': 'Spanish - es', 'ja': 'スペイン語 - es'},
    'swahili': {'en': 'Swahili - sw', 'ja': 'スワヒリ語 - sw'},
    'kikuyu': {'en': 'Kikuyu - ki', 'ja': 'キクユ語 - ki'},
  };

  List<String> getDynamicTargetLanguages() {
    if (_selectedTimeSlot == null) {
      return [];
    }

    final rawLanguages = _slotLanguages[_selectedTimeSlot] ?? [];

    return rawLanguages.map((lang) {
      final normalized = lang.toLowerCase().trim();

      if (_langDisplayMap.containsKey(normalized)) {
        return _langDisplayMap[normalized]![_currentLocale] ?? lang;
      }

      final languageName = normalized.split('-').first.trim();

      if (_langDisplayMap.containsKey(languageName)) {
        return _langDisplayMap[languageName]![_currentLocale] ?? lang;
      }

      return lang;
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // SLOT TIME PARSER
  // ---------------------------------------------------------------------------

  DateTime _parseSlotTimeToDateTime(
    DateTime baseDate,
    String slotRange,
    bool getEndTime,
  ) {
    final parts = slotRange.split(' - ');

    if (parts.length != 2) {
      throw FormatException('Invalid slot format: $slotRange');
    }

    final targetTime = getEndTime ? parts[1] : parts[0];

    final timeParts = targetTime.split(' ');

    if (timeParts.length != 2) {
      throw FormatException('Invalid time format: $targetTime');
    }

    final hhmm = timeParts[0].split(':');

    if (hhmm.length != 2) {
      throw FormatException('Invalid hour/minute format: ${timeParts[0]}');
    }

    int hour = int.parse(hhmm[0]);
    final minute = int.parse(hhmm[1]);

    final period = timeParts[1].toUpperCase();

    if (period == 'PM' && hour != 12) {
      hour += 12;
    }

    if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
  }

  // ---------------------------------------------------------------------------
  // SELECTED SLOT DATE/TIME
  // ---------------------------------------------------------------------------

  DateTime getCalculatedDateTime({required bool getEndTime}) {
    if (_selectedTimeSlot == null) {
      return _selectedDay;
    }

    return _parseSlotTimeToDateTime(
      _selectedDay,
      _selectedTimeSlot!,
      getEndTime,
    );
  }

  // ---------------------------------------------------------------------------
  // SEND RESERVATION
  // ---------------------------------------------------------------------------

  Future<bool> sendBookingPayload(
    Map<String, dynamic> payload, {
    String? customUrl,
  }) async {
    final url = (customUrl != null && customUrl.isNotEmpty)
        ? customUrl
        : _getReservationEndpoint();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      debugPrint('Reservation API returned HTTP ${response.statusCode}');

      return response.statusCode == 200 || response.statusCode == 202;
    } catch (e) {
      debugPrint('Error pipeline call failed: $e');

      return false;
    }
  }

  String? getStaffNameForSlotAndCountry(String slot, String country) {
    final staffNames = _slotCountryStaffNames[slot]?[country];

    if (staffNames == null || staffNames.isEmpty) {
      return null;
    }

    return staffNames.first;
  }
}
