import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/hive_service.dart';
import '../services/logger_service.dart';
import 'package:uuid/uuid.dart';

class AppProvider with ChangeNotifier {
  List<StaffMember> _staff = [];
  List<AvailabilityBlock> _blocks = [];
  OperatingHours _operatingHours = OperatingHours(
    weeklySchedule: List.generate(7, (index) => DaySchedule(weekday: index + 1))
  );
  List<EventProposal> _eventProposals = [];
  
  StaffMember? _currentJuniorStaff;
  
  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.light;

  List<StaffMember> get staff => _staff;
  List<AvailabilityBlock> get blocks => _blocks;
  OperatingHours get operatingHours => _operatingHours;
  List<EventProposal> get eventProposals => _eventProposals;
  StaffMember? get currentJuniorStaff => _currentJuniorStaff;
  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;

  void loadData() {
    _staff = HiveService.getStaff();
    _blocks = HiveService.getBlocks();
    _operatingHours = HiveService.getOperatingHours();
    // Load event proposals if stored, otherwise empty for now
    if (_staff.isNotEmpty) {
      _currentJuniorStaff = _staff.where((s) => s.isSetupComplete && !s.isSenior).firstOrNull;
      if (_currentJuniorStaff == null && _staff.isNotEmpty) {
        _currentJuniorStaff = _staff.first;
      }
    }
    notifyListeners();
  }

  void switchLocale(Locale newLocale) {
    _locale = newLocale;
    LoggerService.log('Action', 'Switched Locale to ${newLocale.languageCode}');
    notifyListeners();
  }

  void switchThemeMode(ThemeMode mode) {
    _themeMode = mode;
    LoggerService.log('Action', 'Switched Theme Mode to ${mode.name}');
    notifyListeners();
  }

  void loginAsJunior(String staffId) {
    var s = _staff.where((element) => element.id == staffId);
    if (s.isNotEmpty) {
      _currentJuniorStaff = s.first;
      LoggerService.log('Action', 'Junior Login: ${_currentJuniorStaff?.name}');
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
    LoggerService.log('Action', 'Invited Staff: $email');
    notifyListeners();
  }

  void upgradeToSenior(String staffId) {
    var index = _staff.indexWhere((s) => s.id == staffId);
    if (index != -1) {
      _staff[index].isSenior = true;
      HiveService.saveStaff(_staff[index]);
      LoggerService.log('Action', 'Upgraded ${_staff[index].name} to Senior');
      notifyListeners();
    }
  }

  void updateDaySchedule(int weekday, String start, String end, bool isClosed) {
    var day = _operatingHours.weeklySchedule.firstWhere((d) => d.weekday == weekday);
    day.startHour = start;
    day.endHour = end;
    day.isClosed = isClosed;
    HiveService.saveOperatingHours(_operatingHours);
    LoggerService.log('Action', 'Updated DaySchedule for $weekday: $start-$end closed:$isClosed');
    notifyListeners();
  }

  void addHoliday(DateTime date, String message, {bool isAllDay = true, String start = '09:00', String end = '17:00'}) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    _operatingHours.holidays.add(Holiday(
      date: dateOnly, 
      message: message,
      isAllDay: isAllDay,
      startTime: start,
      endTime: end,
    ));
    HiveService.saveOperatingHours(_operatingHours);
    LoggerService.log('Action', 'Added holiday on $dateOnly with msg: $message');
    notifyListeners();
  }
  
  void removeHoliday(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    _operatingHours.holidays.removeWhere((h) => h.date == dateOnly);
    HiveService.saveOperatingHours(_operatingHours);
    LoggerService.log('Action', 'Removed holiday on $dateOnly');
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
    );
    _eventProposals.add(proposal);
    LoggerService.log('Action', 'Event Proposal: $title by ${_currentJuniorStaff?.name}');
    notifyListeners();
  }

  void completeSetup(StaffMember updatedStaff) {
    updatedStaff.isSetupComplete = true;
    _currentJuniorStaff = updatedStaff;
    updateJuniorProfile(updatedStaff);
    LoggerService.log('Action', 'Completed applicant setup for ${updatedStaff.name}');
  }

  void updateJuniorProfile(StaffMember updatedStaff) {
    var index = _staff.indexWhere((s) => s.id == updatedStaff.id);
    if (index != -1) {
      _staff[index] = updatedStaff;
      _currentJuniorStaff = updatedStaff;
      HiveService.saveStaff(updatedStaff);
      LoggerService.log('Action', 'Updated profile for ${updatedStaff.name}');
      notifyListeners();
    }
  }

  void addBlock(AvailabilityBlock block) {
    _blocks.add(block);
    HiveService.saveBlock(block);
    LoggerService.log('Action', 'Added block for ${block.staffId} at ${block.startTime}');
    notifyListeners();
  }

  void removeBlock(String id) {
    _blocks.removeWhere((b) => b.id == id);
    HiveService.removeBlock(id);
    LoggerService.log('Action', 'Removed block $id');
    notifyListeners();
  }

  void emergencyReschedule(String blockId) {
    var index = _blocks.indexWhere((b) => b.id == blockId);
    if (index != -1) {
      _blocks[index].needsReplacement = true;
      HiveService.saveBlock(_blocks[index]);
      LoggerService.log('Action', 'Emergency Reschedule invoked for block $blockId');
      notifyListeners();
    }
  }
}
