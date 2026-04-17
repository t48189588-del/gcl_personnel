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
          Expanded(
            child: _buildBody(),
          ),
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

enum CalendarViewType { Day, Week, Month }

class _SchedulePainterView extends StatefulWidget {
  const _SchedulePainterView();

  @override
  State<_SchedulePainterView> createState() => _SchedulePainterViewState();
}

class _SchedulePainterViewState extends State<_SchedulePainterView> {
  DateTime _selectedDate = DateTime.now();
  CalendarViewType _viewType = CalendarViewType.Day;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = context.watch<AppProvider>();
    final config = provider.operatingHours;
    final staff = provider.currentJuniorStaff;

    if (staff == null) return const Center(child: Text('No Staff logged in.'));

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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(loc.schedule, style: Theme.of(context).textTheme.headlineSmall),
              Row(
                children: [
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
                    segments: const [
                      ButtonSegment(value: CalendarViewType.Month, label: Text('M')),
                      ButtonSegment(value: CalendarViewType.Week, label: Text('W')),
                      ButtonSegment(value: CalendarViewType.Day, label: Text('D')),
                    ],
                    selected: {_viewType},
                    onSelectionChanged: (val) => setState(() => _viewType = val.first),
                  ),
                  const SizedBox(width: 16),
                  if (_viewType != CalendarViewType.Month) ...[
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 16),
                      onPressed: () => setState(() {
                        _selectedDate = _selectedDate.subtract(Duration(days: _viewType == CalendarViewType.Week ? 7 : 1));
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
                      if (date != null) setState(() => _selectedDate = date);
                    },
                  ),
                  if (_viewType != CalendarViewType.Month) ...[
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: () => setState(() {
                        _selectedDate = _selectedDate.add(Duration(days: _viewType == CalendarViewType.Week ? 7 : 1));
                      }),
                    ),
                  ],
                ],
              )
            ],
          ),
          const SizedBox(height: 24),
          if (isHoliday && _viewType == CalendarViewType.Day)
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
            child: Text(
              loc.attendanceWarning,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
            ),
          ),
          TextButton(
            onPressed: () {}, // Action for check
            child: Text(loc.attendanceReminder),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicCalendar(BuildContext context, AppProvider provider, OperatingHours config, StaffMember staff) {
    if (_viewType == CalendarViewType.Month) {
      return CalendarDatePicker(
        initialDate: _selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        onDateChanged: (val) {
          setState(() {
            _selectedDate = val;
            _viewType = CalendarViewType.Day;
          });
        },
      );
    } 
    else if (_viewType == CalendarViewType.Week) {
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
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Container(
                  color: targetHoliday ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.05),
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  child: Text(
                    DateFormat('E, MMM d').format(targetDay),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, color: targetHoliday ? Colors.red : null),
                  ),
                ),
                Expanded(
                  child: targetHoliday 
                    ? const Center(child: Text('HOLIDAY', style: TextStyle(color: Colors.red, fontSize: 12)))
                    : _buildTimeGrid(context, provider, config, staff, targetDay, true),
                )
              ],
            ),
          );
        },
      );
    } 
    else {
      return _buildTimeGrid(context, provider, config, staff, _selectedDate, false);
    }
  }

  Widget _buildTimeGrid(BuildContext context, AppProvider provider, OperatingHours config, StaffMember staff, DateTime queryDate, bool isCompact) {
    int dayIndex = queryDate.weekday;
    DaySchedule daySched = config.weeklySchedule.firstWhere((ds) => ds.weekday == dayIndex);

    if (daySched.isClosed) {
      return const Center(child: Text('Closed', style: TextStyle(color: Colors.grey)));
    }

    int startH = int.tryParse(daySched.startHour.split(':').first) ?? 9;
    int endH = int.tryParse(daySched.endHour.split(':').first) ?? 17;

    List<DateTime> timeSlots = [];
    for (int h = startH; h < endH; h++) {
      timeSlots.add(DateTime(queryDate.year, queryDate.month, queryDate.day, h, 0));
      timeSlots.add(DateTime(queryDate.year, queryDate.month, queryDate.day, h, 30));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isCompact ? 1 : 4,
        childAspectRatio: isCompact ? 3.5 : 2.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        final slot = timeSlots[index];
        return _TimeBlock(slot: slot, provider: provider, staff: staff);
      },
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
    final isAlert = hasBlock && existingBlocks.first.needsReplacement;

    return InkWell(
      onTap: () {
        if (hasBlock) {
          _showBlockDialog(context, provider, existingBlocks.first, staff, loc);
        } else {
          provider.addBlock(AvailabilityBlock(
            id: const Uuid().v4(),
            startTime: slot,
            staffId: staff.id,
            modality: staff.modalityPreference,
          ));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isAlert ? Colors.red.shade50 : (hasBlock ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: isAlert ? Colors.red : (hasBlock ? Theme.of(context).primaryColor : Colors.grey.shade300)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateFormat('HH:mm').format(slot), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            if (hasBlock) Text(isAlert ? '!' : existingBlocks.first.modality[0], style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  void _showBlockDialog(BuildContext context, AppProvider provider, AvailabilityBlock block, StaffMember staff, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${DateFormat('HH:mm').format(block.startTime)}'),        
        actions: [
          TextButton(onPressed: () { provider.removeBlock(block.id); Navigator.pop(context); }, child: Text(loc.removeBlock)),
          TextButton(onPressed: () { provider.emergencyReschedule(block.id); Navigator.pop(context); }, child: Text(loc.emergencyReschedule), style: TextButton.styleFrom(foregroundColor: Colors.red)),
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
                  if (d != null) setState(() => _selectedDate = d);
                },
                child: const Text('Select Date'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            onPressed: () {
              provider.proposeEvent(_titleController.text, _descController.text, _selectedDate);
              _titleController.clear();
              _descController.clear();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Proposal Submitted!')));
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
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = context.watch<AppProvider>();
    final staff = provider.currentJuniorStaff;
    if (staff == null) return const Center(child: Text('Loading'));

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(loc.personalProfile, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 24),
        Center(child: CircleAvatar(radius: 50, child: Text(staff.name[0], style: const TextStyle(fontSize: 40)))),
        const SizedBox(height: 24),
        ListTile(title: Text(loc.name), subtitle: Text(staff.name), leading: const Icon(Icons.person)),
        ListTile(title: Text(loc.emailLabel), subtitle: Text(staff.email), leading: const Icon(Icons.email)),
        ListTile(title: Text(loc.nativeLang), subtitle: Text(staff.nativeLanguage), leading: const Icon(Icons.language)),
        ListTile(title: Text(loc.otherLanguages), subtitle: Text(staff.otherLanguages.join(', ')), leading: const Icon(Icons.translate)),
        const SizedBox(height: 32),
        ElevatedButton(onPressed: () {}, child: Text(loc.saveProfile)),
      ],
    );
  }
}

class _NoticeBoardView extends StatelessWidget {
  const _NoticeBoardView();
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Center(child: Text(loc.noticeBoard));
  }
}
