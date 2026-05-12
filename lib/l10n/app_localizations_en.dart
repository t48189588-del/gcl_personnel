// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GCL Personnel System';

  @override
  String get selectYourRole => 'Select Your Role';

  @override
  String get seniorStaff => 'Senior Staff';

  @override
  String get juniorStaff => 'Junior Staff';

  @override
  String get developer => 'Developer';

  @override
  String get commanderView => 'Commander View - Senior Staff';

  @override
  String get metrics => 'Metrics';

  @override
  String get guardrails => 'Guardrails';

  @override
  String get inviteStaff => 'Invite Staff';

  @override
  String get exportExcel => 'Export Metrics to Excel';

  @override
  String get searchHint => 'Search by Name or Lang';

  @override
  String get name => 'Name';

  @override
  String get nativeLang => 'Native Lang';

  @override
  String get degree => 'Degree';

  @override
  String get modality => 'Modality';

  @override
  String get availRate => 'Avail. Rate';

  @override
  String get eventsPart => 'Events Part.';

  @override
  String get assistance => 'Assistance';

  @override
  String get alerts => 'Alerts';

  @override
  String get operatingHours => 'Operating Hours By Day';

  @override
  String get holidays => 'Holidays & Closures';

  @override
  String get addHoliday => 'Add Holiday';

  @override
  String get holidayMessagePrompt => 'Holiday Broadcast Message';

  @override
  String get saveHoliday => 'Save Holiday';

  @override
  String get inviteStaffButton => 'Send Invite';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get selfServicePortal => 'Self-Service Portal - Junior Staff';

  @override
  String get schedule => 'Schedule';

  @override
  String get profile => 'Profile';

  @override
  String get noticeBoard => 'Notice Board';

  @override
  String get holidayNotice => 'HOLIDAY CLOSURE';

  @override
  String get addBlock => 'Add Block';

  @override
  String get removeBlock => 'Remove Block';

  @override
  String get emergencyReschedule => 'EMERGENCY RESCHEDULE';

  @override
  String get personalProfile => 'Personal Profile';

  @override
  String get saveProfile => 'Save & Update Profile';

  @override
  String get developerDashboard => 'Developer Dashboard';

  @override
  String get logs => 'System Logs';

  @override
  String get clearLogs => 'Clear Logs';

  @override
  String get allDay => 'All Day';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get prev => 'Prev';

  @override
  String get next => 'Next';

  @override
  String get upgradeToSenior => 'Upgrade to Senior';

  @override
  String get eventProposal => 'Event Proposal';

  @override
  String get attendanceReminder => 'Check Attendance Reminder';

  @override
  String get otherLanguages => 'Other Speaking Languages';

  @override
  String get uploadPhoto => 'Upload Profile Photo';

  @override
  String get proposeEvent => 'Propose Event';

  @override
  String get proposalTitle => 'Event Title';

  @override
  String get proposalDescription => 'Event Description';

  @override
  String get proposedDate => 'Proposed Date';

  @override
  String get masterCalendarExport => 'Master Calendar Export (Monthly)';

  @override
  String get attendanceWarning =>
      'Remember to check your attendance regularly!';

  @override
  String get exportICS => 'Export to ICS';

  @override
  String get toggleTheme => 'Toggle Theme';

  @override
  String get role => 'Role';

  @override
  String get day => 'Day';

  @override
  String get closed => 'Closed';

  @override
  String get currentlyStudying => 'Currently Studying';

  @override
  String get originCountry => 'Origin Country';

  @override
  String get cancel => 'Cancel';

  @override
  String get selectDate => 'Select Date';

  @override
  String get openInviteLink => 'Open Invite Link';

  @override
  String get senior => 'Senior';

  @override
  String get junior => 'Junior';

  @override
  String get online => 'Online';

  @override
  String get inPerson => 'In Person';

  @override
  String get both => 'Both';

  @override
  String get none => 'None';

  @override
  String get mockEmailTitle => 'Mock Email Received!';

  @override
  String mockEmailContent(String email) {
    return 'Verification sent to $email\n\nClick link to test setup profile.';
  }

  @override
  String get selectJuniorProfileTitle => 'Select Junior Profile';

  @override
  String get proposalSubmitted => 'Proposal Submitted!';

  @override
  String get noAnnouncements => 'No announcements yet.';

  @override
  String get developerDashboardTitle => 'Developer Dashboard - System Logs';

  @override
  String get logEntryTypeAction => 'Action';

  @override
  String get logEntryTypeInteraction => 'Interaction';

  @override
  String get clearLogsTooltip => 'Clear Logs';

  @override
  String get currentlyStudyingHint => 'What are you studying?';

  @override
  String get originCountryHint => 'Where are you from?';

  @override
  String get finishEmployment => 'Finish Employment';

  @override
  String get finishImmediately => 'Immediately';

  @override
  String get finishFutureDate => 'Future Last Date';

  @override
  String get employmentEndDialogTitle => 'Finish Employment';

  @override
  String get employmentEndDialogContent =>
      'Select your last day of employment. This will disable your scheduling calendar after that date.';

  @override
  String get selectModality => 'Select Modality';

  @override
  String get loading => 'Loading...';

  @override
  String get noStaffLoggedIn => 'No Staff logged in.';

  @override
  String get welcomeCompleteProfile =>
      'Welcome! Please complete your profile to access the portal.';

  @override
  String get completeYourProfile => 'Complete Your Profile';

  @override
  String get fullName => 'Full Name';

  @override
  String get completeSetupAndLogin => 'Complete Setup & Login';

  @override
  String get personalDescription => 'Personal Description';

  @override
  String get workingReports => 'Working Reports';

  @override
  String get submitReport => 'Submit Report';

  @override
  String get reportPending => 'Report Pending';

  @override
  String get pendingReportsNotice =>
      'You have pending working reports to complete.';

  @override
  String get confirmedStartTime => 'Confirmed Start';

  @override
  String get confirmedEndTime => 'Confirmed End';

  @override
  String get workDoneLabel => 'What did you do?';

  @override
  String get workDoneHint => 'Describe your tasks during this shift';

  @override
  String get reportDate => 'Report Date';

  @override
  String get scheduledTime => 'Scheduled Time';

  @override
  String get workedHours => 'Worked Hours';

  @override
  String get missingReport => 'Missing Report';

  @override
  String get filledReport => 'Filled Report';

  @override
  String get affiliation => 'Affiliation';

  @override
  String get helpConfirmedTime =>
      'Please adjust the start and end times to reflect your actual working hours.';

  @override
  String get helpWorkDone =>
      'Briefly describe the tasks and accomplishments during this shift.';

  @override
  String get socialMetrics => 'Social Metrics';

  @override
  String get refreshMetrics => 'Refresh Metrics';

  @override
  String get kanaName => 'Kana Name (かな)';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get status => 'Status';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get totalHours => 'Total Hours';

  @override
  String get proposed => 'Proposed';

  @override
  String get approved => 'Approved';

  @override
  String get rejected => 'Rejected';

  @override
  String get nextMonthSchedule => 'Next Month Availability';

  @override
  String get approveAll => 'Approve All';

  @override
  String get proposerName => 'Proposer';

  @override
  String get bulkApprove => 'Bulk Approve';

  @override
  String get bulkReject => 'Bulk Reject';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get employment => 'Employment';

  @override
  String get youtubeStats => 'YouTube Stats';

  @override
  String get instagramStats => 'Instagram Stats';

  @override
  String get xStats => 'X (Twitter) Stats';

  @override
  String get week => 'Week';

  @override
  String get month => 'Month';

  @override
  String get noPendingShifts => 'No pending shifts for this period';

  @override
  String get noEventProposals => 'No event proposals yet.';

  @override
  String get actionRequiredReports =>
      'Action Required: Please complete your missing working reports';

  @override
  String get date => 'Date';

  @override
  String get fillReport => 'Fill Report';

  @override
  String logLocaleSwitched(String locale) {
    return 'Switched Locale to $locale';
  }

  @override
  String logThemeSwitched(String mode) {
    return 'Switched Theme Mode to $mode';
  }

  @override
  String logJuniorLogin(String name) {
    return 'Junior Login: $name';
  }

  @override
  String logInvitedStaff(String email) {
    return 'Invited Staff: $email';
  }

  @override
  String logUpgradedSenior(String name) {
    return 'Upgraded $name to Senior';
  }

  @override
  String logFinishedEmployment(String name, String date) {
    return 'Finished employment for $name (End Date: $date)';
  }

  @override
  String logUpdatedDaySchedule(String day, String range, bool closed) {
    return 'Updated DaySchedule for $day: $range (Closed: $closed)';
  }

  @override
  String logAddedHolidays(int count) {
    return 'Added holidays for $count days';
  }

  @override
  String logRemovedHoliday(String date) {
    return 'Removed holiday on $date';
  }

  @override
  String logEventProposal(String title, String name) {
    return 'Event Proposal: $title by $name';
  }

  @override
  String logCompletedSetup(String name) {
    return 'Completed applicant setup for $name';
  }

  @override
  String logUpdatedProfile(String name) {
    return 'Updated profile for $name';
  }

  @override
  String logAddedBlock(String staffId, String time) {
    return 'Added block for $staffId at $time';
  }

  @override
  String logRemovedBlock(String id) {
    return 'Removed block $id';
  }

  @override
  String logEmergencyReschedule(String id) {
    return 'Emergency Reschedule invoked for block $id';
  }

  @override
  String logUpdatedBlockModality(String id, String modality) {
    return 'Updated block modality for $id to $modality';
  }

  @override
  String logApprovedBlock(String id) {
    return 'Approved block $id';
  }

  @override
  String logApprovedMultipleBlocks(int count) {
    return 'Approved $count blocks';
  }

  @override
  String logRejectedMultipleBlocks(int count) {
    return 'Rejected $count blocks';
  }

  @override
  String logUpdatedProposalStatus(String id, String status) {
    return 'Updated proposal $id to $status';
  }

  @override
  String logApprovedAllBlocks(String staffId, String month) {
    return 'Approved all proposed blocks for $staffId in $month';
  }

  @override
  String logSubmittedReport(String date) {
    return 'Submitted Working Report for $date';
  }

  @override
  String get logClearedLogs => 'Cleared Logs';

  @override
  String get bachelors => 'Bachelors';

  @override
  String get masters => 'Masters';

  @override
  String get phd => 'PhD';

  @override
  String get research => 'Research';

  @override
  String get subscribers => 'Subscribers';

  @override
  String get followers => 'Followers';

  @override
  String get views => 'Views';

  @override
  String get posts => 'Posts';

  @override
  String get error => 'Error';

  @override
  String get exportAllReportsTooltip =>
      'Export All Working Reports (Multiple Files)';

  @override
  String get selectDaysPrompt => 'Select days (tap to toggle):';

  @override
  String get selectStaffPrompt =>
      'Please select a staff member to view reports.';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String get fluentLanguages => 'Fluent Languages';

  @override
  String get commPreference => 'Communication Preference';

  @override
  String byAuthorOnDate(Object author, Object date) {
    return 'By $author on $date';
  }
}
