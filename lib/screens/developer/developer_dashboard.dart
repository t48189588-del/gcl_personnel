import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/logger_service.dart';
import '../../models/models.dart';
import '../common/app_actions.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Dashboard - System Logs'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              LoggerService.clearLogs();
              _loadLogs();
            },
            tooltip: 'Clear Logs',
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
            trailing: Chip(label: Text(log.eventType)),
          );
        },
      ),
    );
  }
}
