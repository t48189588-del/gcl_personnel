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
      case 4: return const SocialDashboardTab();
      case 5: return const _LogView();
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
                    DataColumn(label: Text(loc.role)),
                  ],
                  rows: filteredStaff.map((s) {
                    final needsReplaceBlocks = blocks.where((b) => b.staffId == s.id && b.needsReplacement).length;
                    return DataRow(cells: [
                      DataCell(Row(children: [
                        CircleAvatar(child: Text(s.name[0])), 
                        const SizedBox(width: 8), 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            if (s.kanaName.isNotEmpty) Text(s.kanaName, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          ],
                        )
                      ])),
                      DataCell(Text(s.nativeLanguage)),
                      DataCell(Text(s.degree)),
                      DataCell(Text('${(s.availabilityRate * 100).toStringAsFixed(1)}%')),
                      DataCell(Text(s.eventsParticipation.toString())),
                      DataCell(Text(s.providedAssistance.toString())),
                      DataCell(needsReplaceBlocks > 0 
                        ? Text('$needsReplaceBlocks ${loc.alerts}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)) 
                        : Text(loc.none)),
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
            Wrap(spacing: 8, children: config.holidays.map((h) => Chip(label: Text('${DateFormat('yyyy-MM-dd').format(h.date)}: ${h.message}'), onDeleted: () => provider.removeHoliday(h.date))).toList()),
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
      builder: (dContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(loc.addHoliday),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 250, height: 250, child: CalendarDatePicker(initialDate: selectedDate, firstDate: DateTime(2020), lastDate: DateTime(2030), onDateChanged: (val) => selectedDate = val)),
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
            ElevatedButton(onPressed: () { provider.addHoliday(selectedDate, msgController.text, isAllDay: isAllDay, start: start, end: end); Navigator.pop(dContext); }, child: Text(loc.saveHoliday)),
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
                label: Text(DateFormat('MMMM yyyy').format(_viewMonth)),
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
            const Expanded(child: Center(child: Text("Please select a staff member to view reports.")))
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
        title: Text('${loc.workingReports} - ${DateFormat('yyyy-MM-dd').format(report.reportDate)}'),
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

class _ApprovalTab extends StatefulWidget {
  const _ApprovalTab();

  @override
  State<_ApprovalTab> createState() => _ApprovalTabState();
}

class _ApprovalTabState extends State<_ApprovalTab> {
  StaffMember? _selectedStaff;
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month + 1, 1);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = context.watch<AppProvider>();
    final staffList = provider.staff.where((s) => !s.isSenior && s.isSetupComplete).toList();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.nextMonthSchedule, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          Row(
            children: [
              SizedBox(
                width: 300,
                child: DropdownButtonFormField<StaffMember>(
                  decoration: InputDecoration(labelText: loc.juniorStaff, border: const OutlineInputBorder()),
                  initialValue: _selectedStaff,
                  items: staffList.map((s) => DropdownMenuItem(value: s, child: Text('${s.name} (${s.kanaName})'))).toList(),
                  onChanged: (val) => setState(() => _selectedStaff = val),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_month),
                label: Text(DateFormat('yyyy-MM').format(_selectedMonth)),
                onPressed: () async {
                  final m = await _selectMonthDialog(context, loc);
                  if (m != null) setState(() => _selectedMonth = m);
                },
              ),
              const Spacer(),
              if (_selectedStaff != null)
                ElevatedButton.icon(
                  icon: const Icon(Icons.done_all),
                  label: Text(loc.approveAll),
                  onPressed: () => provider.approveAllProposedBlocks(_selectedStaff!.id, _selectedMonth),
                ),
            ],
          ),
          const SizedBox(height: 24),
          if (_selectedStaff == null)
            const Expanded(child: Center(child: Text('Select a staff member to view proposed shifts')))
          else
            Expanded(child: _buildApprovalGrid(context, provider, loc)),
        ],
      ),
    );
  }

  Widget _buildApprovalGrid(BuildContext context, AppProvider provider, AppLocalizations loc) {
    final blocks = provider.blocks.where((b) => 
      b.staffId == _selectedStaff!.id && 
      b.startTime.year == _selectedMonth.year && 
      b.startTime.month == _selectedMonth.month
    ).toList();

    if (blocks.isEmpty) return const Center(child: Text('No proposed shifts for this month'));

    blocks.sort((a, b) => a.startTime.compareTo(b.startTime));

    return ListView.builder(
      itemCount: blocks.length,
      itemBuilder: (context, index) {
        final b = blocks[index];
        final isApproved = b.status == 'approved';
        final isRejected = b.status == 'rejected';

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(
              isApproved ? Icons.check_circle : (isRejected ? Icons.cancel : Icons.help_outline),
              color: isApproved ? Colors.green : (isRejected ? Colors.red : Colors.orange),
            ),
            title: Text('${DateFormat('EEEE, MMM d').format(b.startTime)} | ${DateFormat('HH:mm').format(b.startTime)}'),
            subtitle: Text('${loc.modality}: ${_localizeModality(b.modality, loc)} | ${loc.status}: ${_localizeStatus(b.status, loc)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isApproved)
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    tooltip: loc.approve,
                    onPressed: () => provider.approveBlock(b.id),
                  ),
                if (!isRejected)
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    tooltip: loc.reject,
                    onPressed: () => provider.rejectBlock(b.id),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _localizeModality(String val, AppLocalizations loc) {
    if (val == 'Online') return loc.online;
    if (val == 'In Person') return loc.inPerson;
    if (val == 'Both') return loc.both;
    return val;
  }

  String _localizeStatus(String val, AppLocalizations loc) {
    if (val == 'proposed') return loc.proposed;
    if (val == 'approved') return loc.approved;
    if (val == 'rejected') return loc.rejected;
    return val;
  }
}

class _LogView extends StatelessWidget {
  const _LogView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("System Logs (Implementation in Phase 5)"));
  }
}
