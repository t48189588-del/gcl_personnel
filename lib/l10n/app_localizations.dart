import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'GCL Personnel System'**
  String get appTitle;

  /// No description provided for @selectYourRole.
  ///
  /// In en, this message translates to:
  /// **'Select Your Role'**
  String get selectYourRole;

  /// No description provided for @seniorStaff.
  ///
  /// In en, this message translates to:
  /// **'Senior Staff'**
  String get seniorStaff;

  /// No description provided for @juniorStaff.
  ///
  /// In en, this message translates to:
  /// **'Junior Staff'**
  String get juniorStaff;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @commanderView.
  ///
  /// In en, this message translates to:
  /// **'Commander View - Senior Staff'**
  String get commanderView;

  /// No description provided for @metrics.
  ///
  /// In en, this message translates to:
  /// **'Metrics'**
  String get metrics;

  /// No description provided for @guardrails.
  ///
  /// In en, this message translates to:
  /// **'Guardrails'**
  String get guardrails;

  /// No description provided for @inviteStaff.
  ///
  /// In en, this message translates to:
  /// **'Invite Staff'**
  String get inviteStaff;

  /// No description provided for @exportExcel.
  ///
  /// In en, this message translates to:
  /// **'Export Metrics to Excel'**
  String get exportExcel;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by Name or Lang'**
  String get searchHint;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nativeLang.
  ///
  /// In en, this message translates to:
  /// **'Native Lang'**
  String get nativeLang;

  /// No description provided for @degree.
  ///
  /// In en, this message translates to:
  /// **'Degree'**
  String get degree;

  /// No description provided for @modality.
  ///
  /// In en, this message translates to:
  /// **'Modality'**
  String get modality;

  /// No description provided for @availRate.
  ///
  /// In en, this message translates to:
  /// **'Avail. Rate'**
  String get availRate;

  /// No description provided for @eventsPart.
  ///
  /// In en, this message translates to:
  /// **'Events Part.'**
  String get eventsPart;

  /// No description provided for @assistance.
  ///
  /// In en, this message translates to:
  /// **'Assistance'**
  String get assistance;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @operatingHours.
  ///
  /// In en, this message translates to:
  /// **'Operating Hours By Day'**
  String get operatingHours;

  /// No description provided for @holidays.
  ///
  /// In en, this message translates to:
  /// **'Holidays & Closures'**
  String get holidays;

  /// No description provided for @addHoliday.
  ///
  /// In en, this message translates to:
  /// **'Add Holiday'**
  String get addHoliday;

  /// No description provided for @holidayMessagePrompt.
  ///
  /// In en, this message translates to:
  /// **'Holiday Broadcast Message'**
  String get holidayMessagePrompt;

  /// No description provided for @saveHoliday.
  ///
  /// In en, this message translates to:
  /// **'Save Holiday'**
  String get saveHoliday;

  /// No description provided for @inviteStaffButton.
  ///
  /// In en, this message translates to:
  /// **'Send Invite'**
  String get inviteStaffButton;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailLabel;

  /// No description provided for @selfServicePortal.
  ///
  /// In en, this message translates to:
  /// **'Self-Service Portal - Junior Staff'**
  String get selfServicePortal;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @noticeBoard.
  ///
  /// In en, this message translates to:
  /// **'Notice Board'**
  String get noticeBoard;

  /// No description provided for @holidayNotice.
  ///
  /// In en, this message translates to:
  /// **'HOLIDAY CLOSURE'**
  String get holidayNotice;

  /// No description provided for @addBlock.
  ///
  /// In en, this message translates to:
  /// **'Add Block'**
  String get addBlock;

  /// No description provided for @removeBlock.
  ///
  /// In en, this message translates to:
  /// **'Remove Block'**
  String get removeBlock;

  /// No description provided for @emergencyReschedule.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY RESCHEDULE'**
  String get emergencyReschedule;

  /// No description provided for @personalProfile.
  ///
  /// In en, this message translates to:
  /// **'Personal Profile'**
  String get personalProfile;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save & Update Profile'**
  String get saveProfile;

  /// No description provided for @developerDashboard.
  ///
  /// In en, this message translates to:
  /// **'Developer Dashboard'**
  String get developerDashboard;

  /// No description provided for @logs.
  ///
  /// In en, this message translates to:
  /// **'System Logs'**
  String get logs;

  /// No description provided for @clearLogs.
  ///
  /// In en, this message translates to:
  /// **'Clear Logs'**
  String get clearLogs;

  /// No description provided for @allDay.
  ///
  /// In en, this message translates to:
  /// **'All Day'**
  String get allDay;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @prev.
  ///
  /// In en, this message translates to:
  /// **'Prev'**
  String get prev;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @upgradeToSenior.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Senior'**
  String get upgradeToSenior;

  /// No description provided for @eventProposal.
  ///
  /// In en, this message translates to:
  /// **'Event Proposal'**
  String get eventProposal;

  /// No description provided for @attendanceReminder.
  ///
  /// In en, this message translates to:
  /// **'Check Attendance Reminder'**
  String get attendanceReminder;

  /// No description provided for @otherLanguages.
  ///
  /// In en, this message translates to:
  /// **'Other Speaking Languages'**
  String get otherLanguages;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Profile Photo'**
  String get uploadPhoto;

  /// No description provided for @proposeEvent.
  ///
  /// In en, this message translates to:
  /// **'Propose Event'**
  String get proposeEvent;

  /// No description provided for @proposalTitle.
  ///
  /// In en, this message translates to:
  /// **'Event Title'**
  String get proposalTitle;

  /// No description provided for @proposalDescription.
  ///
  /// In en, this message translates to:
  /// **'Event Description'**
  String get proposalDescription;

  /// No description provided for @proposedDate.
  ///
  /// In en, this message translates to:
  /// **'Proposed Date'**
  String get proposedDate;

  /// No description provided for @masterCalendarExport.
  ///
  /// In en, this message translates to:
  /// **'Master Calendar Export (Monthly)'**
  String get masterCalendarExport;

  /// No description provided for @attendanceWarning.
  ///
  /// In en, this message translates to:
  /// **'Remember to check your attendance regularly!'**
  String get attendanceWarning;

  /// No description provided for @exportICS.
  ///
  /// In en, this message translates to:
  /// **'Export to ICS'**
  String get exportICS;

  /// No description provided for @toggleTheme.
  ///
  /// In en, this message translates to:
  /// **'Toggle Theme'**
  String get toggleTheme;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @currentlyStudying.
  ///
  /// In en, this message translates to:
  /// **'Currently Studying'**
  String get currentlyStudying;

  /// No description provided for @originCountry.
  ///
  /// In en, this message translates to:
  /// **'Origin Country'**
  String get originCountry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @openInviteLink.
  ///
  /// In en, this message translates to:
  /// **'Open Invite Link'**
  String get openInviteLink;

  /// No description provided for @senior.
  ///
  /// In en, this message translates to:
  /// **'Senior'**
  String get senior;

  /// No description provided for @junior.
  ///
  /// In en, this message translates to:
  /// **'Junior'**
  String get junior;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @inPerson.
  ///
  /// In en, this message translates to:
  /// **'In Person'**
  String get inPerson;

  /// No description provided for @both.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get both;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @mockEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Mock Email Received!'**
  String get mockEmailTitle;

  /// No description provided for @mockEmailContent.
  ///
  /// In en, this message translates to:
  /// **'Verification sent to {email}\n\nClick link to test setup profile.'**
  String mockEmailContent(String email);

  /// No description provided for @selectJuniorProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Junior Profile'**
  String get selectJuniorProfileTitle;

  /// No description provided for @proposalSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Proposal Submitted!'**
  String get proposalSubmitted;

  /// No description provided for @noAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'No announcements yet.'**
  String get noAnnouncements;

  /// No description provided for @developerDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Developer Dashboard - System Logs'**
  String get developerDashboardTitle;

  /// No description provided for @logEntryTypeAction.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get logEntryTypeAction;

  /// No description provided for @logEntryTypeInteraction.
  ///
  /// In en, this message translates to:
  /// **'Interaction'**
  String get logEntryTypeInteraction;

  /// No description provided for @clearLogsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear Logs'**
  String get clearLogsTooltip;

  /// No description provided for @currentlyStudyingHint.
  ///
  /// In en, this message translates to:
  /// **'What are you studying?'**
  String get currentlyStudyingHint;

  /// No description provided for @originCountryHint.
  ///
  /// In en, this message translates to:
  /// **'Where are you from?'**
  String get originCountryHint;

  /// No description provided for @finishEmployment.
  ///
  /// In en, this message translates to:
  /// **'Finish Employment'**
  String get finishEmployment;

  /// No description provided for @finishImmediately.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get finishImmediately;

  /// No description provided for @finishFutureDate.
  ///
  /// In en, this message translates to:
  /// **'Future Last Date'**
  String get finishFutureDate;

  /// No description provided for @employmentEndDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish Employment'**
  String get employmentEndDialogTitle;

  /// No description provided for @employmentEndDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Select your last day of employment. This will disable your scheduling calendar after that date.'**
  String get employmentEndDialogContent;

  /// No description provided for @selectModality.
  ///
  /// In en, this message translates to:
  /// **'Select Modality'**
  String get selectModality;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noStaffLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'No Staff logged in.'**
  String get noStaffLoggedIn;

  /// No description provided for @welcomeCompleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Welcome! Please complete your profile to access the portal.'**
  String get welcomeCompleteProfile;

  /// No description provided for @completeYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Profile'**
  String get completeYourProfile;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @completeSetupAndLogin.
  ///
  /// In en, this message translates to:
  /// **'Complete Setup & Login'**
  String get completeSetupAndLogin;

  /// No description provided for @personalDescription.
  ///
  /// In en, this message translates to:
  /// **'Personal Description'**
  String get personalDescription;

  /// No description provided for @workingReports.
  ///
  /// In en, this message translates to:
  /// **'Working Reports'**
  String get workingReports;

  /// No description provided for @submitReport.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get submitReport;

  /// No description provided for @reportPending.
  ///
  /// In en, this message translates to:
  /// **'Report Pending'**
  String get reportPending;

  /// No description provided for @pendingReportsNotice.
  ///
  /// In en, this message translates to:
  /// **'You have pending working reports to complete.'**
  String get pendingReportsNotice;

  /// No description provided for @confirmedStartTime.
  ///
  /// In en, this message translates to:
  /// **'Confirmed Start'**
  String get confirmedStartTime;

  /// No description provided for @confirmedEndTime.
  ///
  /// In en, this message translates to:
  /// **'Confirmed End'**
  String get confirmedEndTime;

  /// No description provided for @workDoneLabel.
  ///
  /// In en, this message translates to:
  /// **'What did you do?'**
  String get workDoneLabel;

  /// No description provided for @workDoneHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your tasks during this shift'**
  String get workDoneHint;

  /// No description provided for @reportDate.
  ///
  /// In en, this message translates to:
  /// **'Report Date'**
  String get reportDate;

  /// No description provided for @scheduledTime.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Time'**
  String get scheduledTime;

  /// No description provided for @workedHours.
  ///
  /// In en, this message translates to:
  /// **'Worked Hours'**
  String get workedHours;

  /// No description provided for @missingReport.
  ///
  /// In en, this message translates to:
  /// **'Missing Report'**
  String get missingReport;

  /// No description provided for @filledReport.
  ///
  /// In en, this message translates to:
  /// **'Filled Report'**
  String get filledReport;

  /// No description provided for @affiliation.
  ///
  /// In en, this message translates to:
  /// **'Affiliation'**
  String get affiliation;

  /// No description provided for @helpConfirmedTime.
  ///
  /// In en, this message translates to:
  /// **'Please adjust the start and end times to reflect your actual working hours.'**
  String get helpConfirmedTime;

  /// No description provided for @helpWorkDone.
  ///
  /// In en, this message translates to:
  /// **'Briefly describe the tasks and accomplishments during this shift.'**
  String get helpWorkDone;

  /// No description provided for @socialMetrics.
  ///
  /// In en, this message translates to:
  /// **'Social Metrics'**
  String get socialMetrics;

  /// No description provided for @refreshMetrics.
  ///
  /// In en, this message translates to:
  /// **'Refresh Metrics'**
  String get refreshMetrics;

  /// No description provided for @kanaName.
  ///
  /// In en, this message translates to:
  /// **'Kana Name (かな)'**
  String get kanaName;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @totalHours.
  ///
  /// In en, this message translates to:
  /// **'Total Hours'**
  String get totalHours;

  /// No description provided for @proposed.
  ///
  /// In en, this message translates to:
  /// **'Proposed'**
  String get proposed;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @nextMonthSchedule.
  ///
  /// In en, this message translates to:
  /// **'Next Month Availability'**
  String get nextMonthSchedule;

  /// No description provided for @approveAll.
  ///
  /// In en, this message translates to:
  /// **'Approve All'**
  String get approveAll;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
