import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_provider.dart';
import '../../models/models.dart';
import '../../services/ics_service.dart';
import 'package:intl/intl.dart';
import '../common/app_actions.dart';

class JuniorDashboard extends StatefulWidget {
  const JuniorDashboard({super.key});

  @override
  State<JuniorDashboard> createState() => _JuniorDashboardState();
}

class _JuniorDashboardState extends State<JuniorDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.selfServicePortal),
        actions: buildGlobalAppActions(context),
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
                icon: const Icon(Icons.calendar_today_outlined),
                selectedIcon: const Icon(Icons.calendar_today),
                label: Text(loc.schedule),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.event_note_outlined),
                selectedIcon: const Icon(Icons.event_note),
                label: Text(loc.eventProposal),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: Text(loc.profile),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.feed_outlined),
                selectedIcon: const Icon(Icons.feed),
                label: Text(loc.noticeBoard),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0: return const _SchedulePainterView();
      case 1: return const _EventProposalView();
      case 2: return const _ProfileView();
      case 3: return const _NoticeBoardView();
      default: return const _SchedulePainterView();
    }
  }
}

enum CalendarViewType { day, week, month }

class _SchedulePainterView extends StatefulWidget {
  const _SchedulePainterView();

  @override
  State<_SchedulePainterView> createState() => _SchedulePainterViewState();
}

class _SchedulePainterViewState extends State<_SchedulePainterView> {
  DateTime _selectedDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 1);
  CalendarViewType _viewType = CalendarViewType.day;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = context.watch<AppProvider>();
    final config = provider.operatingHours;
    final staff = provider.currentJuniorStaff;

    if (staff == null) return Center(child: Text(loc.noStaffLoggedIn));

    final dateOnly = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    var holidayCheck = config.holidays.where((h) => h.date == dateOnly);
    final isHoliday = holidayCheck.isNotEmpty;
    final holidayMessage = isHoliday ? holidayCheck.first.message : '';

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAttendanceBanner(loc),
          const _PendingReportsBanner(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(loc.nextMonthSchedule, style: Theme.of(context).textTheme.headlineSmall),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _showFinishEmploymentDialog(context, provider, staff, loc),
                    icon: const Icon(Icons.exit_to_app, color: Colors.red),
                    label: Text(loc.finishEmployment, style: const TextStyle(color: Colors.red)),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.download),
                    tooltip: loc.exportICS,
                    onPressed: () {
                      final myBlocks = provider.blocks.where((b) => b.staffId == staff.id).toList();
                      ICSService.exportToICS(staff, myBlocks);
                    },
                  ),
                  const SizedBox(width: 8),
                  SegmentedButton<CalendarViewType>(
                    segments: [
                      ButtonSegment(value: CalendarViewType.month, label: Text(loc.month[0].toUpperCase())),
                      ButtonSegment(value: CalendarViewType.week, label: Text(loc.week[0].toUpperCase())),
                      ButtonSegment(value: CalendarViewType.day, label: Text(loc.day[0].toUpperCase())),
                    ],
                    selected: {_viewType},
                    onSelectionChanged: (val) => setState(() => _viewType = val.first),
                  ),
                  if (_viewType != CalendarViewType.month) ...[
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 16),
                      onPressed: () => setState(() {
                        _selectedDate = _selectedDate.subtract(Duration(days: _viewType == CalendarViewType.week ? 7 : 1));
                      }),
                    ),
                  ],
                  ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_month),
                    label: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null && mounted) setState(() => _selectedDate = date);
                    },
                  ),
                  if (_viewType != CalendarViewType.month) ...[
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: () => setState(() {
                        _selectedDate = _selectedDate.add(Duration(days: _viewType == CalendarViewType.week ? 7 : 1));
                      }),
                    ),
                  ],
                ],
              )
            ],
          ),
          const SizedBox(height: 24),
          if (isHoliday && _viewType == CalendarViewType.day)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  '${loc.holidayNotice}\n$holidayMessage',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.red),
                ),
              ),
            )
          else
            Expanded(
              child: _buildDynamicCalendar(context, provider, config, staff),
            ),
        ],
      ),
    );
  }

  Widget _buildAttendanceBanner(AppLocalizations loc) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(loc.attendanceWarning, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
          ),
          TextButton(
            onPressed: () {},
            child: Text(loc.attendanceReminder),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicCalendar(BuildContext context, AppProvider provider, OperatingHours config, StaffMember staff) {
    final loc = AppLocalizations.of(context)!;
    if (_viewType == CalendarViewType.month) {
      return CalendarDatePicker(
        initialDate: _selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        onDateChanged: (val) {
          setState(() {
            _selectedDate = val;
            _viewType = CalendarViewType.day;
          });
        },
      );
    } else if (_viewType == CalendarViewType.week) {
      int offset = _selectedDate.weekday - 1;
      DateTime startOfWeek = _selectedDate.subtract(Duration(days: offset));
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, dex) {
          final targetDay = startOfWeek.add(Duration(days: dex));
          final targetHoliday = config.holidays.any((h) => h.date == DateTime(targetDay.year, targetDay.month, targetDay.day));
          return Container(
            width: 200,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                Container(
                  color: targetHoliday ? Colors.red.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.05),
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  child: Text(DateFormat('E, MMM d').format(targetDay), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: targetHoliday ? Colors.red : null)),
                ),
                Expanded(
                  child: targetHoliday 
                    ? Center(child: Text(loc.holidayNotice, style: const TextStyle(color: Colors.red, fontSize: 12)))
                    : _buildTimeGrid(context, provider, config, staff, targetDay, true),
                )
              ],
            ),
          );
        },
      );
    } else {
      return _buildTimeGrid(context, provider, config, staff, _selectedDate, false);
    }
  }

  Widget _buildTimeGrid(BuildContext context, AppProvider provider, OperatingHours config, StaffMember staff, DateTime queryDate, bool isCompact) {
    final loc = AppLocalizations.of(context)!;
    int dayIndex = queryDate.weekday;
    DaySchedule daySched = config.weeklySchedule.firstWhere((ds) => ds.weekday == dayIndex);
    if (daySched.isClosed) return Center(child: Text(loc.closed, style: const TextStyle(color: Colors.grey)));

    // Employment check
    final isAfterEnd = staff.employmentEndDate != null && queryDate.isAfter(staff.employmentEndDate!);
    final isDisabled = !staff.isActive || isAfterEnd;

    int startH = int.tryParse(daySched.startHour.split(':').first) ?? 9;
    int endH = int.tryParse(daySched.endHour.split(':').first) ?? 17;
    List<DateTime> timeSlots = [];
    for (int h = startH; h < endH; h++) {
      timeSlots.add(DateTime(queryDate.year, queryDate.month, queryDate.day, h, 0));
      timeSlots.add(DateTime(queryDate.year, queryDate.month, queryDate.day, h, 30));
    }

    return IgnorePointer(
      ignoring: isDisabled,
      child: Opacity(
        opacity: isDisabled ? 0.3 : 1.0,
        child: GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isCompact ? 1 : 4,
            childAspectRatio: isCompact ? 3.5 : 2.5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: timeSlots.length,
          itemBuilder: (context, index) => _TimeBlock(slot: timeSlots[index], provider: provider, staff: staff),
        ),
      ),
    );
  }
}

class _TimeBlock extends StatelessWidget {
  final DateTime slot;
  final AppProvider provider;
  final StaffMember staff;
  const _TimeBlock({required this.slot, required this.provider, required this.staff});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final existingBlocks = provider.blocks.where((b) => b.staffId == staff.id && b.startTime == slot);
    final hasBlock = existingBlocks.isNotEmpty;
    final block = hasBlock ? existingBlocks.first : null;
    final isAlert = hasBlock && block!.needsReplacement;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bgColor = isDark ? Colors.grey.shade900 : Colors.grey.shade100;
    Color borderColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    String statusLabel = '';

    if (hasBlock) {
      if (block!.status == 'approved') {
        bgColor = Colors.green.withValues(alpha: isDark ? 0.2 : 0.1);
        borderColor = Colors.green;
        statusLabel = loc.approved;
      } else if (block.status == 'rejected') {
        bgColor = Colors.red.withValues(alpha: isDark ? 0.2 : 0.1);
        borderColor = Colors.red;
        statusLabel = loc.rejected;
      } else {
        bgColor = Theme.of(context).primaryColor.withValues(alpha: isDark ? 0.2 : 0.1);
        borderColor = Theme.of(context).primaryColor;
        statusLabel = loc.proposed;
      }
      if (isAlert) {
        bgColor = Colors.orange.withValues(alpha: 0.2);
        borderColor = Colors.orange;
      }
    }

    return InkWell(
      onTap: () {
        if (hasBlock) {
          _showBlockDialog(context, provider, existingBlocks.first, staff, loc);
        } else {
          provider.addBlock(AvailabilityBlock(id: const Uuid().v4(), startTime: slot, staffId: staff.id, modality: staff.modalityPreference));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${DateFormat('HH:mm').format(slot)} - ${DateFormat('HH:mm').format(slot.add(const Duration(minutes: 30)))}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: isDark ? Colors.white : Colors.black87)),
            if (hasBlock) ...[
              Text(statusLabel, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
              Tooltip(
                message: block!.modality,
                child: Text(isAlert ? '!' : _localizeModality(block.modality, loc), style: TextStyle(fontSize: 10, color: isAlert ? Colors.red : (isDark ? Colors.white70 : Colors.blueGrey.shade700))),
              ),
            ],
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

  void _showBlockDialog(BuildContext context, AppProvider provider, AvailabilityBlock block, StaffMember staff, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(DateFormat('HH:mm').format(block.startTime)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loc.selectModality, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...['Online', 'In Person', 'Both'].map((m) => RadioListTile<String>(
              title: Text(_localizeModality(m, loc)),
              value: m,
              // ignore: deprecated_member_use
              groupValue: block.modality,
              // ignore: deprecated_member_use
              onChanged: (val) { if (val != null) { provider.updateBlockModality(block.id, val); Navigator.pop(context); } },
              contentPadding: EdgeInsets.zero,
            )),
          ],
        ),
        actions: [
          TextButton(onPressed: () { provider.removeBlock(block.id); Navigator.pop(context); }, child: Text(loc.removeBlock)),
          TextButton(onPressed: () { provider.emergencyReschedule(block.id); Navigator.pop(context); }, style: TextButton.styleFrom(foregroundColor: Colors.red), child: Text(loc.emergencyReschedule)),
        ],
      ),
    );
  }
}

class _EventProposalView extends StatefulWidget {
  const _EventProposalView();

  @override
  State<_EventProposalView> createState() => _EventProposalViewState();
}

class _EventProposalViewState extends State<_EventProposalView> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = context.watch<AppProvider>();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.eventProposal, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          TextField(controller: _titleController, decoration: InputDecoration(labelText: loc.proposalTitle, border: const OutlineInputBorder())),
          const SizedBox(height: 16),
          TextField(controller: _descController, maxLines: 3, decoration: InputDecoration(labelText: loc.proposalDescription, border: const OutlineInputBorder())),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('${loc.proposedDate}: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  final d = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime.now(), lastDate: DateTime(2030));
                  if (d != null && mounted) setState(() => _selectedDate = d);
                },
                child: Text(loc.selectDate),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            onPressed: () {
              provider.proposeEvent(_titleController.text, _descController.text, _selectedDate);
              _titleController.clear(); _descController.clear();
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loc.proposalSubmitted)));
            },
            child: Text(loc.proposeEvent),
          ),
        ],
      ),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();
  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  late TextEditingController _nameController;
  late TextEditingController _originController;
  late TextEditingController _kanaController;
  late TextEditingController _studyController;
  late TextEditingController _descController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    final staff = context.read<AppProvider>().currentJuniorStaff!;
    _nameController = TextEditingController(text: staff.name)..addListener(_checkForChanges);
    _originController = TextEditingController(text: staff.originCountry)..addListener(_checkForChanges);
    _kanaController = TextEditingController(text: staff.kanaName)..addListener(_checkForChanges);
    _studyController = TextEditingController(text: staff.degree)..addListener(_checkForChanges);
    _descController = TextEditingController(text: staff.personalDescription)..addListener(_checkForChanges);
    _emailController = TextEditingController(text: staff.email)..addListener(_checkForChanges);
    _phoneController = TextEditingController(text: staff.phoneNumber)..addListener(_checkForChanges);
  }

  void _checkForChanges() {
    final staff = context.read<AppProvider>().currentJuniorStaff!;
    final changed = _nameController.text != staff.name ||
                    _originController.text != staff.originCountry ||
                    _kanaController.text != staff.kanaName ||
                    _studyController.text != staff.degree ||
                    _descController.text != staff.personalDescription ||
                    _emailController.text != staff.email ||
                    _phoneController.text != staff.phoneNumber;
    if (changed != _hasChanges) setState(() => _hasChanges = changed);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = context.watch<AppProvider>();
    final staff = provider.currentJuniorStaff;
    if (staff == null) return Center(child: Text(loc.loading));

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(loc.personalProfile, style: Theme.of(context).textTheme.headlineSmall),
            ElevatedButton.icon(
              onPressed: () => _showFinishEmploymentDialog(context, provider, staff, loc),
              icon: const Icon(Icons.exit_to_app, color: Colors.red),
              label: Text(loc.finishEmployment, style: const TextStyle(color: Colors.red)),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Center(child: CircleAvatar(radius: 50, child: Text(staff.name[0], style: const TextStyle(fontSize: 40)))),
        const SizedBox(height: 24),
        TextField(controller: _nameController, decoration: InputDecoration(labelText: loc.name, prefixIcon: const Icon(Icons.person))),
        const SizedBox(height: 16),
        TextField(controller: _kanaController, decoration: InputDecoration(labelText: loc.kanaName, prefixIcon: const Icon(Icons.abc))),
        const SizedBox(height: 16),
        TextField(controller: _originController, decoration: InputDecoration(labelText: loc.originCountry, prefixIcon: const Icon(Icons.location_on))),
        const SizedBox(height: 16),
        TextField(controller: _studyController, decoration: InputDecoration(labelText: loc.currentlyStudying, prefixIcon: const Icon(Icons.school))),
        const SizedBox(height: 16),
        TextField(controller: _emailController, decoration: InputDecoration(labelText: loc.emailLabel, prefixIcon: const Icon(Icons.email))),
        const SizedBox(height: 16),
        TextField(controller: _phoneController, decoration: InputDecoration(labelText: loc.phoneNumber, prefixIcon: const Icon(Icons.phone))),
        const SizedBox(height: 16),
        TextField(controller: _descController, maxLines: 3, decoration: InputDecoration(labelText: loc.personalDescription, prefixIcon: const Icon(Icons.description))),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _hasChanges ? () {
            staff.name = _nameController.text;
            staff.originCountry = _originController.text;
            staff.kanaName = _kanaController.text;
            staff.degree = _studyController.text;
            staff.email = _emailController.text;
            staff.phoneNumber = _phoneController.text;
            staff.personalDescription = _descController.text;
            provider.updateJuniorProfile(staff);
            setState(() => _hasChanges = false);
          } : null,
          child: Text(loc.saveProfile),
        ),
      ],
    );
  }
}

class _NoticeBoardView extends StatelessWidget {
  const _NoticeBoardView();
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.noticeBoard, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          Expanded(child: Center(child: Text(loc.noAnnouncements))),
        ],
      ),
    );
  }
}

void _showFinishEmploymentDialog(BuildContext context, AppProvider provider, StaffMember staff, AppLocalizations loc) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(loc.employmentEndDialogTitle),
      content: Text(loc.employmentEndDialogContent),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(loc.cancel)),
        OutlinedButton(
          onPressed: () { provider.finishEmployment(staff.id); Navigator.pop(context); },
          child: Text(loc.finishImmediately),
        ),
        ElevatedButton(
          onPressed: () async {
            final d = await showDatePicker(context: context, initialDate: DateTime.now().add(const Duration(days: 1)), firstDate: DateTime.now(), lastDate: DateTime(2030));
            if (d != null && context.mounted) { provider.finishEmployment(staff.id, endDate: d); Navigator.pop(context); }
          },
          child: Text(loc.finishFutureDate),
        ),
      ],
    ),
  );
}

class _PendingReportsBanner extends StatelessWidget {
  const _PendingReportsBanner();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = context.watch<AppProvider>();
    final pending = provider.getPendingReports();

    if (pending.isEmpty) return const SizedBox.shrink();

    final isTable = pending.length > 3;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isTable ? Colors.red.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isTable ? Colors.red.shade200 : Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isTable ? Icons.error_outline : Icons.info_outline, color: isTable ? Colors.red : Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isTable ? loc.actionRequiredReports : loc.pendingReportsNotice,
                  style: TextStyle(fontWeight: FontWeight.bold, color: isTable ? Colors.red.shade900 : Colors.blue.shade900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isTable)
            Table(
              border: TableBorder.all(color: Colors.red.shade100),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.red.shade100),
                  children: [
                    Padding(padding: const EdgeInsets.all(8), child: Text(loc.date, style: const TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: const EdgeInsets.all(8), child: Text(loc.scheduledTime, style: const TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: const EdgeInsets.all(8), child: Text(loc.status, style: const TextStyle(fontWeight: FontWeight.bold))),
                  ]
                ),
                ...pending.map((r) => TableRow(
                  children: [
                    Padding(padding: EdgeInsets.all(8), child: Text(DateFormat('MMM d, yyyy').format(r.reportDate))),
                    Padding(padding: EdgeInsets.all(8), child: Text('${DateFormat('HH:mm').format(r.scheduledStart)} - ${DateFormat('HH:mm').format(r.scheduledEnd)}')),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: TextButton(
                        onPressed: () => _showWorkingReportDialog(context, provider, r, loc),
                        child: Text(loc.fillReport),
                      ),
                    ),
                  ]
                )),
              ],
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: pending.map((report) => ActionChip(
                avatar: const Icon(Icons.edit_document, size: 16),
                label: Text('${DateFormat('MMM d').format(report.reportDate)} (${DateFormat('HH:mm').format(report.scheduledStart)}-${DateFormat('HH:mm').format(report.scheduledEnd)})'),
                onPressed: () => _showWorkingReportDialog(context, provider, report, loc),
              )).toList(),
            ),
        ],
      ),
    );
  }

  void _showWorkingReportDialog(BuildContext context, AppProvider provider, WorkingReport report, AppLocalizations loc) {
    final titleController = TextEditingController(text: report.workDone);
    DateTime confirmedStart = report.confirmedStart;
    DateTime confirmedEnd = report.confirmedEnd;

    showDialog(
      context: context,
      builder: (dContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.assignment),
              const SizedBox(width: 8),
              Text(loc.workingReports),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.help_outline),
                tooltip: loc.helpWorkDone,
                onPressed: () {},
              )
            ],
          ),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${loc.reportDate}: ${DateFormat('yyyy-MM-dd').format(report.reportDate)}'),
                  const SizedBox(height: 8),
                  Text('${loc.scheduledTime}: ${DateFormat('HH:mm').format(report.scheduledStart)} - ${DateFormat('HH:mm').format(report.scheduledEnd)}'),
                  const Divider(height: 32),
                  
                  Row(
                    children: [
                      Text(loc.confirmedStartTime, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Tooltip(message: loc.helpConfirmedTime, child: const Icon(Icons.info_outline, size: 16, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(confirmedStart));
                            if (time != null) {
                              setState(() => confirmedStart = DateTime(report.reportDate.year, report.reportDate.month, report.reportDate.day, time.hour, time.minute));
                            }
                          },
                          child: Text(DateFormat('HH:mm').format(confirmedStart)),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('-')),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(confirmedEnd));
                            if (time != null) {
                              setState(() => confirmedEnd = DateTime(report.reportDate.year, report.reportDate.month, report.reportDate.day, time.hour, time.minute));
                            }
                          },
                          child: Text(DateFormat('HH:mm').format(confirmedEnd)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  Text(loc.workDoneLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: titleController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: loc.workDoneHint,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('${loc.workedHours}: ${ (confirmedEnd.difference(confirmedStart).inMinutes / 60.0).toStringAsFixed(2) }', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dContext), child: Text(loc.cancel)),
            ElevatedButton(
              onPressed: () {
                report.confirmedStart = confirmedStart;
                report.confirmedEnd = confirmedEnd;
                report.workDone = titleController.text;
                provider.submitWorkingReport(report);
                Navigator.pop(dContext);
              },
              child: Text(loc.submitReport),
            ),
          ],
        ),
      ),
    );
  }
}
