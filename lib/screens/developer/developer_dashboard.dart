import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/logger_service.dart';
import '../../models/models.dart';
import '../common/app_actions.dart';
import '../../l10n/app_localizations.dart';

class DeveloperDashboard extends StatefulWidget {
  const DeveloperDashboard({super.key});

  @override
  State<DeveloperDashboard> createState() => _DeveloperDashboardState();
}

class _DeveloperDashboardState extends State<DeveloperDashboard> {
  List<LogEntry> logs = [];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  void _loadLogs() {
    setState(() {
      logs = LoggerService.getLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.developerDashboardTitle),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              LoggerService.clearLogs();
              _loadLogs();
            },
            tooltip: loc.clearLogsTooltip,
          ),
          ...buildGlobalAppActions(context),
        ],
      ),
      body: ListView.builder(
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          return ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(_translateLog(log.description, loc)),
            subtitle: Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(log.timestamp)),
            trailing: Chip(label: Text(_localizeLogType(log.eventType, loc))),
          );
        },
      ),
    );
  }

  String _localizeLogType(String type, AppLocalizations loc) {
    if (type == 'Action') return loc.logEntryTypeAction;
    if (type == 'Interaction') return loc.logEntryTypeInteraction;
    return type;
  }

  String _translateLog(String description, AppLocalizations loc) {
    if (!description.contains('|')) {
      if (description == 'logClearedLogs') return loc.logClearedLogs;
      return description;
    }
    final parts = description.split('|');
    final key = parts[0];
    final params = <String, String>{};
    for (int i = 1; i < parts.length; i++) {
      final p = parts[i].split('=');
      if (p.length == 2) params[p[0]] = p[1];
    }

    switch (key) {
      case 'logLocaleSwitched': return loc.logLocaleSwitched(params['locale'] ?? '');
      case 'logThemeSwitched': return loc.logThemeSwitched(params['mode'] ?? '');
      case 'logJuniorLogin': return loc.logJuniorLogin(params['name'] ?? '');
      case 'logInvitedStaff': return loc.logInvitedStaff(params['email'] ?? '');
      case 'logUpgradedSenior': return loc.logUpgradedSenior(params['name'] ?? '');
      case 'logFinishedEmployment': return loc.logFinishedEmployment(params['name'] ?? '', params['date'] ?? '');
      case 'logUpdatedDaySchedule': return loc.logUpdatedDaySchedule(params['day'] ?? '', params['range'] ?? '', params['closed'] == 'true');
      case 'logAddedHolidays': return loc.logAddedHolidays(int.tryParse(params['count'] ?? '0') ?? 0);
      case 'logRemovedHoliday': return loc.logRemovedHoliday(params['date'] ?? '');
      case 'logEventProposal': return loc.logEventProposal(params['title'] ?? '', params['name'] ?? '');
      case 'logCompletedSetup': return loc.logCompletedSetup(params['name'] ?? '');
      case 'logUpdatedProfile': return loc.logUpdatedProfile(params['name'] ?? '');
      case 'logAddedBlock': return loc.logAddedBlock(params['staffId'] ?? '', params['time'] ?? '');
      case 'logRemovedBlock': return loc.logRemovedBlock(params['id'] ?? '');
      case 'logEmergencyReschedule': return loc.logEmergencyReschedule(params['id'] ?? '');
      case 'logUpdatedBlockModality': return loc.logUpdatedBlockModality(params['id'] ?? '', params['modality'] ?? '');
      case 'logApprovedBlock': return loc.logApprovedBlock(params['id'] ?? '');
      case 'logApprovedMultipleBlocks': return loc.logApprovedMultipleBlocks(int.tryParse(params['count'] ?? '0') ?? 0);
      case 'logRejectedMultipleBlocks': return loc.logRejectedMultipleBlocks(int.tryParse(params['count'] ?? '0') ?? 0);
      case 'logUpdatedProposalStatus': return loc.logUpdatedProposalStatus(params['id'] ?? '', params['status'] ?? '');
      case 'logApprovedAllBlocks': return loc.logApprovedAllBlocks(params['staffId'] ?? '', params['month'] ?? '');
      case 'logSubmittedReport': return loc.logSubmittedReport(params['date'] ?? '');
      default: return description;
    }
  }
}
