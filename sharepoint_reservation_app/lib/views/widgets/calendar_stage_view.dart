import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../providers/booking_provider.dart';

class CalendarStageView extends StatelessWidget {
  const CalendarStageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookingProvider>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 800;

        Widget calendarWidget = Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              locale: provider.currentLocale == 'ja' ? 'ja_JP' : 'en_US',
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 90)),
              focusedDay: provider.selectedDay,
              currentDay: DateTime.now(),
              selectedDayPredicate: (day) =>
                  isSameDay(provider.selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                Provider.of<BookingProvider>(
                  context,
                  listen: false,
                ).selectDay(selectedDay);
              },
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );

        Widget slotsWidget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.translate('slots_header'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            provider.isLoading
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(provider.translate('loading')),
                        ],
                      ),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWide ? 2 : 1,
                      // Adjusted childAspectRatio down slightly to accommodate stacked text layers
                      childAspectRatio: isWide ? 3.2 : 3.8,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: provider.timeSlots.length,
                    itemBuilder: (context, index) {
                      String slot = provider.timeSlots[index];
                      bool isSelected = provider.selectedTimeSlot == slot;

                      // Extract categorized breakdown counts from provider
                      int jaCount = provider.getJapaneseStaffCountForSlot(slot);
                      int intlCount = provider.getIntlStudentCountForSlot(slot);

                      return Material(
                        color: isSelected ? Colors.blue : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () => provider.selectTimeSlot(slot),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.grey[300]!,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Left Layer: Time Block Window
                                Text(
                                  slot,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                // Right Layer: Stacked Metric Breakdown Display
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${provider.translate('ja_staff_label')}: $jaCount",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? Colors.white.withOpacity(0.9)
                                            : Colors.blue[800],
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "${provider.translate('intl_staff_label')}: $intlCount",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? Colors.white.withOpacity(0.9)
                                            : Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        );

        return isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 4, child: calendarWidget),
                  const SizedBox(width: 24),
                  Expanded(flex: 5, child: slotsWidget),
                ],
              )
            : Column(
                children: [
                  calendarWidget,
                  const SizedBox(height: 16),
                  slotsWidget,
                ],
              );
      },
    );
  }
}
