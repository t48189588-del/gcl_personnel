import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_provider.dart';
import '../../models/models.dart';
import '../../services/ics_service.dart';
import 'package:intl/intl.dart';
import '../common/app_actions.dart';
import '../common/responsive_scaffold.dart';

class JuniorDashboard extends StatefulWidget {
  const JuniorDashboard({super.key});

  @override
  State<JuniorDashboard> createState() => _JuniorDashboardState();
}

class _JuniorDashboardState extends State<JuniorDashboard> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAvailabilityDeadline();
    });
  }

  void _checkAvailabilityDeadline() {
    final now = DateTime.now();
    if (now.day >= 24) {
      final provider = context.read<AppProvider>();
      final staff = provider.currentJuniorStaff;
      if (staff != null) {
        final nextMonth = DateTime(now.year, now.month + 1, 1);
        final hasNextMonthBlocks = provider.blocks.any(
          (b) =>
              b.staffId == staff.id &&
              b.startTime.year == nextMonth.year &&
              b.startTime.month == nextMonth.month,
        );
        if (!hasNextMonthBlocks) {
          _showDeadlineReminderDialog();
        }
      }
    }
  }

  void _showDeadlineReminderDialog() {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(loc.deadlineDialogTitle),
        content: Text(loc.deadlineDialogContent),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _selectedIndex = 0;
              });
            },
            child: Text(loc.goToSubmission),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: Text(loc.skip),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ResponsiveScaffold(
      appBar: AppBar(
        title: Text(loc.selfServicePortal),
        actions: buildGlobalAppActions(context),
      ),
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      railDestinations: [
        NavigationRailDestination(
          icon: const Icon(Icons.dashboard_outlined),
          selectedIcon: const Icon(Icons.dashboard),
          label: const Text('Agenda'),
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
      ],
      bottomDestinations: [
        const NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: 'Agenda',
        ),
        NavigationDestination(
          icon: const Icon(Icons.event_note_outlined),
          selectedIcon: const Icon(Icons.event_note),
          label: loc.eventProposal,
        ),
        NavigationDestination(
          icon: const Icon(Icons.person_outline),
          selectedIcon: const Icon(Icons.person),
          label: loc.profile,
        ),
      ],
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const _AgendaView();
      case 1:
        return const _EventProposalView();
      case 2:
        return const _ProfileView();
      default:
        return const _AgendaView();
    }
  }
}

enum CalendarViewType { day, week, month }

class _AvailabilitySubmissionScreen extends StatefulWidget {
  const _AvailabilitySubmissionScreen();

  @override
  State<_AvailabilitySubmissionScreen> createState() =>
      _AvailabilitySubmissionScreenState();
}

class _AvailabilitySubmissionScreenState
    extends State<_AvailabilitySubmissionScreen> {
  DateTime _selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month + 1,
    1,
  );
  CalendarViewType _viewType = CalendarViewType.day;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = context.watch<AppProvider>();
    final config = provider.operatingHours;
    final staff = provider.currentJuniorStaff;

    if (staff == null)
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(loc.noStaffLoggedIn)),
      );

    final dateOnly = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    var holidayCheck = config.holidays.where((h) => h.date == dateOnly);
    final isHoliday = holidayCheck.isNotEmpty;
    final holidayMessage = isHoliday ? holidayCheck.first.message : '';

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Slim Notice Bar
          _buildNoticeBar(context, provider, staff, loc),
          const SizedBox(height: 16),

          // Row 2: Today's Schedule
          Text(
            loc.todaySchedule,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildTodayTimeline(context, provider, staff, loc),
          const SizedBox(height: 20),

          // Row 3: Availability Submission Grid
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          loc.availabilitySubmissionTitle,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _showFinishEmploymentDialog(
                                context,
                                provider,
                                staff,
                                loc,
                              ),
                              icon: const Icon(
                                Icons.exit_to_app,
                                color: Colors.red,
                              ),
                              label: Text(
                                loc.finishEmployment,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: const Icon(Icons.download),
                              tooltip: loc.exportICS,
                              onPressed: () {
                                final myBlocks = provider.blocks
                                    .where((b) => b.staffId == staff.id)
                                    .toList();
                                ICSService.exportToICS(staff, myBlocks);
                              },
                            ),
                            const SizedBox(width: 8),
                            SegmentedButton<CalendarViewType>(
                              segments: [
                                ButtonSegment(
                                  value: CalendarViewType.month,
                                  label: Text(loc.month[0].toUpperCase()),
                                ),
                                ButtonSegment(
                                  value: CalendarViewType.week,
                                  label: Text(loc.week[0].toUpperCase()),
                                ),
                                ButtonSegment(
                                  value: CalendarViewType.day,
                                  label: Text(loc.day[0].toUpperCase()),
                                ),
                              ],
                              selected: {_viewType},
                              onSelectionChanged: (val) =>
                                  setState(() => _viewType = val.first),
                            ),
                            if (_viewType != CalendarViewType.month) ...[
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  size: 16,
                                ),
                                onPressed: () => setState(() {
                                  _selectedDate = _selectedDate.subtract(
                                    Duration(
                                      days: _viewType == CalendarViewType.week
                                          ? 7
                                          : 1,
                                    ),
                                  );
                                }),
                              ),
                            ],
                            ElevatedButton.icon(
                              icon: const Icon(Icons.calendar_month),
                              label: Text(
                                DateFormat('yyyy-MM-dd').format(_selectedDate),
                              ),
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: _selectedDate,
                                  firstDate: DateTime.now().subtract(
                                    const Duration(days: 365),
                                  ),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365),
                                  ),
                                );
                                if (date != null && mounted)
                                  setState(() => _selectedDate = date);
                              },
                            ),
                            if (_viewType != CalendarViewType.month) ...[
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                ),
                                onPressed: () => setState(() {
                                  _selectedDate = _selectedDate.add(
                                    Duration(
                                      days: _viewType == CalendarViewType.week
                                          ? 7
                                          : 1,
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (isHoliday && _viewType == CalendarViewType.day)
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                              '${loc.holidayNotice}\n$holidayMessage',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(color: Colors.red),
                            ),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: _buildDynamicCalendar(
                          context,
                          provider,
                          config,
                          staff,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayTimeline(
    BuildContext context,
    AppProvider provider,
    StaffMember staff,
    AppLocalizations loc,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final todayBlocks = provider.blocks
        .where(
          (b) =>
              b.staffId == staff.id &&
              b.startTime.year == today.year &&
              b.startTime.month == today.month &&
              b.startTime.day == today.day,
        )
        .toList();

    if (todayBlocks.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Text(
            loc.noScheduleToday,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    // Sort by startTime
    todayBlocks.sort((a, b) => a.startTime.compareTo(b.startTime));

    // Generate 48 slots of 30-minutes representing the 24 hours of today
    final slots = List.generate(48, (i) {
      return today.add(Duration(minutes: i * 30));
    });

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 48,
        itemBuilder: (context, index) {
          final slot = slots[index];
          final slotStr = DateFormat('HH:mm').format(slot);

          final matching = todayBlocks.firstWhere(
            (b) =>
                b.startTime.hour == slot.hour &&
                b.startTime.minute == slot.minute,
            orElse: () => AvailabilityBlock(
              id: '',
              startTime: slot,
              staffId: '',
              modality: '',
            ),
          );

          Color blockColor = Colors.transparent;
          if (matching.id.isNotEmpty) {
            if (matching.status == 'approved') {
              blockColor = Colors.green;
            } else if (matching.status == 'proposed') {
              blockColor = Colors.grey;
            }
          }

          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Container(
            width: 75,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: blockColor == Colors.transparent
                  ? (isDark ? Colors.grey.shade900 : Colors.grey.shade100)
                  : blockColor.withValues(alpha: 0.2),
              border: Border.all(
                color: blockColor == Colors.transparent
                    ? Colors.grey.shade300
                    : blockColor,
                width: blockColor == Colors.transparent ? 0.5 : 1.5,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  slotStr,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                if (blockColor != Colors.transparent) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: blockColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      matching.status == 'approved'
                          ? loc.approved
                          : loc.proposed,
                      style: const TextStyle(
                        fontSize: 8,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoticeBar(
    BuildContext context,
    AppProvider provider,
    StaffMember staff,
    AppLocalizations loc,
  ) {
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final locale = Localizations.localeOf(context).toString();

    // 1. Day >= 24 warning
    final showDeadlineWarning = now.day >= 24;

    // 2. Meetings
    final meetings = provider.externalMeetingRequests
        .where(
          (m) =>
              m.assignedStaffId == staff.id &&
              m.status == 'approved' &&
              m.requestedDate == todayDate,
        )
        .toList();

    // 3. Events
    final events = provider.eventProposals
        .where(
          (e) =>
              e.status == 'approved' &&
              DateTime(
                    e.proposedDate.year,
                    e.proposedDate.month,
                    e.proposedDate.day,
                  ) ==
                  todayDate,
        )
        .toList();

    // 4. Holiday
    final holiday = provider.operatingHours.holidays.firstWhere(
      (h) => DateTime(h.date.year, h.date.month, h.date.day) == todayDate,
      orElse: () => Holiday(date: DateTime(1970), message: ''),
    );
    final hasHoliday = holiday.message.isNotEmpty;

    // 5. Pending reports
    final pendingReports = provider.getPendingReports();

    List<Widget> notices = [];

    if (showDeadlineWarning) {
      notices.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.red.shade100,
            border: Border.all(color: Colors.red.shade300),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning, color: Colors.red, size: 16),
              const SizedBox(width: 6),
              Text(
                loc.deadlinePassedWarning,
                style: TextStyle(
                  color: Colors.red.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (hasHoliday) {
      notices.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            border: Border.all(color: Colors.orange.shade300),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.beach_access, color: Colors.orange.shade800, size: 16),
              const SizedBox(width: 6),
              Text(
                "${loc.holidaysLabel}: ${holiday.message}",
                style: TextStyle(
                  color: Colors.orange.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (meetings.isNotEmpty) {
      notices.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            border: Border.all(color: Colors.blue.shade300),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.meeting_room, color: Colors.blue.shade800, size: 16),
              const SizedBox(width: 6),
              Text(
                loc.assignedMeetingsCount(meetings.length),
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (events.isNotEmpty) {
      notices.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.purple.shade100,
            border: Border.all(color: Colors.purple.shade300),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.event, color: Colors.purple.shade800, size: 16),
              const SizedBox(width: 6),
              Text(
                "${loc.upcomingEvents} (${events.length})",
                style: TextStyle(
                  color: Colors.purple.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (pendingReports.isNotEmpty) {
      for (final report in pendingReports) {
        notices.add(
          GestureDetector(
            onTap: () =>
                _showWorkingReportDialog(context, provider, report, loc),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                border: Border.all(color: Colors.red.shade300),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.feedback_outlined,
                    color: Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${loc.fillReport}: ${DateFormat('MMM d').format(report.reportDate)}',
                    style: TextStyle(
                      color: Colors.red.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    if (notices.isEmpty) {
      final isJa = locale.startsWith('ja');
      final noNoticesText = isJa ? '今日の通知はありません。' : 'No notices for today.';
      notices.add(
        Text(
          noNoticesText,
          style: const TextStyle(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: notices,
      ),
    );
  }

  Widget _buildDynamicCalendar(
    BuildContext context,
    AppProvider provider,
    OperatingHours config,
    StaffMember staff,
  ) {
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
          final dayOnly = DateTime(
            targetDay.year,
            targetDay.month,
            targetDay.day,
          );
          final matchingHoliday = config.holidays.cast<Holiday?>().firstWhere(
            (h) => h!.date == dayOnly,
            orElse: () => null,
          );
          final isAllDayHoliday =
              matchingHoliday != null && matchingHoliday.isAllDay;
          final hasAnyHoliday = matchingHoliday != null;
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
                  color: hasAnyHoliday
                      ? Colors.red.withValues(alpha: 0.1)
                      : Colors.blue.withValues(alpha: 0.05),
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  child: Text(
                    DateFormat('E, MMM d').format(targetDay),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: hasAnyHoliday ? Colors.red : null,
                    ),
                  ),
                ),
                Expanded(
                  child: isAllDayHoliday
                      ? Center(
                          child: Text(
                            loc.holidayNotice,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : _buildTimeGrid(
                          context,
                          provider,
                          config,
                          staff,
                          targetDay,
                          true,
                          partialHoliday: matchingHoliday,
                        ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      final dayOnly = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      );
      final matchingHoliday = config.holidays.cast<Holiday?>().firstWhere(
        (h) => h!.date == dayOnly,
        orElse: () => null,
      );
      // If today is a full-day holiday, show a prominent notice instead of the grid
      if (matchingHoliday != null && matchingHoliday.isAllDay) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.beach_access, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              Text(
                loc.holidayNotice,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              if (matchingHoliday.message.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  matchingHoliday.message,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ],
          ),
        );
      }
      return _buildTimeGrid(
        context,
        provider,
        config,
        staff,
        _selectedDate,
        false,
        partialHoliday: (matchingHoliday != null && !matchingHoliday.isAllDay)
            ? matchingHoliday
            : null,
      );
    }
  }

  Widget _buildTimeGrid(
    BuildContext context,
    AppProvider provider,
    OperatingHours config,
    StaffMember staff,
    DateTime queryDate,
    bool isCompact, {
    Holiday? partialHoliday,
  }) {
    final loc = AppLocalizations.of(context)!;
    int dayIndex = queryDate.weekday;
    DaySchedule daySched = config.weeklySchedule.firstWhere(
      (ds) => ds.weekday == dayIndex,
    );
    if (daySched.isClosed)
      return Center(
        child: Text(loc.closed, style: const TextStyle(color: Colors.grey)),
      );

    // Employment check
    final isAfterEnd =
        staff.employmentEndDate != null &&
        queryDate.isAfter(staff.employmentEndDate!);
    final isDisabled = !staff.isActive || isAfterEnd;

    // Derive holiday blocked hour range for partial holidays
    int? holidayStartH;
    int? holidayEndH;
    if (partialHoliday != null) {
      holidayStartH = int.tryParse(partialHoliday.startTime.split(':').first);
      holidayEndH = int.tryParse(partialHoliday.endTime.split(':').first);
    }

    int startH = int.tryParse(daySched.startHour.split(':').first) ?? 9;
    int endH = int.tryParse(daySched.endHour.split(':').first) ?? 17;
    List<DateTime> timeSlots = [];
    for (int h = startH; h < endH; h++) {
      timeSlots.add(
        DateTime(queryDate.year, queryDate.month, queryDate.day, h, 0),
      );
      timeSlots.add(
        DateTime(queryDate.year, queryDate.month, queryDate.day, h, 30),
      );
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
          itemBuilder: (context, index) {
            final slotTime = timeSlots[index];
            // Determine if this specific slot is blocked by a partial-day holiday
            final isHolidayBlocked =
                holidayStartH != null &&
                holidayEndH != null &&
                slotTime.hour >= holidayStartH &&
                slotTime.hour < holidayEndH;
            return _TimeBlock(
              slot: slotTime,
              provider: provider,
              staff: staff,
              isHolidayBlocked: isHolidayBlocked,
            );
          },
        ),
      ),
    );
  }
}

class _TimeBlock extends StatelessWidget {
  final DateTime slot;
  final AppProvider provider;
  final StaffMember staff;
  final bool isHolidayBlocked;
  const _TimeBlock({
    required this.slot,
    required this.provider,
    required this.staff,
    this.isHolidayBlocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    // If this slot is blocked by a partial-day holiday, render a disabled tile
    if (isHolidayBlocked) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${DateFormat('HH:mm').format(slot)} - ${DateFormat('HH:mm').format(slot.add(const Duration(minutes: 30)))}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              loc.holidaySlotBlocked,
              style: TextStyle(fontSize: 8, color: Colors.red.shade400),
            ),
          ],
        ),
      );
    }

    final existingBlocks = provider.blocks.where(
      (b) => b.staffId == staff.id && b.startTime == slot,
    );
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
        bgColor = Theme.of(
          context,
        ).primaryColor.withValues(alpha: isDark ? 0.2 : 0.1);
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
          // --- Weekly hours limit enforcement ---
          final maxWeekly = provider.operatingHours.maxWeeklyHours;
          if (maxWeekly != null) {
            // Find the start of the week (Monday) containing this slot
            final weekStart = slot.subtract(Duration(days: slot.weekday - 1));
            final weekEnd = weekStart.add(const Duration(days: 7));
            final weekBlocksCount = provider.blocks
                .where(
                  (b) =>
                      b.staffId == staff.id &&
                      !b.startTime.isBefore(weekStart) &&
                      b.startTime.isBefore(weekEnd) &&
                      b.status != 'rejected',
                )
                .length;
            final weeklyHours = weekBlocksCount * 0.5;
            if (weeklyHours >= maxWeekly) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(loc.weeklyLimitDialogTitle),
                  content: Text(
                    loc.weeklyLimitDialogContent(maxWeekly.toString()),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        provider.addBlock(
                          AvailabilityBlock(
                            id: const Uuid().v4(),
                            startTime: slot,
                            staffId: staff.id,
                            modality: 'Both',
                          ),
                        );
                        Navigator.pop(ctx);
                      },
                      child: Text(loc.proceed),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(loc.cancel),
                    ),
                  ],
                ),
              );
              return;
            }
          }
          provider.addBlock(
            AvailabilityBlock(
              id: const Uuid().v4(),
              startTime: slot,
              staffId: staff.id,
              modality: 'Both',
            ),
          );
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
            Text(
              '${DateFormat('HH:mm').format(slot)} - ${DateFormat('HH:mm').format(slot.add(const Duration(minutes: 30)))}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            if (hasBlock) ...[
              Text(
                statusLabel,
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Tooltip(
                message: block!.modality,
                child: Text(
                  isAlert ? '!' : _localizeModality(block.modality, loc),
                  style: TextStyle(
                    fontSize: 10,
                    color: isAlert
                        ? Colors.red
                        : (isDark ? Colors.white70 : Colors.blueGrey.shade700),
                  ),
                ),
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

  void _showBlockDialog(
    BuildContext context,
    AppProvider provider,
    AvailabilityBlock block,
    StaffMember staff,
    AppLocalizations loc,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(DateFormat('HH:mm').format(block.startTime)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.selectModality,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...['Online', 'In Person', 'Both'].map(
              (m) => RadioListTile<String>(
                title: Text(_localizeModality(m, loc)),
                value: m,
                // ignore: deprecated_member_use
                groupValue: block.modality,
                // ignore: deprecated_member_use
                onChanged: (val) {
                  if (val != null) {
                    provider.updateBlockModality(block.id, val);
                    Navigator.pop(context);
                  }
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              provider.removeBlock(block.id);
              Navigator.pop(context);
            },
            child: Text(loc.removeBlock),
          ),
          TextButton(
            onPressed: () {
              provider.emergencyReschedule(block.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(loc.emergencyReschedule),
          ),
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
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = context.watch<AppProvider>();
    final staff = provider.currentJuniorStaff;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.eventProposal,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          Expanded(flex: 4, child: _buildProposalForm(context, provider, loc)),
          const Divider(height: 32),
          Text(
            'Proposal History & Post-Approval Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 6,
            child: _buildHistory(context, provider, staff?.name ?? '', loc),
          ),
        ],
      ),
    );
  }

  Widget _buildProposalForm(
    BuildContext context,
    AppProvider provider,
    AppLocalizations loc,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: loc.proposalTitle,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: loc.proposalDescription,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                '${loc.proposedDate}: ${DateFormat('yyyy-MM-dd').format(_selectedDate)} ${_selectedTime.format(context)}',
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  final ctx = context;
                  final d = await showDatePicker(
                    context: ctx,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  if (d != null && mounted) {
                    final t = await showTimePicker(
                      context: ctx,
                      initialTime: _selectedTime,
                    );
                    if (t != null && mounted) {
                      setState(() {
                        _selectedDate = d;
                        _selectedTime = t;
                      });
                    }
                  }
                },
                child: Text(loc.selectDate),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              final finalDateTime = DateTime(
                _selectedDate.year,
                _selectedDate.month,
                _selectedDate.day,
                _selectedTime.hour,
                _selectedTime.minute,
              );
              provider.proposeEvent(
                _titleController.text,
                _descController.text,
                finalDateTime,
              );
              _titleController.clear();
              _descController.clear();
              if (mounted)
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(loc.proposalSubmitted)));
            },
            child: Text(loc.proposeEvent),
          ),
        ],
      ),
    );
  }

  Widget _buildHistory(
    BuildContext context,
    AppProvider provider,
    String staffName,
    AppLocalizations loc,
  ) {
    final myProposals = provider.eventProposals
        .where((p) => p.proposerName == staffName)
        .toList();
    if (myProposals.isEmpty) {
      return Center(child: Text(loc.noEventProposals));
    }

    return ListView.builder(
      itemCount: myProposals.length,
      itemBuilder: (context, index) {
        final p = myProposals[index];
        final isApproved = p.status == 'approved';

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            title: Text(
              p.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Status: ${p.status.toUpperCase()} - ${DateFormat('yyyy-MM-dd').format(p.proposedDate)}',
            ),
            leading: Icon(
              isApproved
                  ? Icons.check_circle
                  : (p.status == 'rejected' ? Icons.cancel : Icons.pending),
              color: isApproved
                  ? Colors.green
                  : (p.status == 'rejected' ? Colors.red : Colors.orange),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(p.description),
                    const SizedBox(height: 16),
                    if (isApproved) ...[
                      const Divider(),
                      Text(
                        'Post-Approval Details (For SNS)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Event Summary for SNS',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Upload Photos'),
                            onPressed: () {},
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Details saved for publication!',
                                  ),
                                ),
                              );
                            },
                            child: const Text('Save Details'),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
  String _nativeLanguage = 'English';
  final Map<String, String> _selectedOtherLanguages = {};

  final Map<String, String> _languagesWithFlags = {
    'English': '🇺🇸',
    'Mandarin': '🇨🇳',
    'Spanish': '🇪🇸',
    'French': '🇫🇷',
    'Arabic': '🇸🇦',
    'Japanese': '🇯🇵',
    'Korean': '🇰🇷',
    'Vietnamese': '🇻🇳',
    'Thai': '🇹🇭',
    'Hindi': '🇮🇳',
    'Bengali': '🇧🇩',
    'Indonesian': '🇮🇩',
    'Malay': '🇲🇾',
    'Filipino': '🇵🇭',
    'Burmese': '🇲🇲',
    'Khmer': '🇰🇭',
    'Lao': '🇱🇦',
    'German': '🇩🇪',
    'Italian': '🇮🇹',
    'Portuguese': '🇵🇹',
    'Russian': '🇷🇺',
    'Turkish': '🇹🇷',
    'Urdu': '🇵🇰',
    'Tamil': '🇮🇳',
    'Cantonese': '🇭🇰',
  };

  @override
  void initState() {
    super.initState();
    final staff = context.read<AppProvider>().currentJuniorStaff!;
    _nameController = TextEditingController(text: staff.name)
      ..addListener(_checkForChanges);
    _originController = TextEditingController(text: staff.originCountry)
      ..addListener(_checkForChanges);
    _kanaController = TextEditingController(text: staff.kanaName)
      ..addListener(_checkForChanges);
    _studyController = TextEditingController(text: staff.degree)
      ..addListener(_checkForChanges);
    _descController = TextEditingController(text: staff.personalDescription)
      ..addListener(_checkForChanges);
    _emailController = TextEditingController(text: staff.email)
      ..addListener(_checkForChanges);
    _phoneController = TextEditingController(text: staff.phoneNumber)
      ..addListener(_checkForChanges);
    _nativeLanguage = staff.nativeLanguage;
    for (var skill in staff.languageSkills) {
      _selectedOtherLanguages[skill.language] = skill.proficiency;
    }
  }

  void _checkForChanges() {
    final staff = context.read<AppProvider>().currentJuniorStaff!;
    final changed =
        _nameController.text != staff.name ||
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
            Text(
              loc.personalProfile,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            ElevatedButton.icon(
              onPressed: () =>
                  _showFinishEmploymentDialog(context, provider, staff, loc),
              icon: const Icon(Icons.exit_to_app, color: Colors.red),
              label: Text(
                loc.finishEmployment,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Center(
          child: CircleAvatar(
            radius: 50,
            child: Text(staff.name[0], style: const TextStyle(fontSize: 40)),
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: loc.name,
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _kanaController,
          decoration: InputDecoration(
            labelText: loc.kanaName,
            prefixIcon: const Icon(Icons.abc),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _originController,
          decoration: InputDecoration(
            labelText: loc.originCountry,
            prefixIcon: const Icon(Icons.location_on),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _studyController,
          decoration: InputDecoration(
            labelText: loc.currentlyStudying,
            prefixIcon: const Icon(Icons.school),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: loc.emailLabel,
            prefixIcon: const Icon(Icons.email),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _phoneController,
          decoration: InputDecoration(
            labelText: loc.phoneNumber,
            prefixIcon: const Icon(Icons.phone),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _descController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: loc.personalDescription,
            prefixIcon: const Icon(Icons.description),
          ),
        ),
        const SizedBox(height: 24),
        DropdownButtonFormField<String>(
          value: _languagesWithFlags.containsKey(_nativeLanguage)
              ? _nativeLanguage
              : 'English',
          decoration: InputDecoration(
            labelText: loc.nativeLang,
            border: const OutlineInputBorder(),
          ),
          items: _languagesWithFlags.entries.map((entry) {
            return DropdownMenuItem(
              value: entry.key,
              child: Text('${entry.value} ${entry.key}'),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _nativeLanguage = val;
                _hasChanges = true;
              });
            }
          },
        ),
        const SizedBox(height: 24),
        Text(
          loc.otherLanguages,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Column(
          children: _languagesWithFlags.entries.map((entry) {
            final isSelected = _selectedOtherLanguages.containsKey(entry.key);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Checkbox(
                          value: isSelected,
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _selectedOtherLanguages[entry.key] = 'Basic';
                              } else {
                                _selectedOtherLanguages.remove(entry.key);
                              }
                              _hasChanges = true;
                            });
                          },
                        ),
                        Expanded(child: Text('${entry.value} ${entry.key}')),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: isSelected
                        ? DropdownButtonFormField<String>(
                            value: _selectedOtherLanguages[entry.key],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            items:
                                ['Basic', 'Intermediate', 'Advanced', 'Native']
                                    .map(
                                      (p) => DropdownMenuItem(
                                        value: p,
                                        child: Text(p),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedOtherLanguages[entry.key] = val;
                                  _hasChanges = true;
                                });
                              }
                            },
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _hasChanges
              ? () {
                  staff.name = _nameController.text;
                  staff.originCountry = _originController.text;
                  staff.kanaName = _kanaController.text;
                  staff.degree = _studyController.text;
                  staff.email = _emailController.text;
                  staff.phoneNumber = _phoneController.text;
                  staff.personalDescription = _descController.text;
                  staff.nativeLanguage = _nativeLanguage;
                  staff.languageSkills = _selectedOtherLanguages.entries
                      .map(
                        (e) => LanguageSkill(
                          language: e.key,
                          proficiency: e.value,
                        ),
                      )
                      .toList();
                  provider.updateJuniorProfile(staff);
                  setState(() => _hasChanges = false);
                }
              : null,
          child: Text(loc.saveProfile),
        ),
      ],
    );
  }
}

class _AgendaView extends StatelessWidget {
  const _AgendaView();
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = context.watch<AppProvider>();
    final staff = provider.currentJuniorStaff;

    if (staff == null) return Center(child: Text(loc.noStaffLoggedIn));

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Agenda & Notice Board',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          // Part 1: Notice Board
          Expanded(
            flex: 3,
            child: _buildNoticeBoard(context, provider, staff, loc),
          ),
          const Divider(height: 32),
          // Part 2: Bento Box Schedule
          Expanded(
            flex: 5,
            child: _buildBentoSchedule(context, provider, staff, loc),
          ),
          const SizedBox(height: 24),
          // Part 3: Submit Availability Button
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.calendar_month),
              label: const Text('Manage Availability & Schedule'),
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const _AvailabilitySubmissionScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeBoard(BuildContext context, AppProvider provider, StaffMember staff, AppLocalizations loc) {
    final pendingReports = provider.reports.where((r) => r.staffId == staff.id && !r.isSubmitted && r.scheduledEnd.isBefore(DateTime.now())).toList();
    final today = DateTime.now();
    final holidayCheck = provider.operatingHours.holidays.where((h) => h.date.year == today.year && h.date.month == today.month && h.date.day == today.day);
    final upcomingMeetings = provider.externalMeetingRequests.where((r) => r.assignedStaffId == staff.id && r.status == 'approved' && r.requestedTime.isAfter(today)).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (holidayCheck.isNotEmpty)
          Expanded(
            child: Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [Icon(Icons.celebration, color: Colors.red), SizedBox(width: 8), Text('Holiday Notice', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red))]),
                    const SizedBox(height: 8),
                    Text(holidayCheck.first.message),
                  ],
                ),
              ),
            ),
          ),
        if (pendingReports.isNotEmpty)
          Expanded(
            child: InkWell(
              onTap: () { /* Future integration: Navigate to reports */ },
              child: Card(
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [const Icon(Icons.warning_amber, color: Colors.orange), const SizedBox(width: 8), Text('${pendingReports.length} Pending Reports', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange))]),
                      const SizedBox(height: 8),
                      const Text('Please submit your working reports.'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        Expanded(
          child: Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [Icon(Icons.meeting_room, color: Colors.blue), SizedBox(width: 8), Text('Upcoming Meetings', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))]),
                  const SizedBox(height: 8),
                  if (upcomingMeetings.isEmpty)
                    const Text('No upcoming meetings.')
                  else
                    ...upcomingMeetings.take(2).map((m) => Text('${m.name} - ${DateFormat('MM/dd HH:mm').format(m.requestedTime)}')),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBentoSchedule(BuildContext context, AppProvider provider, StaffMember staff, AppLocalizations loc) {
    final today = DateTime.now();
    final todayBlocks = provider.blocks.where((b) => 
      b.staffId == staff.id && 
      b.startTime.year == today.year && 
      b.startTime.month == today.month && 
      b.startTime.day == today.day
    ).toList();
    todayBlocks.sort((a, b) => a.startTime.compareTo(b.startTime));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Today's Schedule", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        if (todayBlocks.isEmpty)
          const Expanded(child: Center(child: Text("No shifts scheduled for today.")))
        else
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: todayBlocks.map((b) {
                  Color bgColor;
                  if (b.status == 'approved') bgColor = Colors.green.shade100;
                  else if (b.status == 'rejected') bgColor = Colors.red.shade100;
                  else bgColor = Colors.grey.shade200;

                  return Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat('HH:mm').format(b.startTime), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        Text(DateFormat('HH:mm').format(b.startTime.add(const Duration(minutes: 30))), style: const TextStyle(color: Colors.black54)),
                        const Spacer(),
                        Text(b.status.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text(b.modality, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }
}

void _showFinishEmploymentDialog(
  BuildContext context,
  AppProvider provider,
  StaffMember staff,
  AppLocalizations loc,
) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(loc.employmentEndDialogTitle),
      content: Text(loc.employmentEndDialogContent),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(loc.cancel),
        ),
        OutlinedButton(
          onPressed: () {
            provider.finishEmployment(staff.id);
            Navigator.pop(context);
          },
          child: Text(loc.finishImmediately),
        ),
        ElevatedButton(
          onPressed: () async {
            final d = await showDatePicker(
              context: context,
              initialDate: DateTime.now().add(const Duration(days: 1)),
              firstDate: DateTime.now(),
              lastDate: DateTime(2030),
            );
            if (d != null && context.mounted) {
              provider.finishEmployment(staff.id, endDate: d);
              Navigator.pop(context);
            }
          },
          child: Text(loc.finishFutureDate),
        ),
      ],
    ),
  );
}

void _showWorkingReportDialog(
  BuildContext context,
  AppProvider provider,
  WorkingReport report,
  AppLocalizations loc,
) {
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
            ),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${loc.reportDate}: ${DateFormat('yyyy-MM-dd').format(report.reportDate)}',
                ),
                const SizedBox(height: 8),
                Text(
                  '${loc.scheduledTime}: ${DateFormat('HH:mm').format(report.scheduledStart)} - ${DateFormat('HH:mm').format(report.scheduledEnd)}',
                ),
                const Divider(height: 32),
                Row(
                  children: [
                    Text(
                      loc.confirmedStartTime,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Tooltip(
                      message: loc.helpConfirmedTime,
                      child: const Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(confirmedStart),
                          );
                          if (time != null) {
                            setState(
                              () => confirmedStart = DateTime(
                                report.reportDate.year,
                                report.reportDate.month,
                                report.reportDate.day,
                                time.hour,
                                time.minute,
                              ),
                            );
                          }
                        },
                        child: Text(DateFormat('HH:mm').format(confirmedStart)),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('-'),
                    ),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(confirmedEnd),
                          );
                          if (time != null) {
                            setState(
                              () => confirmedEnd = DateTime(
                                report.reportDate.year,
                                report.reportDate.month,
                                report.reportDate.day,
                                time.hour,
                                time.minute,
                              ),
                            );
                          }
                        },
                        child: Text(DateFormat('HH:mm').format(confirmedEnd)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  loc.workDoneLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
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
                Text(
                  '${loc.workedHours}: ${(confirmedEnd.difference(confirmedStart).inMinutes / 60.0).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dContext),
            child: Text(loc.cancel),
          ),
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
