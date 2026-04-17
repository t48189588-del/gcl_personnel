import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_provider.dart';
import '../../models/models.dart';
import '../../services/excel_service.dart';
import 'package:intl/intl.dart';
import '../common/app_actions.dart';
import '../common/setup_profile_screen.dart';

class SeniorDashboard extends StatefulWidget {
  const SeniorDashboard({super.key});

  @override
  State<SeniorDashboard> createState() => _SeniorDashboardState();
}

class _SeniorDashboardState extends State<SeniorDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = context.read<AppProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.commanderView),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: loc.masterCalendarExport,
            onPressed: () async {
              final DateTime? month = await _selectMonth(context);
              if (month != null) {
                final juniors = provider.staff.where((s) => !s.isSenior && s.isSetupComplete).toList();
                ExcelService.exportMasterCalendarMonthly(month, juniors, provider.blocks);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: loc.exportExcel,
            onPressed: () {
              final staff = provider.staff;
              ExcelService.exportStaffData(staff);
            },
          ),
          ...buildGlobalAppActions(context),
          const SizedBox(width: 20),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: [
              NavigationRailDestination(
                icon: const Icon(Icons.dashboard_outlined),
                selectedIcon: const Icon(Icons.dashboard),
                label: Text(loc.metrics),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings),
                label: Text(loc.guardrails),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _selectedIndex == 0 ? const _MetricsView() : const _GuardrailsView(),
          ),
        ],
      ),
    );
  }

  Future<DateTime?> _selectMonth(BuildContext context) async {
    DateTime now = DateTime.now();
    return await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.year,
      helpText: 'Select Month for Master Export',
    );
  }
}

class _MetricsView extends StatefulWidget {
  const _MetricsView();

  @override
  State<_MetricsView> createState() => _MetricsViewState();
}

class _MetricsViewState extends State<_MetricsView> {
  String _searchQuery = '';
  int _sortColumnIndex = 0;
  bool _isAscending = true;

  Widget _sortableHeader(String title) {
    return Row(
      children: [
        Text(title),
        const SizedBox(width: 4),
        const Icon(Icons.swap_vert, size: 16, color: Colors.grey),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = context.watch<AppProvider>();
    final List<StaffMember> staffList = List.from(provider.staff);
    final blocks = provider.blocks;

    var filteredStaff = staffList.where((s) {
      return s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             s.nativeLanguage.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    filteredStaff.sort((s1, s2) {
      int cmp = 0;
      if (_sortColumnIndex == 0) cmp = s1.name.compareTo(s2.name);
      if (_sortColumnIndex == 1) cmp = s1.nativeLanguage.compareTo(s2.nativeLanguage);
      if (_sortColumnIndex == 2) cmp = s1.degree.compareTo(s2.degree);
      if (_sortColumnIndex == 3) cmp = s1.modalityPreference.compareTo(s2.modalityPreference);
      if (_sortColumnIndex == 4) cmp = s1.availabilityRate.compareTo(s2.availabilityRate);
      if (_sortColumnIndex == 5) cmp = s1.eventsParticipation.compareTo(s2.eventsParticipation);
      if (_sortColumnIndex == 6) cmp = s1.providedAssistance.compareTo(s2.providedAssistance);
      
      return _isAscending ? cmp : -cmp;
    });

    final emailController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: loc.searchHint,
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: loc.emailLabel,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.send),
                      label: Text(loc.inviteStaffButton),
                      onPressed: () {
                        if (emailController.text.isNotEmpty) {
                          provider.inviteStaff(emailController.text);
                          final mockApplicant = provider.staff.last;
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Mock Email Received!'),
                              content: Text('Verification sent to ${emailController.text}\n\nClick link to test setup profile.'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => SetupProfileScreen(applicant: mockApplicant)),
                                    );
                                  },
                                  child: const Text('Open Invite Link'),
                                )
                              ],
                            ),
                          );
                          emailController.clear();
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _isAscending,
                  columns: [
                    DataColumn(label: _sortableHeader(loc.name), onSort: (index, asc) => setState(() { _sortColumnIndex = index; _isAscending = asc; })),
                    DataColumn(label: _sortableHeader(loc.nativeLang), onSort: (index, asc) => setState(() { _sortColumnIndex = index; _isAscending = asc; })),
                    DataColumn(label: _sortableHeader(loc.degree), onSort: (index, asc) => setState(() { _sortColumnIndex = index; _isAscending = asc; })),
                    DataColumn(label: _sortableHeader(loc.availRate), onSort: (index, asc) => setState(() { _sortColumnIndex = index; _isAscending = asc; })),
                    DataColumn(label: _sortableHeader(loc.eventsPart), onSort: (index, asc) => setState(() { _sortColumnIndex = index; _isAscending = asc; })),
                    DataColumn(label: _sortableHeader(loc.assistance), onSort: (index, asc) => setState(() { _sortColumnIndex = index; _isAscending = asc; })),
                    DataColumn(label: Text(loc.alerts)),
                    const DataColumn(label: Text('Role')),
                  ],
                  rows: filteredStaff.map((s) {
                    final needsReplaceBlocks = blocks.where((b) => b.staffId == s.id && b.needsReplacement).length;
                    return DataRow(cells: [
                      DataCell(
                        Row(
                          children: [
                            CircleAvatar(
                              child: Text(s.name[0]),
                            ),
                            const SizedBox(width: 8),
                            Text(s.name),
                          ],
                        ),
                      ),
                      DataCell(Text(s.nativeLanguage)),
                      DataCell(Text(s.degree)),
                      DataCell(Text('${(s.availabilityRate * 100).toStringAsFixed(1)}%')),
                      DataCell(Text(s.eventsParticipation.toString())),
                      DataCell(Text(s.providedAssistance.toString())),
                      DataCell(
                        needsReplaceBlocks > 0
                            ? Text('$needsReplaceBlocks Alerts', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                            : const Text('None'),
                      ),
                      DataCell(
                        s.isSenior 
                        ? const Text('Senior')
                        : ElevatedButton(
                            onPressed: () => provider.upgradeToSenior(s.id),
                            child: Text(loc.upgradeToSenior),
                          ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _GuardrailsView extends StatelessWidget {
  const _GuardrailsView();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = context.watch<AppProvider>();
    final config = provider.operatingHours;
    final List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loc.operatingHours, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            DataTable(
              columns: const [
                DataColumn(label: Text('Day')),
                DataColumn(label: Text('Start Time')),
                DataColumn(label: Text('End Time')),
                DataColumn(label: Text('Closed?')),
              ],
              rows: config.weeklySchedule.map((ds) {
                return DataRow(cells: [
                  DataCell(Text(weekdays[ds.weekday - 1])),
                  DataCell(
                    DropdownButton<String>(
                      value: ds.startHour,
                      items: List.generate(24, (index) {
                        final hour = index.toString().padLeft(2, '0');
                        return DropdownMenuItem(value: '$hour:00', child: Text('$hour:00'));
                      }),
                      onChanged: ds.isClosed ? null : (val) {
                        if (val != null) provider.updateDaySchedule(ds.weekday, val, ds.endHour, ds.isClosed);
                      },
                    ),
                  ),
                  DataCell(
                    DropdownButton<String>(
                      value: ds.endHour,
                      items: List.generate(24, (index) {
                        final hour = index.toString().padLeft(2, '0');
                        return DropdownMenuItem(value: '$hour:00', child: Text('$hour:00'));
                      }),
                      onChanged: ds.isClosed ? null : (val) {
                        if (val != null) provider.updateDaySchedule(ds.weekday, ds.startHour, val, ds.isClosed);
                      },
                    ),
                  ),
                  DataCell(
                    Switch(
                      value: ds.isClosed,
                      onChanged: (val) {
                        provider.updateDaySchedule(ds.weekday, ds.startHour, ds.endHour, val);
                      },
                    )
                  )
                ]);
              }).toList(),
            ),
            const SizedBox(height: 48),
            Text(loc.holidays, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_month),
              label: Text(loc.addHoliday),
              onPressed: () {
                _showAddHolidayDialog(context, provider, loc);
              },
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: config.holidays
                  .map((h) => Chip(
                        label: Text('${DateFormat('yyyy-MM-dd').format(h.date)}: ${h.message}'),
                        onDeleted: () => provider.removeHoliday(h.date),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddHolidayDialog(BuildContext context, AppProvider provider, AppLocalizations loc) {
    DateTime selectedDate = DateTime.now();
    bool isAllDay = true;
    String start = '09:00';
    String end = '17:00';
    final msgController = TextEditingController();

    showDialog(
      context: context,
      builder: (dContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(loc.addHoliday),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: CalendarDatePicker(
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        onDateChanged: (val) => selectedDate = val,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: msgController,
                      decoration: InputDecoration(
                        labelText: loc.holidayMessagePrompt,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(loc.allDay),
                        const Spacer(),
                        Switch(
                          value: isAllDay,
                          onChanged: (val) => setState(() => isAllDay = val),
                        ),
                      ],
                    ),
                    if (!isAllDay) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButton<String>(
                              value: start,
                              isExpanded: true,
                              items: List.generate(24, (i) => '${i.toString().padLeft(2, '0')}:00')
                                  .map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                              onChanged: (v) => setState(() => start = v!),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('-')),
                          Expanded(
                            child: DropdownButton<String>(
                              value: end,
                              isExpanded: true,
                              items: List.generate(24, (i) => '${i.toString().padLeft(2, '0')}:00')
                                  .map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                              onChanged: (v) => setState(() => end = v!),
                            ),
                          ),
                        ],
                      ),
                    ]
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    provider.addHoliday(
                      selectedDate, 
                      msgController.text,
                      isAllDay: isAllDay,
                      start: start,
                      end: end,
                    );
                    Navigator.pop(dContext);
                  },
                  child: Text(loc.saveHoliday),
                )
              ],
            );
          }
        );
      }
    );
  }
}
