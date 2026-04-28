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
}
