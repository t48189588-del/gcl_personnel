import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_provider.dart';
import '../../models/models.dart';
import '../../services/excel_service.dart';
import 'package:intl/intl.dart';
import '../common/app_actions.dart';
import '../common/setup_profile_screen.dart';
import '../../services/social_dashboard_tab.dart';
import '../../services/logger_service.dart';
import 'dart:convert';
import 'package:web/web.dart' as web;

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
              final DateTime? month = await _selectMonthDialog(context, loc);
              if (month != null && context.mounted) {
                final juniors = provider.staff.where((s) => !s.isSenior && s.isSetupComplete).toList();
                ExcelService.exportMasterCalendarMonthly(month, juniors, provider.blocks, loc);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: loc.exportExcel,
            onPressed: () {
              final staff = provider.staff;
              ExcelService.exportStaffData(staff, loc);
            },
          ),
          IconButton(
            icon: const Icon(Icons.folder_zip_outlined),
            tooltip: loc.exportAllReportsTooltip,
            onPressed: () {
              final juniors = provider.staff.where((s) => !s.isSenior && s.isSetupComplete).toList();
              ExcelService.exportAllStaffWorkingReports(juniors, provider.reports, loc);
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
              NavigationRailDestination(
                icon: const Icon(Icons.assignment_outlined),
                selectedIcon: const Icon(Icons.assignment),
                label: Text(loc.workingReports),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.check_circle_outline),
                selectedIcon: const Icon(Icons.check_circle),
                label: Text(loc.approve),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.lightbulb_outline),
                selectedIcon: const Icon(Icons.lightbulb),
                label: Text(loc.eventProposal),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.bar_chart_outlined),
                selectedIcon: const Icon(Icons.bar_chart),
                label: Text(loc.socialMetrics),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0: return const _MetricsView();
      case 1: return const _GuardrailsView();
      case 2: return const _WorkingReportsView();
      case 3: return const _ApprovalTab();
      case 4: return const _EventProposalsTab();
      case 5: return const SocialDashboardTab();
      case 6: return const _LogView();
      default: return const _MetricsView();
    }
  }
}

Future<DateTime?> _selectMonthDialog(BuildContext context, AppLocalizations loc) async {
  DateTime now = DateTime.now();
  return await showDatePicker(
    context: context,
    initialDate: now,
    firstDate: DateTime(2020),
    lastDate: DateTime(2030),
    initialDatePickerMode: DatePickerMode.year,
    helpText: loc.masterCalendarExport,
  );
}

Widget _detailItem(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    ),
  );
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

  String _translateModelValue(String value, AppLocalizations loc) {
    switch (value) {
      case 'English': return 'English';
      case 'Japanese': return 'Japanese';
      case 'Bachelors': return loc.bachelors;
      case 'Masters': return loc.masters;
      case 'PhD': return loc.phd;
      case 'Research': return loc.research;
      case 'Online': return loc.online;
      case 'In-Person': return loc.inPerson;
      case 'Both': return loc.both;
      case 'Senior': return loc.senior;
      case 'Junior': return loc.junior;
      default: return value;
    }
  }

  Widget _sortableHeader(String label) {
    return Row(
      children: [
        Text(label),
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
      if (_sortColumnIndex == 3) cmp = s1.availabilityRate.compareTo(s2.availabilityRate);
      if (_sortColumnIndex == 4) cmp = s1.eventsParticipation.compareTo(s2.eventsParticipation);
      if (_sortColumnIndex == 5) cmp = s1.providedAssistance.compareTo(s2.providedAssistance);
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
                  onChanged: (val) => setState(() => _searchQuery = val),
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
                              title: Text(loc.mockEmailTitle),
                              content: Text(loc.mockEmailContent(emailController.text)),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => SetupProfileScreen(applicant: mockApplicant)));
                                  },
                                  child: Text(loc.openInviteLink),
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
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _isAscending,
                  columns: [
                    DataColumn(label: _sortableHeader(loc.name), onSort: (index, asc) => setState(() { _sortColumnIndex = index; _isAscending = asc; })),
                    DataColumn(label: _sortableHeader(loc.nativeLang), onSort: (index, asc) => setState(() { _sortColumnIndex = index; _isAscending = asc; })),
                    DataColumn(label: _sortableHeader(loc.currentlyStudying), onSort: (index, asc) => setState(() { _sortColumnIndex = index; _isAscending = asc; })),
                    DataColumn(label: _sortableHeader(loc.availRate), onSort: (index, asc) => setState(() { _sortColumnIndex = index; _isAscending = asc; })),
                    DataColumn(label: _sortableHeader(loc.eventsPart), onSort: (index, asc) => setState(() { _sortColumnIndex = index; _isAscending = asc; })),
                    DataColumn(label: _sortableHeader(loc.assistance), onSort: (index, asc) => setState(() { _sortColumnIndex = index; _isAscending = asc; })),
                    DataColumn(label: Text(loc.alerts)),
                    DataColumn(label: Text(loc.employment)),
                    DataColumn(label: Text(loc.role)),
                  ],
                  rows: filteredStaff.map((s) {
                    final needsReplaceBlocks = blocks.where((b) => b.staffId == s.id && b.needsReplacement).length;
                    return DataRow(cells: [
                      DataCell(Row(children: [
                        CircleAvatar(child: Text(s.name[0])), 
                        const SizedBox(width: 8), 
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                              if (s.kanaName.isNotEmpty) Text(s.kanaName, style: const TextStyle(fontSize: 10, color: Colors.grey), overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        )
                      ])),
                      DataCell(Text(_translateModelValue(s.nativeLanguage, loc))),
                      DataCell(Text(_translateModelValue(s.degree, loc))),
                      DataCell(Text('${(s.availabilityRate * 100).toStringAsFixed(1)}%')),
                      DataCell(Text(s.eventsParticipation.toString())),
                      DataCell(Text(s.providedAssistance.toString())),
                      DataCell(needsReplaceBlocks > 0 
                        ? Text('$needsReplaceBlocks ${loc.alerts}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)) 
                        : Text(loc.none)),
                      DataCell(s.isSenior 
                        ? const Text("-") 
                        : IconButton(
                            icon: const Icon(Icons.exit_to_app, color: Colors.red),
                            tooltip: loc.finishEmployment,
                            onPressed: () => _showFinishEmploymentDialog(context, provider, s, loc),
                          )),
                      DataCell(s.isSenior ? Text(loc.senior) : ElevatedButton(onPressed: () => provider.upgradeToSenior(s.id), child: Text(loc.upgradeToSenior))),
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
    final List<String> weekdays = [loc.mon, loc.tue, loc.wed, loc.thu, loc.fri, loc.sat, loc.sun];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loc.operatingHours, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            DataTable(
              columns: [
                DataColumn(label: Text(loc.day)),
                DataColumn(label: Text(loc.startTime)),
                DataColumn(label: Text(loc.endTime)),
                DataColumn(label: Text(loc.closed)),
              ],
              rows: config.weeklySchedule.map((ds) {
                return DataRow(cells: [
                  DataCell(Text(weekdays[ds.weekday - 1])),
                  DataCell(DropdownButton<String>(
                    value: ds.startHour,
                    items: List.generate(24, (index) => '${index.toString().padLeft(2, '0')}:00').map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: ds.isClosed ? null : (val) { if (val != null) provider.updateDaySchedule(ds.weekday, val, ds.endHour, ds.isClosed); },
                  )),
                  DataCell(DropdownButton<String>(
                    value: ds.endHour,
                    items: List.generate(24, (index) => '${index.toString().padLeft(2, '0')}:00').map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: ds.isClosed ? null : (val) { if (val != null) provider.updateDaySchedule(ds.weekday, ds.startHour, val, ds.isClosed); },
                  )),
                  DataCell(Switch(value: ds.isClosed, onChanged: (val) => provider.updateDaySchedule(ds.weekday, ds.startHour, ds.endHour, val)))
                ]);
              }).toList(),
            ),
            const SizedBox(height: 48),
            Text(loc.holidays, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            ElevatedButton.icon(icon: const Icon(Icons.calendar_month), label: Text(loc.addHoliday), onPressed: () => _showAddHolidayDialog(context, provider, loc)),
            const SizedBox(height: 16),
            Wrap(spacing: 8, children: config.holidays.map((h) => Chip(label: Text('${DateFormat.yMd(Localizations.localeOf(context).toString()).format(h.date)}: ${h.message}'), onDeleted: () => provider.removeHoliday(h.date))).toList()),
          ],
        ),
      ),
    );
  }

  void _showAddHolidayDialog(BuildContext context, AppProvider provider, AppLocalizations loc) {
    Set<DateTime> selectedDates = {DateTime.now()};
    bool isAllDay = true;
    String start = '09:00';
    String end = '17:00';
    final msgController = TextEditingController();

    showDialog(
      context: context,
      builder: (dContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(loc.addHoliday),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(loc.selectDaysPrompt, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: CalendarDatePicker(
                    initialDate: selectedDates.first,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    onDateChanged: (val) {
                      setState(() {
                        final dateOnly = DateTime(val.year, val.month, val.day);
                        if (selectedDates.contains(dateOnly)) {
                          if (selectedDates.length > 1) selectedDates.remove(dateOnly);
                        } else {
                          selectedDates.add(dateOnly);
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  children: selectedDates.map((d) => Chip(
                    label: Text(DateFormat('MM/dd').format(d), style: const TextStyle(fontSize: 10)),
                    onDeleted: selectedDates.length > 1 ? () => setState(() => selectedDates.remove(d)) : null,
                  )).toList(),
                ),
                const SizedBox(height: 16),
                TextField(controller: msgController, decoration: InputDecoration(labelText: loc.holidayMessagePrompt, border: const OutlineInputBorder())),
                const SizedBox(height: 16),
                Row(children: [Text(loc.allDay), const Spacer(), Switch(value: isAllDay, onChanged: (val) => setState(() => isAllDay = val))]),
                if (!isAllDay) ...[
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(child: DropdownButton<String>(value: start, isExpanded: true, items: List.generate(24, (i) => '${i.toString().padLeft(2, '0')}:00').map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(), onChanged: (v) => setState(() => start = v!))),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('-')),
                    Expanded(child: DropdownButton<String>(value: end, isExpanded: true, items: List.generate(24, (i) => '${i.toString().padLeft(2, '0')}:00').map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(), onChanged: (v) => setState(() => end = v!))),
                  ]),
                ]
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dContext), child: Text(loc.cancel)),
            ElevatedButton(onPressed: () { provider.addHolidays(selectedDates.toList(), msgController.text, isAllDay: isAllDay, start: start, end: end); Navigator.pop(dContext); }, child: Text(loc.saveHoliday)),
          ],
        ),
      ),
    );
  }
}

class _WorkingReportsView extends StatefulWidget {
  const _WorkingReportsView();

  @override
  State<_WorkingReportsView> createState() => _WorkingReportsViewState();
}

class _WorkingReportsViewState extends State<_WorkingReportsView> {
  StaffMember? _selectedStaff;
  DateTime _viewMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = context.watch<AppProvider>();
    final juniors = provider.staff.where((s) => !s.isSenior && s.isSetupComplete).toList();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(loc.workingReports, style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              if (_selectedStaff != null)
                ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: Text(loc.exportExcel),
                  onPressed: () {
                    final staffReports = provider.reports.where((r) => r.staffId == _selectedStaff!.id).toList();
                    ExcelService.exportWorkingReports(_selectedStaff!, staffReports, loc);
                  },
                ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<StaffMember>(
                  decoration: InputDecoration(labelText: loc.juniorStaff, border: const OutlineInputBorder()),
                  initialValue: _selectedStaff,
                  items: juniors.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
                  onChanged: (val) => setState(() => _selectedStaff = val),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_month),
                label: Text(DateFormat.yMMMM(Localizations.localeOf(context).toString()).format(_viewMonth)),
                onPressed: () async {
                  // Simplified month picker via year picker
                  final d = await showDatePicker(
                    context: context,
                    initialDate: _viewMonth,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    initialDatePickerMode: DatePickerMode.year,
                  );
                  if (d != null && mounted) setState(() => _viewMonth = d);
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          if (_selectedStaff == null)
            Expanded(child: Center(child: Text(loc.selectStaffPrompt)))
          else
            Expanded(child: _buildReportCalendar(context, provider)),
        ],
      ),
    );
  }

  Widget _buildReportCalendar(BuildContext context, AppProvider provider) {
    final loc = AppLocalizations.of(context)!;
    final daysInMonth = DateTime(_viewMonth.year, _viewMonth.month + 1, 0).day;
    
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: daysInMonth,
      itemBuilder: (context, index) {
        final day = index + 1;
        final date = DateTime(_viewMonth.year, _viewMonth.month, day);
        
        // Find if they had a shift
        final hadShift = provider.blocks.any((b) => 
          b.staffId == _selectedStaff!.id && 
          b.startTime.year == date.year &&
          b.startTime.month == date.month &&
          b.startTime.day == date.day
        );

        // Find if report exists
        final report = provider.reports.where((r) => 
          r.staffId == _selectedStaff!.id && 
          r.reportDate.year == date.year &&
          r.reportDate.month == date.month &&
          r.reportDate.day == date.day &&
          r.isSubmitted
        ).firstOrNull;

        Color bgColor = Colors.grey.shade100;
        String statusText = '';
        if (hadShift) {
          if (report != null) {
            bgColor = Colors.green.shade100;
            statusText = loc.filledReport;
          } else {
            // Check if it's in the past
            if (date.isBefore(DateTime.now())) {
              bgColor = Colors.red.shade100;
              statusText = loc.missingReport;
            } else {
              bgColor = Colors.blue.shade50;
              statusText = loc.schedule;
            }
          }
        }

        return InkWell(
          onTap: report != null ? () => _showReportDetail(context, report) : null,
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(day.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                if (statusText.isNotEmpty)
                  Text(statusText, style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showReportDetail(BuildContext context, WorkingReport report) {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${loc.workingReports} - ${DateFormat.yMd(Localizations.localeOf(context).toString()).format(report.reportDate)}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailItem(loc.scheduledTime, '${DateFormat('HH:mm').format(report.scheduledStart)} - ${DateFormat('HH:mm').format(report.scheduledEnd)}'),
            _detailItem(loc.confirmedStartTime, DateFormat('HH:mm').format(report.confirmedStart)),
            _detailItem(loc.confirmedEndTime, DateFormat('HH:mm').format(report.confirmedEnd)),
            _detailItem(loc.workedHours, report.workedHours.toStringAsFixed(2)),
            const Divider(),
            Text(loc.workDoneLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(report.workDone),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(loc.cancel)),
        ],
      ),
    );
  }
}

class Shift {
  final StaffMember staff;
  final List<AvailabilityBlock> blocks;
  final DateTime start;
  final DateTime end;
  Shift({required this.staff, required this.blocks, required this.start, required this.end});
}

enum CalendarViewType { day, week, month }

class _ApprovalTab extends StatefulWidget {
  const _ApprovalTab();

  @override
  State<_ApprovalTab> createState() => _ApprovalTabState();
}

class _ApprovalTabState extends State<_ApprovalTab> {
  DateTime _currentDate = DateTime.now();
  CalendarViewType _viewType = CalendarViewType.day;
  final List<String> _selectedBlockIds = [];

  void _navigate(int delta) {
    setState(() {
      if (_viewType == CalendarViewType.day) {
        _currentDate = _currentDate.add(Duration(days: delta));
      } else if (_viewType == CalendarViewType.week) {
        _currentDate = _currentDate.add(Duration(days: delta * 7));
      } else {
        _currentDate = DateTime(_currentDate.year, _currentDate.month + delta, 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = context.watch<AppProvider>();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(loc.nextMonthSchedule, style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              SegmentedButton<CalendarViewType>(
                segments: [
                  ButtonSegment(value: CalendarViewType.day, label: Text(loc.day)),
                  ButtonSegment(value: CalendarViewType.week, label: Text(loc.week)),
                  ButtonSegment(value: CalendarViewType.month, label: Text(loc.month)),
                ],
                selected: {_viewType},
                onSelectionChanged: (val) => setState(() => _viewType = val.first),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => _navigate(-1)),
              const SizedBox(width: 16),
              Column(
                children: [
                  Text(
                    _getFormattedDateRange(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: _currentDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (d != null) setState(() => _currentDate = d);
                    },
                    child: Text(loc.selectDate, style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor)),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              IconButton(icon: const Icon(Icons.chevron_right), onPressed: () => _navigate(1)),
            ],
          ),
          const SizedBox(height: 24),
          if (_selectedBlockIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                    label: Text(loc.approve),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      provider.approveBlocks(_selectedBlockIds);
                      setState(() => _selectedBlockIds.clear());
                    },
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.cancel, color: Colors.white),
                    label: Text(loc.reject),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      provider.rejectBlocks(_selectedBlockIds);
                      setState(() => _selectedBlockIds.clear());
                    },
                  ),
                ],
              ),
            ),
          Expanded(child: _buildApprovalTimeline(context, provider, loc)),
        ],
      ),
    );
  }

  String _getFormattedDateRange() {
    final locale = Localizations.localeOf(context).toString();
    if (_viewType == CalendarViewType.day) {
      return DateFormat.yMMMMEEEEd(locale).format(_currentDate);
    } else if (_viewType == CalendarViewType.week) {
      final start = _currentDate.subtract(Duration(days: _currentDate.weekday - 1));
      final end = start.add(const Duration(days: 6));
      return '${DateFormat.yMMMd(locale).format(start)} - ${DateFormat.yMMMd(locale).format(end)}';
    } else {
      return DateFormat.yMMMM(locale).format(_currentDate);
    }
  }

  Widget _buildApprovalTimeline(BuildContext context, AppProvider provider, AppLocalizations loc) {
    final blocks = provider.blocks.where((b) {
      if (b.status != 'proposed') return false;
      final bDate = DateTime(b.startTime.year, b.startTime.month, b.startTime.day);
      if (_viewType == CalendarViewType.day) {
        final dDate = DateTime(_currentDate.year, _currentDate.month, _currentDate.day);
        return bDate.isAtSameMomentAs(dDate);
      } else if (_viewType == CalendarViewType.week) {
        final start = _currentDate.subtract(Duration(days: _currentDate.weekday - 1));
        final end = start.add(const Duration(days: 7));
        return b.startTime.isAfter(start.subtract(const Duration(seconds: 1))) && b.startTime.isBefore(end);
      } else {
        return b.startTime.year == _currentDate.year && b.startTime.month == _currentDate.month;
      }
    }).toList();

    if (blocks.isEmpty) return Center(child: Text(loc.noPendingShifts));

    Map<String, List<Shift>> staffShifts = {};
    final activeJuniors = provider.staff.where((s) => !s.isSenior && s.isSetupComplete).toList();
    
    for (var s in activeJuniors) {
      final staffBlocks = blocks.where((b) => b.staffId == s.id).toList();
      if (staffBlocks.isEmpty) continue;
      
      staffBlocks.sort((a, b) => a.startTime.compareTo(b.startTime));
      
      List<Shift> shifts = [];
      List<AvailabilityBlock> currentBlocks = [staffBlocks.first];
      for (int i = 1; i < staffBlocks.length; i++) {
        final prev = staffBlocks[i-1];
        final curr = staffBlocks[i];
        if (curr.startTime.difference(prev.startTime).inMinutes == 30 && curr.startTime.day == prev.startTime.day) {
          currentBlocks.add(curr);
        } else {
          shifts.add(Shift(staff: s, blocks: currentBlocks, start: currentBlocks.first.startTime, end: currentBlocks.last.startTime.add(const Duration(minutes: 30))));
          currentBlocks = [curr];
        }
      }
      shifts.add(Shift(staff: s, blocks: currentBlocks, start: currentBlocks.first.startTime, end: currentBlocks.last.startTime.add(const Duration(minutes: 30))));
      staffShifts[s.id] = shifts;
    }

    if (staffShifts.isEmpty) return const Center(child: Text('No pending shifts for this period'));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: staffShifts.entries.map((entry) {
          final staff = activeJuniors.firstWhere((s) => s.id == entry.key);
          final shifts = entry.value;
          final color = Colors.primaries[staff.name.length % Colors.primaries.length];
          
          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      CircleAvatar(backgroundColor: color, radius: 6),
                      const SizedBox(width: 8),
                      Expanded(child: Text(staff.name, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ...shifts.map((s) => _buildShiftCard(context, provider, s, color, loc)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildShiftCard(BuildContext context, AppProvider provider, Shift s, Color color, AppLocalizations loc) {
    final ids = s.blocks.map((b) => b.id).toList();
    final isSelected = ids.every((id) => _selectedBlockIds.contains(id));
    final isLong = s.blocks.length >= 3;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(side: BorderSide(color: color.withAlpha(76), width: 1), borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (isLong)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(icon: const Icon(Icons.check, color: Colors.green, size: 20), onPressed: () => provider.approveBlocks(ids)),
                  IconButton(icon: const Icon(Icons.close, color: Colors.red, size: 20), onPressed: () => provider.rejectBlocks(ids)),
                ],
              ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Checkbox(
                value: isSelected,
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      for (var id in ids) {
                        if (!_selectedBlockIds.contains(id)) _selectedBlockIds.add(id);
                      }
                    } else {
                      for (var id in ids) {
                        _selectedBlockIds.remove(id);
                      }
                    }
                  });
                },
              ),
              title: Text(DateFormat('EEEE, MMM d').format(s.start), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              subtitle: Text(
                '${DateFormat('HH:mm').format(s.start)} - ${DateFormat('HH:mm').format(s.end)}\n${_localizeModality(s.blocks.first.modality, loc)}',
                style: const TextStyle(fontSize: 13, height: 1.5),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(icon: const Icon(Icons.check, color: Colors.green, size: 20), onPressed: () => provider.approveBlocks(ids)),
                IconButton(icon: const Icon(Icons.close, color: Colors.red, size: 20), onPressed: () => provider.rejectBlocks(ids)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _localizeModality(String val, AppLocalizations loc) {
    if (val == 'Online') return loc.online;
    if (val == 'In Person') return loc.inPerson;
    if (val == 'Both') return loc.both;
    return val;
  }

}

void _showFinishEmploymentDialog(BuildContext context, AppProvider provider, StaffMember staff, AppLocalizations loc) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("${loc.finishEmployment}: ${staff.name}"),
      content: const Text("Are you sure you want to finalize this staff member's employment? This will disable their scheduling access."),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(loc.cancel)),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
          onPressed: () { provider.finishEmployment(staff.id); Navigator.pop(context); },
          child: const Text("Finish Immediately"),
        ),
      ],
    ),
  );
}

class _EventProposalsTab extends StatelessWidget {
  const _EventProposalsTab();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = context.watch<AppProvider>();
    final proposals = provider.eventProposals;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.eventProposal, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          if (proposals.isEmpty)
            Expanded(child: Center(child: Text(loc.noEventProposals)))
          else
            Expanded(
              child: ListView.builder(
                itemCount: proposals.length,
                itemBuilder: (context, index) {
                  final p = proposals[index];
                  final isPending = p.status == 'proposed';
                  return Card(
                    child: ListTile(
                      title: Text(p.title),
                      subtitle: Text("${loc.byAuthorOnDate(p.proposerName, DateFormat.yMd(Localizations.localeOf(context).toString()).format(p.proposedDate))}\n${p.description}"),
                      trailing: isPending
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.check, color: Colors.green),
                                  onPressed: () => provider.updateEventProposalStatus(p.id, 'approved'),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () => provider.updateEventProposalStatus(p.id, 'rejected'),
                                ),
                              ],
                            )
                          : Text(
                                _localizeStatus(p.status, loc).toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: p.status == 'approved' ? Colors.green : Colors.red,
                                ),
                              ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  String _localizeStatus(String status, AppLocalizations loc) {
    if (status == 'approved') return loc.approved;
    if (status == 'rejected') return loc.rejected;
    if (status == 'proposed') return loc.proposed;
    return status;
  }
}

class _LogView extends StatelessWidget {
  const _LogView();

  void _exportCSV(List<LogEntry> logs) {
    String csv = "Timestamp,Type,Description\n";
    for (var log in logs) {
      csv += "${log.timestamp},${log.eventType},\"${log.description.replaceAll('"', '""')}\"\n";
    }
    
    final bytes = utf8.encode(csv);
    final base64String = base64Encode(bytes);
    final anchor = web.HTMLAnchorElement()
      ..href = 'data:text/csv;base64,$base64String'
      ..download = "GCL_System_Logs.csv"
      ..style.display = 'none';
      
    web.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    context.watch<AppProvider>(); // Rebuild on changes
    final logs = LoggerService.getLogs();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(loc.logs, style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: Text(loc.exportCsv),
                onPressed: () => _exportCSV(logs),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.delete_outline),
                label: Text(loc.clearLogs),
                onPressed: () {
                  LoggerService.clearLogs();
                  Provider.of<AppProvider>(context, listen: false).addLog('Action', 'logClearedLogs');
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final l = logs[index];
                return ListTile(
                  leading: Icon(l.eventType == 'Action' ? Icons.settings : Icons.info_outline),
                  title: Text(_translateLog(l.description, loc)),
                  subtitle: Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(l.timestamp)),
                );
              },
            ),
          ),
        ],
      ),
    );
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
