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
            title: Text(log.description),
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
}
