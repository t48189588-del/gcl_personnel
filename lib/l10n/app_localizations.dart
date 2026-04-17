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
