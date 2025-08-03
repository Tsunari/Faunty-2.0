import 'package:faunty/pages/home/catering_widget.dart';
import 'package:flutter/material.dart';
import '../../components/custom_app_bar.dart';
import '../../pages/program/program_page.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state_management/user_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const List<String> weekDaysFull = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];
  static const List<String> weekDays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];

  List<Map<String, String>> getNextAppointments() {
    final now = DateTime.now();
    final todayIdx = now.weekday - 1; // Monday=0
    final nowTime = TimeOfDay(hour: now.hour, minute: now.minute);
    List<Map<String, String>> upcoming = [];
    for (int i = 0; i < 7; i++) {
      final dayIdx = (todayIdx + i) % 7;
      final dayFull = weekDaysFull[dayIdx];
      final dayAbbr = weekDays[dayIdx];
      final events = weekProgram[dayFull] ?? [];
      for (final event in events) {
        if (i == 0) {
          final fromParts = event['from']!.split(':');
          final toParts = event['to']!.split(':');
          final from = TimeOfDay(hour: int.parse(fromParts[0]), minute: int.parse(fromParts[1]));
          final to = TimeOfDay(hour: int.parse(toParts[0]), minute: int.parse(toParts[1]));
          // Show if event is current or in the future
          bool afterFrom = nowTime.hour > from.hour || (nowTime.hour == from.hour && nowTime.minute >= from.minute);
          bool beforeTo = nowTime.hour < to.hour || (nowTime.hour == to.hour && nowTime.minute <= to.minute);
          if (!(afterFrom && beforeTo) && (from.hour < nowTime.hour || (from.hour == nowTime.hour && from.minute <= nowTime.minute))) {
            continue;
          }
        }
        upcoming.add({
          'day': dayAbbr,
          'from': event['from']!,
          'to': event['to']!,
          'event': event['event']!,
        });
        if (upcoming.length >= 5) return upcoming;
      }
    }
    return upcoming;
  }

 

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointments = getNextAppointments();
    final width = MediaQuery.of(context).size.width;
    final user = ref.watch(userProvider);
    if (user != null) {
      // Print user info to console
      print('UserEntity: uid=${user.uid}, email=${user.email}, role=${user.role}, place=${user.place}');
    }
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Home'
      ),
      body: Column(
        children: [ //test
          SizedBox(
              width: width,
              child: Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Program-Box
                      const Text(
                        'Program',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      if (appointments.isEmpty)
                        const Text('No upcoming events.')
                      else
                        ...appointments.asMap().entries.map((entry) {
                          final a = entry.value;
                          bool isCurrent = false;
                          final now = DateTime.now();
                          final todayIdx = now.weekday - 1;
                          final nowTime = TimeOfDay(hour: now.hour, minute: now.minute);
                          final eventDayIdx = weekDays.indexOf(a['day']!);
                          if (eventDayIdx == todayIdx) {
                            final fromParts = a['from']!.split(':');
                            final toParts = a['to']!.split(':');
                            final from = TimeOfDay(hour: int.parse(fromParts[0]), minute: int.parse(fromParts[1]));
                            final to = TimeOfDay(hour: int.parse(toParts[0]), minute: int.parse(toParts[1]));
                            bool afterFrom = nowTime.hour > from.hour || (nowTime.hour == from.hour && nowTime.minute >= from.minute);
                            bool beforeTo = nowTime.hour < to.hour || (nowTime.hour == to.hour && nowTime.minute <= to.minute);
                            isCurrent = afterFrom && beforeTo;
                          }
                          // Add a gap if this is the first event of a new day
                          bool isNewDay = false;
                          if (entry.key == 0) {
                            isNewDay = true;
                          } else {
                            final prev = appointments[entry.key - 1];
                            isNewDay = a['day'] != prev['day'];
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isNewDay && entry.key != 0) const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness == Brightness.dark ? Colors.green.shade900 : Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isCurrent ? Colors.red : Colors.green.shade700,
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${a['day']} ',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text('${a['from']} - ${a['to']}: '),
                                      Expanded(child: Text(a['event']!)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      // Hier enden die appointments-Widgets
                    ], // Ende children von Column (Program-Box)
                  ), // Ende Column (Program-Box)
                ), // Ende Padding
              ), // Ende Card
            ), // Ende SizedBox
          // Ende Center
          nextCateringDutyWidget(username: "Ben")
        ], // Ende children von Column (body)
      ), // Ende Column (body)
    ); // Ende Scaffold
  } // Ende build
} // Ende HomePage
