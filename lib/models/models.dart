import 'package:uuid/uuid.dart';

class StaffMember {
  final String id;
  String name;
  String email;
  String nativeLanguage;
  List<String> fluentLanguages;
  List<String> otherLanguages;
  String degree;
  String modalityPreference;
  double availabilityRate;
  int eventsParticipation;
  int providedAssistance;
  String profilePicturePath;
  String personalDescription;
  String commPreference;
  bool isSetupComplete;
  bool isSenior;
  String originCountry;
  String affiliation;
  String kanaName;
  DateTime? employmentEndDate;
  bool isActive;

  StaffMember({
    required this.id,
    required this.name,
    this.email = '',
    required this.nativeLanguage,
    required this.fluentLanguages,
    this.otherLanguages = const [],
    required this.degree,
    required this.modalityPreference,
    required this.availabilityRate,
    required this.eventsParticipation,
    required this.providedAssistance,
    this.profilePicturePath = '',
    this.personalDescription = '',
    this.commPreference = 'Email',
    this.isSetupComplete = true,
    this.isSenior = false,
    this.originCountry = '',
    this.affiliation = '',
    this.kanaName = '',
    this.employmentEndDate,
    this.isActive = true,
  });

  factory StaffMember.fromJson(Map<String, dynamic> json) {
    return StaffMember(
      id: json['id'],
      name: json['name'],
      email: json['email'] ?? '',
      nativeLanguage: json['nativeLanguage'],
      fluentLanguages: List<String>.from(json['fluentLanguages'] ?? []),
      otherLanguages: List<String>.from(json['otherLanguages'] ?? []),
      degree: json['degree'],
      modalityPreference: json['modalityPreference'],
      availabilityRate: (json['availabilityRate'] ?? 0.0).toDouble(),
      eventsParticipation: json['eventsParticipation'] ?? 0,
      providedAssistance: json['providedAssistance'] ?? 0,
      profilePicturePath: json['profilePicturePath'] ?? '',
      personalDescription: json['personalDescription'] ?? '',
      commPreference: json['commPreference'] ?? 'Email',
      isSetupComplete: json['isSetupComplete'] ?? true,
      isSenior: json['isSenior'] ?? false,
      originCountry: json['originCountry'] ?? '',
      affiliation: json['affiliation'] ?? '',
      kanaName: json['kanaName'] ?? '',
      employmentEndDate: json['employmentEndDate'] != null
          ? DateTime.parse(json['employmentEndDate'])
          : null,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'nativeLanguage': nativeLanguage,
      'fluentLanguages': fluentLanguages,
      'otherLanguages': otherLanguages,
      'degree': degree,
      'modalityPreference': modalityPreference,
      'availabilityRate': availabilityRate,
      'eventsParticipation': eventsParticipation,
      'providedAssistance': providedAssistance,
      'profilePicturePath': profilePicturePath,
      'personalDescription': personalDescription,
      'commPreference': commPreference,
      'isSetupComplete': isSetupComplete,
      'isSenior': isSenior,
      'originCountry': originCountry,
      'affiliation': affiliation,
      'kanaName': kanaName,
      'employmentEndDate': employmentEndDate?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory StaffMember.createMock(int index) {
    var modality = ['In-Person', 'Online', 'Both'];
    var degrees = ['Bachelors', 'Masters', 'PhD'];
    return StaffMember(
      id: const Uuid().v4(),
      name: 'Staff $index',
      email: 'staff$index@example.com',
      nativeLanguage: index % 2 == 0 ? 'English' : 'Japanese',
      fluentLanguages: index % 2 == 0
          ? ['Japanese', 'French']
          : ['English', 'Spanish'],
      otherLanguages: ['German'],
      degree: degrees[index % 3],
      modalityPreference: modality[index % 3],
      availabilityRate: 0.5 + (0.01 * index),
      eventsParticipation: index * 2,
      providedAssistance: index * 3,
      profilePicturePath: 'https://i.pravatar.cc/150?u=$index',
      personalDescription:
          'Hello! I am a passionate staff member ready to assist.',
      commPreference: index % 2 == 0 ? 'Email' : 'SNS',
      isSetupComplete: true,
      isSenior: index == 1,
    );
  }
}

class AvailabilityBlock {
  final String id;
  final DateTime startTime; // 30 min block
  final String staffId;
  String modality; // In-Person, Online, Both
  String status; // proposed, approved, rejected
  bool needsReplacement;

  AvailabilityBlock({
    required this.id,
    required this.startTime,
    required this.staffId,
    required this.modality,
    this.status = 'proposed',
    this.needsReplacement = false,
  });

  factory AvailabilityBlock.fromJson(Map<String, dynamic> json) {
    return AvailabilityBlock(
      id: json['id'],
      startTime: DateTime.parse(json['startTime']),
      staffId: json['staffId'],
      modality: json['modality'],
      status: json['status'] ?? 'proposed',
      needsReplacement: json['needsReplacement'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'staffId': staffId,
      'modality': modality,
      'status': status,
      'needsReplacement': needsReplacement,
    };
  }
}

class Holiday {
  final DateTime date;
  final String message;
  bool isAllDay; // New for Phase 3
  String startTime; // "HH:mm"
  String endTime; // "HH:mm"

  Holiday({
    required this.date,
    this.message = '',
    this.isAllDay = true,
    this.startTime = '09:00',
    this.endTime = '17:00',
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      date: DateTime.parse(json['date']),
      message: json['message'] ?? '',
      isAllDay: json['isAllDay'] ?? true,
      startTime: json['startTime'] ?? '09:00',
      endTime: json['endTime'] ?? '17:00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'message': message,
      'isAllDay': isAllDay,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}

class DaySchedule {
  final int weekday; // 1 = Monday, 7 = Sunday
  String startHour;
  String endHour;
  bool isClosed;

  DaySchedule({
    required this.weekday,
    this.startHour = '09:00',
    this.endHour = '17:00',
    this.isClosed = false,
  });

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    return DaySchedule(
      weekday: json['weekday'] ?? 1,
      startHour: json['startHour'] ?? '09:00',
      endHour: json['endHour'] ?? '17:00',
      isClosed: json['isClosed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weekday': weekday,
      'startHour': startHour,
      'endHour': endHour,
      'isClosed': isClosed,
    };
  }
}

class OperatingHours {
  List<DaySchedule> weeklySchedule;
  List<Holiday> holidays;

  OperatingHours({required this.weeklySchedule, this.holidays = const []});

  factory OperatingHours.fromJson(Map<String, dynamic> json) {
    return OperatingHours(
      weeklySchedule:
          (json['weeklySchedule'] as List<dynamic>?)
              ?.map((e) => DaySchedule.fromJson(e))
              .toList() ??
          List.generate(7, (index) => DaySchedule(weekday: index + 1)),
      holidays:
          (json['holidays'] as List<dynamic>?)
              ?.map((e) => Holiday.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weeklySchedule': weeklySchedule.map((e) => e.toJson()).toList(),
      'holidays': holidays.map((e) => e.toJson()).toList(),
    };
  }
}

class LogEntry {
  final DateTime timestamp;
  final String eventType;
  final String description;

  LogEntry({
    required this.timestamp,
    required this.eventType,
    required this.description,
  });

  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      timestamp: DateTime.parse(json['timestamp']),
      eventType: json['eventType'] ?? 'Action',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'eventType': eventType,
      'description': description,
    };
  }
}

class EventProposal {
  final String id;
  final String staffId;
  String title;
  String description;
  DateTime proposedDate;

  EventProposal({
    required this.id,
    required this.staffId,
    required this.title,
    required this.description,
    required this.proposedDate,
  });

  factory EventProposal.fromJson(Map<String, dynamic> json) {
    return EventProposal(
      id: json['id'],
      staffId: json['staffId'],
      title: json['title'],
      description: json['description'],
      proposedDate: DateTime.parse(json['proposedDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'staffId': staffId,
      'title': title,
      'description': description,
      'proposedDate': proposedDate.toIso8601String(),
    };
  }
}

class WorkingReport {
  final String id;
  final String staffId;
  final DateTime reportDate;
  final DateTime scheduledStart;
  final DateTime scheduledEnd;
  DateTime confirmedStart;
  DateTime confirmedEnd;
  String workDone;
  bool isSubmitted;

  WorkingReport({
    required this.id,
    required this.staffId,
    required this.reportDate,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.confirmedStart,
    required this.confirmedEnd,
    required this.workDone,
    this.isSubmitted = false,
  });

  double get workedHours {
    final diff = confirmedEnd.difference(confirmedStart);
    return diff.inMinutes / 60.0;
  }

  factory WorkingReport.fromJson(Map<String, dynamic> json) {
    return WorkingReport(
      id: json['id'],
      staffId: json['staffId'],
      reportDate: DateTime.parse(json['reportDate']),
      scheduledStart: DateTime.parse(json['scheduledStart']),
      scheduledEnd: DateTime.parse(json['scheduledEnd']),
      confirmedStart: DateTime.parse(json['confirmedStart']),
      confirmedEnd: DateTime.parse(json['confirmedEnd']),
      workDone: json['workDone'],
      isSubmitted: json['isSubmitted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'staffId': staffId,
      'reportDate': reportDate.toIso8601String(),
      'scheduledStart': scheduledStart.toIso8601String(),
      'scheduledEnd': scheduledEnd.toIso8601String(),
      'confirmedStart': confirmedStart.toIso8601String(),
      'confirmedEnd': confirmedEnd.toIso8601String(),
      'workDone': workDone,
      'isSubmitted': isSubmitted,
    };
  }
}
