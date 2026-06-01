import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_provider.dart';
import '../../models/models.dart';
import '../../services/excel_service.dart';
import 'package:intl/intl.dart';
import '../common/app_actions.dart';
import '../common/setup_profile_screen.dart';
import '../common/responsive_scaffold.dart';
import 'chart_visualization_tab.dart';
import '../../services/social_dashboard_tab.dart';
import '../../services/logger_service.dart';
import 'dart:convert';
import '../../services/platform_helper.dart';
import '../../services/data_import_service.dart';

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
    return ResponsiveScaffold(
      appBar: AppBar(
        title: Text(loc.commanderView),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: loc.masterCalendarExport,
            onPressed: PlatformHelper.isWeb ? () async {
              final DateTime? month = await _selectMonthDialog(context, loc);
              if (month != null && context.mounted) {
                final juniors = provider.staff.where((s) => !s.isSenior && s.isSetupComplete).toList();
                ExcelService.exportMasterCalendarMonthly(month, juniors, provider.blocks, loc);
              }
            } : null,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: loc.exportExcel,
            onPressed: PlatformHelper.isWeb ? () {
              final staff = provider.staff;
              ExcelService.exportStaffData(staff, loc);
            } : null,
          ),
          IconButton(
            icon: const Icon(Icons.folder_zip_outlined),
            tooltip: loc.exportAllReportsTooltip,
            onPressed: PlatformHelper.isWeb ? () {
              final juniors = provider.staff.where((s) => !s.isSenior && s.isSetupComplete).toList();
              ExcelService.exportAllStaffWorkingReports(juniors, provider.reports, loc);
            } : null,
          ),
          ...buildGlobalAppActions(context),
          const SizedBox(width: 20),
        ],
      ),
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      railDestinations: [
        NavigationRailDestination(icon: const Icon(Icons.check_circle_outline), selectedIcon: const Icon(Icons.check_circle), label: Text(loc.approve)),
        NavigationRailDestination(icon: const Icon(Icons.lightbulb_outline), selectedIcon: const Icon(Icons.lightbulb), label: Text(loc.eventProposal)),
        NavigationRailDestination(icon: const Icon(Icons.assignment_outlined), selectedIcon: const Icon(Icons.assignment), label: Text(loc.workingReports)),
        NavigationRailDestination(icon: const Icon(Icons.meeting_room_outlined), selectedIcon: const Icon(Icons.meeting_room), label: Text(loc.meetingRequests)),
        NavigationRailDestination(icon: const Icon(Icons.dashboard_outlined), selectedIcon: const Icon(Icons.dashboard), label: Text(loc.metrics)),
        const NavigationRailDestination(icon: Icon(Icons.info_outline), selectedIcon: Icon(Icons.info), label: Text('GCL Info')),
      ],
      bottomDestinations: [
        NavigationDestination(icon: const Icon(Icons.check_circle_outline), selectedIcon: const Icon(Icons.check_circle), label: loc.approve),
        NavigationDestination(icon: const Icon(Icons.lightbulb_outline), selectedIcon: const Icon(Icons.lightbulb), label: loc.eventProposal),
        NavigationDestination(icon: const Icon(Icons.assignment_outlined), selectedIcon: const Icon(Icons.assignment), label: loc.workingReports),
        NavigationDestination(icon: const Icon(Icons.meeting_room_outlined), selectedIcon: const Icon(Icons.meeting_room), label: loc.meetingRequests),
        NavigationDestination(icon: const Icon(Icons.dashboard_outlined), selectedIcon: const Icon(Icons.dashboard), label: loc.metrics),
        const NavigationDestination(icon: Icon(Icons.info_outline), selectedIcon: Icon(Icons.info), label: 'GCL Info'),
      ],
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0: return const _ApprovalTab();
      case 1: return const _EventProposalsTab();
      case 2: return const _WorkingReportsView();
      case 3: return const _ExternalMeetingRequestsView();
      case 4: return const _MetricsView();
      case 5: return const _GuardrailsView();
      default: return const _ApprovalTab();
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
          const SocialDashboardTab(),
          const SizedBox(height: 24),
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
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.file_upload),
                      label: Text(loc.importStaffJson),
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final content = await DataImportService.pickJsonFile();
                        if (content != null) {
                          try {
                            await provider.importStaffFromJson(content);
                            messenger.showSnackBar(
                              SnackBar(content: Text(loc.importSuccess)),
                            );
                          } catch (e) {
                            messenger.showSnackBar(
                              SnackBar(content: Text(loc.importError(e.toString()))),
                            );
                          }
                        }
                      },
                    ),
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
                    DataColumn(label: Text(loc.otherLanguages)),
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
                      DataCell(Text(s.languageSkills.map((e) => '${e.language} (${e.proficiency})').join(', '))),
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

class _GuardrailsView extends StatefulWidget {
  const _GuardrailsView();

  @override
  State<_GuardrailsView> createState() => _GuardrailsViewState();
}

class _GuardrailsViewState extends State<_GuardrailsView> {
  late TextEditingController _limitController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<AppProvider>();
    final currentLimit = provider.operatingHours.maxWeeklyHours;
    _limitController = TextEditingController(text: currentLimit?.toString() ?? '');
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

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
            Wrap(spacing: 8, children: config.holidays.map((h) => Chip(label: Text('${DateFormat.yMd(Localizations.localeOf(context).toString()).format(h.date)}: ${h.message}' + (h.isAllDay ? '' : ' (${h.startTime}-${h.endTime})')), onDeleted: () => provider.removeHoliday(h.date))).toList()),
            const SizedBox(height: 48),
            Text(loc.weeklyHoursLimit, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.hourglass_bottom, color: Colors.blue, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.weeklyHoursLimit,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            loc.weeklyLimitDescription,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        controller: _limitController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: loc.weeklyHoursLimitHint,
                          border: const OutlineInputBorder(),
                          suffixText: loc.hoursSuffix,
                          isDense: true,
                        ),
                        onChanged: (val) {
                          final parsed = int.tryParse(val);
                          if (val.isEmpty) {
                            provider.updateMaxWeeklyHours(null);
                          } else if (parsed != null) {
                            provider.updateMaxWeeklyHours(parsed);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),
            Text('GCL Information', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: TextFormField(decoration: const InputDecoration(labelText: 'Address', prefixIcon: Icon(Icons.location_on), border: OutlineInputBorder()), initialValue: 'Kyushu Institute of Technology, Iizuka')),
                        const SizedBox(width: 16),
                        Expanded(child: TextFormField(decoration: const InputDecoration(labelText: 'Phone', prefixIcon: Icon(Icons.phone), border: OutlineInputBorder()), initialValue: '+81-123-456-789')),
                        const SizedBox(width: 16),
                        Expanded(child: TextFormField(decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email), border: OutlineInputBorder()), initialValue: 'contact@gclkyutech.jp')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: TextFormField(decoration: const InputDecoration(labelText: 'YouTube Link', prefixIcon: Icon(Icons.play_circle_filled, color: Colors.red), border: OutlineInputBorder()), initialValue: 'https://youtube.com/c/gclkyutech')),
                        const SizedBox(width: 16),
                        Expanded(child: TextFormField(decoration: const InputDecoration(labelText: 'Instagram Link', prefixIcon: Icon(Icons.camera_alt, color: Colors.purple), border: OutlineInputBorder()), initialValue: 'https://instagram.com/gclkyutech')),
                        const SizedBox(width: 16),
                        Expanded(child: TextFormField(decoration: const InputDecoration(labelText: 'X (Twitter) Link', prefixIcon: Icon(Icons.alternate_email, color: Colors.black), border: OutlineInputBorder()), initialValue: 'https://x.com/gclkyutech')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('GCL Information Updated Successfully')));
                        },
                        child: const Text('Save Information'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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

    final pendingReports = <WorkingReport>[];
    for (var j in juniors) {
      final unsubmitted = provider.reports.where((r) => r.staffId == j.id && !r.isSubmitted && r.scheduledEnd.isBefore(DateTime.now())).toList();
      pendingReports.addAll(unsubmitted);
    }
    
    final bool showPendingTab = pendingReports.length > 3;

    if (showPendingTab) {
      return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: "Calendar View"),
                Tab(text: "Pending Reports"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildCalendarTab(context, provider, juniors, loc),
                  _buildPendingTab(context, provider, pendingReports, loc),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return _buildCalendarTab(context, provider, juniors, loc);
    }
  }

  Widget _buildCalendarTab(BuildContext context, AppProvider provider, List<StaffMember> juniors, AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(loc.workingReports, style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text("Export All Juniors"),
                onPressed: PlatformHelper.isWeb ? () {
                  ExcelService.exportAllStaffWorkingReports(juniors, provider.reports, loc);
                } : null,
              ),
              const SizedBox(width: 8),
              if (_selectedStaff != null)
                ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: Text(loc.exportExcel),
                  onPressed: PlatformHelper.isWeb ? () {
                    final staffReports = provider.reports.where((r) => r.staffId == _selectedStaff!.id).toList();
                    ExcelService.exportWorkingReports(_selectedStaff!, staffReports, loc);
                  } : null,
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

  Widget _buildPendingTab(BuildContext context, AppProvider provider, List<WorkingReport> pendingReports, AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Missing Working Reports", style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("Date")),
                  DataColumn(label: Text("Staff Name")),
                  DataColumn(label: Text("Scheduled Time")),
                  DataColumn(label: Text("Action")),
                ],
                rows: pendingReports.map((r) {
                  final staff = provider.staff.firstWhere((s) => s.id == r.staffId, orElse: () => StaffMember(id: '', name: 'Unknown', nativeLanguage: '', degree: '', modalityPreference: '', availabilityRate: 0.0, eventsParticipation: 0, providedAssistance: 0));
                  return DataRow(cells: [
                    DataCell(Text(DateFormat.yMd(Localizations.localeOf(context).toString()).format(r.reportDate))),
                    DataCell(Text(staff.name)),
                    DataCell(Text('${DateFormat('HH:mm').format(r.scheduledStart)} - ${DateFormat('HH:mm').format(r.scheduledEnd)}')),
                    DataCell(ElevatedButton(onPressed: () {}, child: const Text("Remind"))),
                  ]);
                }).toList(),
              ),
            ),
          ),
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
        
        final hadShift = provider.blocks.any((b) => 
          b.staffId == _selectedStaff!.id && 
          b.startTime.year == date.year &&
          b.startTime.month == date.month &&
          b.startTime.day == date.day
        );

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
              const SizedBox(width: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.upload_file),
                label: Text(loc.importDataCsv),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final rows = await DataImportService.pickCsvFile();
                  if (rows != null) {
                    try {
                      await provider.importDataFromCsv(rows);
                      messenger.showSnackBar(
                        SnackBar(content: Text(loc.importSuccess)),
                      );
                    } catch (e) {
                      messenger.showSnackBar(
                        SnackBar(content: Text(loc.importError(e.toString()))),
                      );
                    }
                  }
                },
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.integration_instructions),
                label: Text(loc.importCleanedJson),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final content = await DataImportService.pickJsonFile();
                  if (content != null) {
                    try {
                      await provider.importDataFromJson(content);
                      messenger.showSnackBar(
                        SnackBar(content: Text(loc.importSuccess)),
                      );
                    } catch (e) {
                      messenger.showSnackBar(
                        SnackBar(content: Text(loc.importError(e.toString()))),
                      );
                    }
                  }
                },
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

    Map<DateTime, List<AvailabilityBlock>> blocksByDay = {};
    for (var b in blocks) {
      final d = DateTime(b.startTime.year, b.startTime.month, b.startTime.day);
      blocksByDay.putIfAbsent(d, () => []).add(b);
    }

    final sortedDays = blocksByDay.keys.toList()..sort();

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sortedDays.map((day) {
          final dayBlocks = blocksByDay[day]!..sort((a, b) => a.startTime.compareTo(b.startTime));
          
          Map<String, List<AvailabilityBlock>> blocksBySlot = {};
          for (var b in dayBlocks) {
            final slot = DateFormat('HH:mm').format(b.startTime);
            blocksBySlot.putIfAbsent(slot, () => []).add(b);
          }

          final sortedSlots = blocksBySlot.keys.toList()..sort();

          return Container(
            margin: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text(DateFormat('EEEE, MMM d, yyyy').format(day), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: sortedSlots.map((slot) {
                    final slotBlocks = blocksBySlot[slot]!;
                    return Container(
                      width: 250,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(slot, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const Divider(),
                          ...slotBlocks.map((b) {
                            final staff = provider.staff.firstWhere((s) => s.id == b.staffId, orElse: () => StaffMember(id: '', name: 'Unknown', nativeLanguage: '', degree: '', modalityPreference: '', availabilityRate: 0.0, eventsParticipation: 0, providedAssistance: 0));
                            Color bgColor;
                            if (b.status == 'approved') {
                              bgColor = Colors.green.shade100;
                            } else if (b.status == 'rejected') {
                              bgColor = Colors.red.shade100;
                            } else {
                              bgColor = Colors.grey.shade200; 
                            }
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(staff.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                        Text("${DateFormat('HH:mm').format(b.startTime)} - ${DateFormat('HH:mm').format(b.startTime.add(const Duration(minutes: 30)))}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                                        Text(_localizeModality(b.modality, loc), style: const TextStyle(fontSize: 11)),
                                        Text(b.status.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54)),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.check, color: Colors.green, size: 20),
                                    onPressed: () => provider.approveBlocks([b.id]),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  const SizedBox(width: 4),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red, size: 20),
                                    onPressed: () => provider.rejectBlocks([b.id]),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
          );
        }).toList(),
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
      title: Text(loc.finishEmploymentConfirmTitle(staff.name)),
      content: Text(loc.finishEmploymentConfirmContent),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(loc.cancel)),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
          onPressed: () { provider.finishEmployment(staff.id); Navigator.pop(context); },
          child: Text(loc.finishImmediately),
        ),
      ],
    ),
  );
}

class _EventProposalsTab extends StatefulWidget {
  const _EventProposalsTab();

  @override
  State<_EventProposalsTab> createState() => _EventProposalsTabState();
}

class _EventProposalsTabState extends State<_EventProposalsTab> {
  String? _selectedProposalId;

  // Form Fields
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _commentsController = TextEditingController();
  final _snsController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String _location = 'GCL Room';
  String _status = 'proposed';
  List<String> _photos = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _commentsController.dispose();
    _snsController.dispose();
    super.dispose();
  }

  void _selectProposal(EventProposal p) {
    setState(() {
      _selectedProposalId = p.id;
      _titleController.text = p.title;
      _descriptionController.text = p.description;
      _commentsController.text = p.comments;
      _snsController.text = p.snsSummary;
      _startDate = p.proposedDate;
      _endDate = p.endDate;
      _location = p.location;
      _status = p.status;
      _photos = List.from(p.photos);
    });
  }

  Future<void> _pickDateTime(BuildContext context, bool isStart) async {
    final initialDate = (isStart ? _startDate : _endDate) ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate == null || !context.mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );
    if (pickedTime == null) return;

    setState(() {
      final newDt = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      if (isStart) {
        _startDate = newDt;
      } else {
        _endDate = newDt;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = context.watch<AppProvider>();
    
    if (_selectedProposalId != null) {
      final index = provider.eventProposals.indexWhere((p) => p.id == _selectedProposalId);
      if (index == -1) {
        // Fallback if proposal deleted/not found
        return Center(
          child: ElevatedButton(
            onPressed: () => setState(() => _selectedProposalId = null),
            child: const Text('Back'),
          ),
        );
      }
      final proposal = provider.eventProposals[index];
      
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => setState(() => _selectedProposalId = null),
                ),
                const SizedBox(width: 8),
                Text(loc.eventDetails, style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${loc.proposerName}: ${proposal.proposerName}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Divider(height: 32),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: loc.proposalTitle,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: loc.proposalDescription,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _pickDateTime(context, true),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: loc.startTime,
                                border: const OutlineInputBorder(),
                              ),
                              child: Text(
                                _startDate != null 
                                    ? DateFormat('yyyy-MM-dd HH:mm').format(_startDate!) 
                                    : loc.selectDate,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () => _pickDateTime(context, false),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: loc.endTime,
                                border: const OutlineInputBorder(),
                              ),
                              child: Text(
                                _endDate != null 
                                    ? DateFormat('yyyy-MM-dd HH:mm').format(_endDate!) 
                                    : loc.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _location == 'GCL Room' || _location == 'Online' ? _location : 'GCL Room',
                            decoration: InputDecoration(
                              labelText: loc.eventLocation,
                              border: const OutlineInputBorder(),
                            ),
                            items: [
                              DropdownMenuItem(value: 'GCL Room', child: Text(loc.gclRoom)),
                              DropdownMenuItem(value: 'Online', child: Text(loc.online)),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _location = val);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _status,
                            decoration: InputDecoration(
                              labelText: loc.status,
                              border: const OutlineInputBorder(),
                            ),
                            items: [
                              DropdownMenuItem(value: 'proposed', child: Text(loc.proposed)),
                              DropdownMenuItem(value: 'approved', child: Text(loc.approved)),
                              DropdownMenuItem(value: 'rejected', child: Text(loc.rejected)),
                              DropdownMenuItem(value: 'finished', child: Text(loc.finished)),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _status = val);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _commentsController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: loc.eventComments,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    if (_status == 'approved') ...[
                      const Divider(height: 40),
                      Text(loc.postApprovalSNS, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _snsController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: loc.eventSummarySNS,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.photo_library),
                            label: Text(loc.uploadPhotos),
                            onPressed: () {
                              // Simulate Photo Upload
                              setState(() {
                                int count = _photos.length + 1;
                                _photos.add('https://picsum.photos/200/300?random=$count');
                              });
                            },
                          ),
                          const SizedBox(width: 16),
                          Text('${_photos.length} photos uploaded'),
                        ],
                      ),
                      if (_photos.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _photos.length,
                            itemBuilder: (ctx, i) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    _photos[i],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: Colors.grey.shade300,
                                      width: 100,
                                      child: const Icon(Icons.broken_image),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          provider.saveEventProposalDetails(
                            id: proposal.id,
                            proposedDate: _startDate ?? DateTime.now(),
                            endDate: _endDate,
                            location: _location,
                            comments: _commentsController.text,
                            status: _status,
                            snsSummary: _snsController.text,
                            photos: _photos,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(loc.detailsSaved)),
                          );
                          setState(() => _selectedProposalId = null);
                        },
                        child: Text(loc.saveDetails),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

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
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      onTap: () => _selectProposal(p),
                      title: Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        "${loc.byAuthorOnDate(p.proposerName, DateFormat.yMd(Localizations.localeOf(context).toString()).format(p.proposedDate))}\n${p.description}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildStatusChip(context, p.status, loc),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right),
                        ],
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

  Widget _buildStatusChip(BuildContext context, String status, AppLocalizations loc) {
    Color color;
    String label;
    if (status == 'approved') {
      color = Colors.green;
      label = loc.approved;
    } else if (status == 'rejected') {
      color = Colors.red;
      label = loc.rejected;
    } else if (status == 'finished') {
      color = Colors.blue;
      label = loc.finished;
    } else {
      color = Colors.orange;
      label = loc.proposed;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
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
    PlatformHelper.downloadFile(bytes, "GCL_System_Logs.csv", "text/csv");
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
                onPressed: PlatformHelper.isWeb ? () => _exportCSV(logs) : null,
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
      case 'logImportedStaff': return loc.logImportedStaff(params['count'] ?? '0');
      case 'logImportedCsvData': return loc.logImportedCsvData(params['rows'] ?? '0');
      default: return description;
    }
  }
}

class _ExternalMeetingRequestsView extends StatefulWidget {
  const _ExternalMeetingRequestsView();

  @override
  State<_ExternalMeetingRequestsView> createState() => _ExternalMeetingRequestsViewState();
}

class _ExternalMeetingRequestsViewState extends State<_ExternalMeetingRequestsView> {
  ExternalMeetingRequest? _selectedRequest;
  String? _selectedStaffId;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final pendingRequests = provider.externalMeetingRequests.where((r) => r.status == 'pending').toList();
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.meetingRequests, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          if (pendingRequests.isEmpty)
            Expanded(child: Center(child: Text(loc.noMeetingRequests)))
          else
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: SingleChildScrollView(
                      child: DataTable(
                        showCheckboxColumn: false,
                        columns: const [
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Department')),
                          DataColumn(label: Text('Purpose')),
                          DataColumn(label: Text('Date & Time')),
                          DataColumn(label: Text('Status')),
                        ],
                        rows: pendingRequests.map((req) {
                          return DataRow(
                            selected: _selectedRequest?.id == req.id,
                            onSelectChanged: (selected) {
                              if (selected == true) {
                                setState(() {
                                  _selectedRequest = req;
                                  _selectedStaffId = null;
                                });
                              }
                            },
                            cells: [
                              DataCell(Text(req.name)),
                              DataCell(Text(req.department)),
                              DataCell(Text(req.purpose)),
                              DataCell(Text(DateFormat('MMM dd, hh:mm a').format(req.requestedTime))),
                              DataCell(Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.orange),
                                ),
                                child: Text('Pending', style: TextStyle(color: Colors.orange.shade800, fontSize: 12)),
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  if (_selectedRequest != null) ...[
                    const VerticalDivider(width: 32),
                    Expanded(
                      flex: 4,
                      child: _buildDetailsSidebar(context, provider, loc),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailsSidebar(BuildContext context, AppProvider provider, AppLocalizations loc) {
    final req = _selectedRequest!;
    
    final availableStaff = provider.staff.where((s) {
      if (s.isSenior || !s.isSetupComplete) return false;
      final speaksLang = s.nativeLanguage == req.language || s.languageSkills.any((skill) => skill.language == req.language);
      if (!speaksLang) return false;
      final hasBlock = provider.blocks.any((b) => 
        b.staffId == s.id && 
        b.status == 'approved' &&
        b.startTime.year == req.requestedTime.year &&
        b.startTime.month == req.requestedTime.month &&
        b.startTime.day == req.requestedTime.day &&
        b.startTime.hour == req.requestedTime.hour &&
        b.startTime.minute == req.requestedTime.minute
      );
      return hasBlock;
    }).toList();

    if (_selectedStaffId == null && availableStaff.isNotEmpty) {
      _selectedStaffId = availableStaff.first.id;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(req.name, style: Theme.of(context).textTheme.headlineSmall)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() => _selectedRequest = null)),
              ],
            ),
            const SizedBox(height: 16),
            _detailItem(loc.affiliation, '${req.department} (${req.studyYear})'),
            _detailItem(loc.purpose, req.purpose),
            _detailItem(loc.nativeLang, req.language),
            _detailItem(loc.scheduledTime, DateFormat('yyyy-MM-dd HH:mm').format(req.requestedTime)),
            _detailItem('Type', req.meetingType == 'Online' ? loc.online : loc.inPerson),
            const Divider(height: 32),
            Text('Assign Student Assistant', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (availableStaff.isEmpty)
              Text(loc.noAvailableStaff, style: const TextStyle(color: Colors.red))
            else
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                value: _selectedStaffId,
                items: availableStaff.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedStaffId = val;
                  });
                },
              ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
                    onPressed: _selectedStaffId == null ? null : () {
                      provider.approveMeetingRequest(req.id, _selectedStaffId!);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loc.meetingApprovedSuccess)));
                      setState(() => _selectedRequest = null);
                    },
                    child: Text(loc.approve),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 16)),
                    onPressed: () {
                      provider.rejectMeetingRequest(req.id);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loc.meetingRejectedSuccess)));
                      setState(() => _selectedRequest = null);
                    },
                    child: Text(loc.reject),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

