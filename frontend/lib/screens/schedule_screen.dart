import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  static const int startHour = 8; // 08:00
  static const int endHour = 20; // 20:00 (exclusive)
  static const Duration slotDuration = Duration(minutes: 30);

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime weekStartSunday = _startOfWeekSunday(now);
    final List<DateTime> weekDays =
        List.generate(7, (index) => weekStartSunday.add(Duration(days: index)));
    final int slotsCount = (endHour - startHour) * 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('קביעת תור'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double totalWidth = constraints.maxWidth;
            const double horizontalPadding = 8;
            const double cellSpacing = 4;
            const double timeColWidth = 48;
            // We have 7 gaps between: time column and day1 (1) + between day columns (6)
            final double gridWidth = totalWidth - horizontalPadding * 2 - timeColWidth - cellSpacing * 7;
            final double cellWidth = gridWidth / 7; // 7 day columns
            const double cellHeight = 32; // more compact height; vertical scroll only

            return Column(
              children: [
                // Header row with weekdays and dates
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: timeColWidth,
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text('שעה', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: cellSpacing),
                      ...List.generate(7, (col) {
                        final DateTime day = weekDays[col];
                        return Row(
                          children: [
                            SizedBox(
                              width: cellWidth,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    _hebrewWeekdayShort(day.weekday),
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _formatDayMonth(day),
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            if (col != 6) const SizedBox(width: cellSpacing),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
                    child: Column(
                      children: List.generate(slotsCount, (row) {
                        final int minutesFromStart = row * 30;
                        final int hour = startHour + (minutesFromStart ~/ 60);
                        final int minute = (minutesFromStart % 60);
                        // final String rowLabel = _formatTimeRaw(hour, minute); // not used in compact grid

                        return Padding(
                          padding: EdgeInsets.only(top: row == 0 ? 0 : cellSpacing),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Time column cell
                              SizedBox(
                                width: timeColWidth,
                                height: cellHeight,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    _formatTimeRaw(hour, minute),
                                    style: TextStyle(color: Colors.grey.shade700, fontSize: 11),
                                  ),
                                ),
                              ),
                              const SizedBox(width: cellSpacing),
                              // 7 day cells
                              ...List.generate(7, (col) {
                                final DateTime day = weekDays[col];
                                final DateTime slotStart =
                                    DateTime(day.year, day.month, day.day, hour, minute);
                                final DateTime slotEnd = slotStart.add(slotDuration);
                                final bool isPast = slotEnd.isBefore(now);
                                final bool isBooked = _isBooked(slotStart, slotEnd);
                                final bool isAvailable = !isPast && !isBooked;

                                Color bgColor;
                                if (isPast) {
                                  bgColor = Colors.grey.shade200; // show past lightly
                                } else if (isBooked) {
                                  bgColor = Colors.grey.shade400;
                                } else {
                                  bgColor = Colors.green.shade400;
                                }

                                return Row(
                                  children: [
                                    SizedBox(
                                      width: cellWidth,
                                      height: cellHeight,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: isAvailable
                                              ? () {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'נבחר תור: ${_hebrewWeekday(slotStart.weekday)} ${_formatDayMonth(slotStart)} ${_formatTime(slotStart)} – ${_formatTime(slotEnd)}',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              : null,
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: bgColor,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.grey.shade300, width: 0.5),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (col != 6) const SizedBox(width: cellSpacing),
                                  ],
                                );
                              }),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static DateTime _startOfWeekSunday(DateTime date) {
    // Dart weekday: Monday=1 ... Sunday=7. We want Sunday as start.
    final int daysFromSunday = date.weekday % 7; // Sunday -> 0, Monday -> 1 ...
    final DateTime sunday =
        DateTime(date.year, date.month, date.day).subtract(Duration(days: daysFromSunday));
    return DateTime(sunday.year, sunday.month, sunday.day);
  }

  static String _hebrewWeekday(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'שני';
      case DateTime.tuesday:
        return 'שלישי';
      case DateTime.wednesday:
        return 'רביעי';
      case DateTime.thursday:
        return 'חמישי';
      case DateTime.friday:
        return 'שישי';
      case DateTime.saturday:
        return 'שבת';
      case DateTime.sunday:
      default:
        return 'ראשון';
    }
  }

  static String _formatDayMonth(DateTime d) {
    return '${d.day}/${d.month}';
  }

  static String _formatTime(DateTime t) {
    final String h = t.hour.toString().padLeft(2, '0');
    final String m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  static String _formatTimeRaw(int hour, int minute) {
    final String h = hour.toString().padLeft(2, '0');
    final String m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  static bool _isBooked(DateTime start, DateTime end) {
    // Simple deterministic demo logic so we see booked/available mix
    final int minutesFromMidnight = start.hour * 60 + start.minute;
    final int slotIndex = minutesFromMidnight ~/ 30;
    final int dayIndex = start.weekday % 7; // Sunday=0
    return (slotIndex + dayIndex) % 4 == 0;
  }
}

String _hebrewWeekdayShort(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return 'ב';
    case DateTime.tuesday:
      return 'ג';
    case DateTime.wednesday:
      return 'ד';
    case DateTime.thursday:
      return 'ה';
    case DateTime.friday:
      return 'ו';
    case DateTime.saturday:
      return 'ש';
    case DateTime.sunday:
    default:
      return 'א';
  }
}


