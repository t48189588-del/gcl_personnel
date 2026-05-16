import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/hive_service.dart';
import '../services/logger_service.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class AppProvider with ChangeNotifier {
  final List<StaffMember> _staff = [];
  final List<AvailabilityBlock> _blocks = [];
  OperatingHours _operatingHours = OperatingHours(
    weeklySchedule: List.generate(
      7,
      (index) => DaySchedule(weekday: index + 1),
    ),
  );
  final List<EventProposal> _eventProposals = [];
  final List<WorkingReport> _reports = [];

  StaffMember? _currentJuniorStaff;

  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.light;

  List<StaffMember> get staff => _staff;
  List<AvailabilityBlock> get blocks => _blocks;
  OperatingHours get operatingHours => _operatingHours;
  List<EventProposal> get eventProposals => _eventProposals;
  List<WorkingReport> get reports => _reports;
  StaffMember? get currentJuniorStaff => _currentJuniorStaff;
  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;

  void loadData() {
    _staff.clear();
    _staff.addAll(HiveService.getStaff());
    _blocks.clear();
    _blocks.addAll(HiveService.getBlocks());
    _operatingHours = HiveService.getOperatingHours();
    _reports.clear();
    _reports.addAll(HiveService.getReports());
    _eventProposals.clear();
    _eventProposals.addAll(HiveService.getProposals());
    if (_staff.isNotEmpty) {
      _currentJuniorStaff = _staff
          .where((s) => s.isSetupComplete && !s.isSenior)
          .firstOrNull;
      if (_currentJuniorStaff == null && _staff.isNotEmpty) {
        _currentJuniorStaff = _staff.first;
      }
    }
    notifyListeners();
  }

  void switchLocale(Locale newLocale) {
    _locale = newLocale;
    LoggerService.log('Action', 'logLocaleSwitched|locale=${newLocale.languageCode}');
    notifyListeners();
  }

  void switchThemeMode(ThemeMode mode) {
    _themeMode = mode;
    LoggerService.log('Action', 'logThemeSwitched|mode=${mode.name}');
    notifyListeners();
  }

  void loginAsJunior(String staffId) {
    var s = _staff.where((element) => element.id == staffId);
    if (s.isNotEmpty) {
      _currentJuniorStaff = s.first;
      LoggerService.log('Action', 'logJuniorLogin|name=${_currentJuniorStaff?.name}');
      notifyListeners();
    }
  }

  // --- Senior Methods ---
  void inviteStaff(String email) {
    var newApplicant = StaffMember(
      id: const Uuid().v4(),
      name: 'Pending Applicant',
      email: email,
      nativeLanguage: 'English',
      fluentLanguages: [],
      degree: '-',
      modalityPreference: 'In-Person',
      availabilityRate: 0,
      eventsParticipation: 0,
      providedAssistance: 0,
      isSetupComplete: false,
      isSenior: false,
    );
    _staff.add(newApplicant);
    HiveService.saveStaff(newApplicant);
    LoggerService.log('Action', 'logInvitedStaff|email=$email');
    notifyListeners();
  }

  void upgradeToSenior(String staffId) {
    var index = _staff.indexWhere((s) => s.id == staffId);
    if (index != -1) {
      _staff[index].isSenior = true;
      HiveService.saveStaff(_staff[index]);
      LoggerService.log('Action', 'logUpgradedSenior|name=${_staff[index].name}');
      notifyListeners();
    }
  }

  void finishEmployment(String staffId, {DateTime? endDate}) {
    var index = _staff.indexWhere((s) => s.id == staffId);
    if (index != -1) {
      _staff[index].employmentEndDate = endDate;
      if (endDate == null || endDate.isBefore(DateTime.now())) {
        _staff[index].isActive = false;
      }
      HiveService.saveStaff(_staff[index]);
      LoggerService.log('Action', 'logFinishedEmployment|name=${_staff[index].name}|date=${endDate ?? "Immediately"}');
      notifyListeners();
    }
  }

  void updateDaySchedule(int weekday, String start, String end, bool isClosed) {
    var day = _operatingHours.weeklySchedule.firstWhere(
      (d) => d.weekday == weekday,
    );
    day.startHour = start;
    day.endHour = end;
    day.isClosed = isClosed;
    HiveService.saveOperatingHours(_operatingHours);
    LoggerService.log(
      'Action',
      'logUpdatedDaySchedule|day=$weekday|range=$start-$end|closed=$isClosed',
    );
    notifyListeners();
  }

  void addHoliday(
    DateTime date,
    String message, {
    bool isAllDay = true,
    String start = '09:00',
    String end = '17:00',
  }) {
    addHolidays([date], message, isAllDay: isAllDay, start: start, end: end);
  }

  void addHolidays(
    List<DateTime> dates,
    String message, {
    bool isAllDay = true,
    String start = '09:00',
    String end = '17:00',
  }) {
    for (var date in dates) {
      final dateOnly = DateTime(date.year, date.month, date.day);
      _operatingHours.holidays.add(
        Holiday(
          date: dateOnly,
          message: message,
          isAllDay: isAllDay,
          startTime: start,
          endTime: end,
        ),
      );
    }
    HiveService.saveOperatingHours(_operatingHours);
    LoggerService.log('Action', 'logAddedHolidays|count=${dates.length}');
    notifyListeners();
  }

  void removeHoliday(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    _operatingHours.holidays.removeWhere((h) => h.date == dateOnly);
    HiveService.saveOperatingHours(_operatingHours);
    LoggerService.log('Action', 'logRemovedHoliday|date=$dateOnly');
    notifyListeners();
  }

  // --- Junior Methods ---
  void proposeEvent(String title, String description, DateTime date) {
    if (_currentJuniorStaff == null) return;
    var proposal = EventProposal(
      id: const Uuid().v4(),
      staffId: _currentJuniorStaff!.id,
      title: title,
      description: description,
      proposedDate: date,
      proposerName: _currentJuniorStaff!.name,
    );
    _eventProposals.add(proposal);
    HiveService.saveProposal(proposal);
    LoggerService.log(
      'Action',
      'logEventProposal|title=$title|name=${_currentJuniorStaff?.name}',
    );
    notifyListeners();
  }

  void completeSetup(StaffMember updatedStaff) {
    updatedStaff.isSetupComplete = true;
    _currentJuniorStaff = updatedStaff;
    updateJuniorProfile(updatedStaff);
    LoggerService.log(
      'Action',
      'logCompletedSetup|name=${updatedStaff.name}',
    );
  }

  void updateJuniorProfile(StaffMember updatedStaff) {
    var index = _staff.indexWhere((s) => s.id == updatedStaff.id);
    if (index != -1) {
      _staff[index] = updatedStaff;
      _currentJuniorStaff = updatedStaff;
      HiveService.saveStaff(updatedStaff);
      LoggerService.log('Action', 'logUpdatedProfile|name=${updatedStaff.name}');
      notifyListeners();
    }
  }

  void addBlock(AvailabilityBlock block) {
    _blocks.add(block);
    HiveService.saveBlock(block);
    LoggerService.log(
      'Action',
      'logAddedBlock|staffId=${block.staffId}|time=${block.startTime}',
    );
    notifyListeners();
  }

  void removeBlock(String id) {
    _blocks.removeWhere((b) => b.id == id);
    HiveService.removeBlock(id);
    LoggerService.log('Action', 'logRemovedBlock|id=$id');
    notifyListeners();
  }

  void emergencyReschedule(String blockId) {
    var index = _blocks.indexWhere((b) => b.id == blockId);
    if (index != -1) {
      _blocks[index].needsReplacement = true;
      HiveService.saveBlock(_blocks[index]);
      LoggerService.log(
        'Action',
        'logEmergencyReschedule|id=$blockId',
      );
      notifyListeners();
    }
  }

  void updateBlockModality(String blockId, String newModality) {
    final index = _blocks.indexWhere((b) => b.id == blockId);
    if (index != -1) {
      _blocks[index].modality = newModality;
      // Reset status to proposed if modality changes? Maybe safer.
      _blocks[index].status = 'proposed';
      HiveService.saveBlock(_blocks[index]);
      LoggerService.log('Action', 'logUpdatedBlockModality|id=$blockId|modality=$newModality');
      notifyListeners();
    }
  }

  void approveBlock(String blockId) {
    final index = _blocks.indexWhere((b) => b.id == blockId);
    if (index != -1) {
      _blocks[index].status = 'approved';
      HiveService.saveBlock(_blocks[index]);
      LoggerService.log('Action', 'logApprovedBlock|id=$blockId');
      notifyListeners();
    }
  }

  void approveBlocks(List<String> ids) {
    for (var id in ids) {
      final index = _blocks.indexWhere((b) => b.id == id);
      if (index != -1) {
        _blocks[index].status = 'approved';
        HiveService.saveBlock(_blocks[index]);
      }
    }
    LoggerService.log('Action', 'logApprovedMultipleBlocks|count=${ids.length}');
    notifyListeners();
  }

  void rejectBlocks(List<String> ids) {
    for (var id in ids) {
      final index = _blocks.indexWhere((b) => b.id == id);
      if (index != -1) {
        _blocks[index].status = 'rejected';
        HiveService.saveBlock(_blocks[index]);
      }
    }
    LoggerService.log('Action', 'logRejectedMultipleBlocks|count=${ids.length}');
    notifyListeners();
  }

  void updateEventProposalStatus(String id, String status) {
    final index = _eventProposals.indexWhere((p) => p.id == id);
    if (index != -1) {
      _eventProposals[index].status = status;
      HiveService.saveProposal(_eventProposals[index]);
      LoggerService.log('Action', 'logUpdatedProposalStatus|id=$id|status=$status');
      notifyListeners();
    }
  }

  void approveAllProposedBlocks(String staffId, DateTime month) {
    bool changed = false;
    for (var b in _blocks) {
      if (b.staffId == staffId && 
          b.startTime.year == month.year && 
          b.startTime.month == month.month && 
          b.status == 'proposed') {
        b.status = 'approved';
        HiveService.saveBlock(b);
        changed = true;
      }
    }
    if (changed) {
      LoggerService.log('Action', 'logApprovedAllBlocks|staffId=$staffId|month=${month.year}-${month.month}');
      notifyListeners();
    }
  }

  // --- Working Reports Logic ---

  List<WorkingReport> getPendingReports() {
    if (_currentJuniorStaff == null) return [];
    
    // 1. Get all blocks for current staff in the past
    final now = DateTime.now();
    final myPastBlocks = _blocks.where((b) => 
      b.staffId == _currentJuniorStaff!.id && 
      b.status == 'approved' &&
      b.startTime.add(const Duration(minutes: 30)).isBefore(now)
    ).toList();
    
    if (myPastBlocks.isEmpty) return [];
    
    // Sort by time
    myPastBlocks.sort((a, b) => a.startTime.compareTo(b.startTime));
    
    // 2. Group into contiguous shifts
    List<List<AvailabilityBlock>> shifts = [];
    if (myPastBlocks.isNotEmpty) {
      List<AvailabilityBlock> currentShift = [myPastBlocks.first];
      for (int i = 1; i < myPastBlocks.length; i++) {
        final prev = myPastBlocks[i-1];
        final curr = myPastBlocks[i];
        
        // Contiguous if same day and curr.start == prev.start + 30m
        if (curr.startTime.difference(prev.startTime).inMinutes == 30 && 
            curr.startTime.day == prev.startTime.day) {
          currentShift.add(curr);
        } else {
          shifts.add(currentShift);
          currentShift = [curr];
        }
      }
      shifts.add(currentShift);
    }
    
    // 3. Filter out shifts that already have a submitted report
    List<WorkingReport> pending = [];
    for (var shiftBlocks in shifts) {
      final start = shiftBlocks.first.startTime;
      final end = shiftBlocks.last.startTime.add(const Duration(minutes: 30));
      final date = DateTime(start.year, start.month, start.day);
      
      final alreadyReported = _reports.any((r) => 
        r.staffId == _currentJuniorStaff!.id && 
        r.reportDate == date && 
        r.scheduledStart == start && 
        r.isSubmitted
      );
      
      if (!alreadyReported) {
        pending.add(WorkingReport(
          id: const Uuid().v4(),
          staffId: _currentJuniorStaff!.id,
          reportDate: date,
          scheduledStart: start,
          scheduledEnd: end,
          confirmedStart: start,
          confirmedEnd: end,
          workDone: '',
        ));
      }
    }
    
    return pending;
  }

  void submitWorkingReport(WorkingReport report) {
    report.isSubmitted = true;
    _reports.add(report);
    HiveService.saveReport(report);
    LoggerService.log('Action', 'logSubmittedReport|date=${report.reportDate}');
    notifyListeners();
  }

  void addLog(String type, String message) {
    LoggerService.log(type, message);
    notifyListeners();
  }

  // --- Import Methods ---

  Future<void> importStaffFromJson(String jsonContent) async {
    try {
      final List<dynamic> data = json.decode(jsonContent);
      for (var item in data) {
        // Ensure ID exists or generate one
        if (item['id'] == null) {
          item['id'] = const Uuid().v4();
        }
        final newStaff = StaffMember.fromJson(item);
        
        // Update if exists, otherwise add
        final index = _staff.indexWhere((s) => s.email == newStaff.email);
        if (index != -1) {
          _staff[index] = newStaff;
        } else {
          _staff.add(newStaff);
        }
        HiveService.saveStaff(newStaff);
      }
      LoggerService.log('Action', 'logImportedStaff|count=${data.length}');
      notifyListeners();
    } catch (e) {
      debugPrint('Error importing staff: $e');
      rethrow;
    }
  }

  Future<void> importDataFromCsv(List<List<dynamic>> rows) async {
    try {
      if (rows.isEmpty) return;
      
      // Skip header if it contains "Type"
      int startIndex = 0;
      if (rows.first.isNotEmpty && rows.first.first.toString().toLowerCase().contains('type')) {
        startIndex = 1;
      }

      for (int i = startIndex; i < rows.length; i++) {
        final row = rows[i];
        if (row.length < 5) continue;

        final String type = row[0].toString().toUpperCase();
        final String email = row[1].toString();
        final String titleOrModality = row[2].toString();
        final String description = row[3].toString();
        final String dateStr = row[4].toString();
        
        final staff = _staff.where((s) => s.email == email).firstOrNull;
        if (staff == null) continue;

        if (type == 'BLOCK') {
          final String startStr = row[5].toString();
          final String endStr = row[6].toString();
          
          final date = DateTime.parse(dateStr);
          final startParts = startStr.split(':');
          final startTime = DateTime(date.year, date.month, date.day, int.parse(startParts[0]), int.parse(startParts[1]));
          
          final endParts = endStr.split(':');
          final endTime = DateTime(date.year, date.month, date.day, int.parse(endParts[0]), int.parse(endParts[1]));

          // Create blocks in 30min increments between start and end
          DateTime current = startTime;
          while (current.isBefore(endTime)) {
            final block = AvailabilityBlock(
              id: const Uuid().v4(),
              startTime: current,
              staffId: staff.id,
              modality: titleOrModality,
            );
            _blocks.add(block);
            HiveService.saveBlock(block);
            current = current.add(const Duration(minutes: 30));
          }
        } else if (type == 'EVENT') {
          final proposal = EventProposal(
            id: const Uuid().v4(),
            staffId: staff.id,
            title: titleOrModality,
            description: description,
            proposedDate: DateTime.parse(dateStr),
            proposerName: staff.name,
          );
          _eventProposals.add(proposal);
          HiveService.saveProposal(proposal);
        }
      }
      LoggerService.log('Action', 'logImportedCsvData|rows=${rows.length - startIndex}');
      notifyListeners();
    } catch (e) {
      debugPrint('Error importing CSV: $e');
      rethrow;
    }
  }
}
