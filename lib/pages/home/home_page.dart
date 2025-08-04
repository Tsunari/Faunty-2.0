import 'package:flutter/material.dart';
import '../../components/custom_app_bar.dart';
import '../../pages/program/program_page.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state_management/user_provider.dart';
import '../../state_management/program_provider.dart';
import '../../state_management/catering_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const List<String> weekDaysFull = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];
  static const List<String> weekDaysShort = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];
  static const List<String> mealNames = [
    'Breakfast', 'Lunch', 'Dinner'
  ];

  List<Map<String, String>> getNextAppointments(Map<String, List<Map<String, String>>>? weekProgram) {
    if (weekProgram == null) return [];
    final now = DateTime.now();
    final todayIdx = now.weekday - 1; // Monday=0
    final nowTime = TimeOfDay(hour: now.hour, minute: now.minute);
    List<Map<String, String>> upcoming = [];
    for (int i = 0; i < 7; i++) {
      final dayIdx = (todayIdx + i) % 7;
      final dayFull = weekDaysFull[dayIdx];
      final dayShort = weekDaysShort[dayIdx];
      final events = weekProgram[dayFull] ?? [];
      for (final event in events) {
        if (i == 0) {
          final fromParts = event['from']!.split(':');
          final toParts = event['to']!.split(':');
          final from = TimeOfDay(hour: int.parse(fromParts[0]), minute: int.parse(fromParts[1]));
          final to = TimeOfDay(hour: int.parse(toParts[0]), minute: int.parse(toParts[1]));
          // Only show if event is current or in the future
          bool afterFrom = nowTime.hour > from.hour || (nowTime.hour == from.hour && nowTime.minute >= from.minute);
          bool beforeTo = nowTime.hour < to.hour || (nowTime.hour == to.hour && nowTime.minute <= to.minute);
          if (!(afterFrom && beforeTo) && (from.hour < nowTime.hour || (from.hour == nowTime.hour && from.minute <= nowTime.minute))) {
            continue;
          }
        }
        upcoming.add({
          'day': dayShort,
          'from': event['from']! ,
          'to': event['to']! ,
          'event': event['event']! ,
        });
        if (upcoming.length >= 5) return upcoming;
      }
    }
    return upcoming;
  }

 

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekProgramAsync = ref.watch(weekProgramProvider);
    final cateringAsync = ref.watch(cateringWeekPlanProvider);
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
        children: [
          SizedBox(
            width: width,
            child: Card(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Program',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    weekProgramAsync.when(
                      data: (data) {
                        final appointments = getNextAppointments(data);
                        if (appointments.isEmpty) {
                          return const Text('No appointments found for this week.');
                        }
                        return Column(
                          children: appointments.asMap().entries.map((entry) {
                            final a = entry.value;
                            bool isCurrent = false;
                            final now = DateTime.now();
                            final todayIdx = now.weekday - 1;
                            final nowTime = TimeOfDay(hour: now.hour, minute: now.minute);
                            final eventDayIdx = weekDaysShort.indexOf(a['day']!);
                            if (eventDayIdx == todayIdx) {
                              final fromParts = a['from']!.split(':');
                              final toParts = a['to']!.split(':');
                              final from = TimeOfDay(hour: int.parse(fromParts[0]), minute: int.parse(fromParts[1]));
                              final to = TimeOfDay(hour: int.parse(toParts[0]), minute: int.parse(toParts[1]));
                              bool afterFrom = nowTime.hour > from.hour || (nowTime.hour == from.hour && nowTime.minute >= from.minute);
                              bool beforeTo = nowTime.hour < to.hour || (nowTime.hour == to.hour && nowTime.minute <= to.minute);
                              isCurrent = afterFrom && beforeTo;
                            }
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
                          }).toList(),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, s) => const Text('Fehler beim Laden des Programms.'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.event, color: Colors.green),
                  const SizedBox(width: 12),
                  Expanded(
                    child: cateringAsync.when(
                      data: (data) {
                        // data ist List<List<List<String>>> (siehe Provider)
                        // Wir suchen den nächsten Termin für den aktuellen User
                        final user = ref.read(userProvider);
                        if (user == null) {
                          return const Text('No user loaded.');
                        }
                        final now = DateTime.now();
                        final todayIdx = now.weekday - 1; // Monday=0
                        // Find the next assignment for the user from today/now
                        // Find the next day (from today) where the user is assigned to at least one meal
                        for (int offset = 0; offset < 7; offset++) {
                          final dayIdx = (todayIdx + offset) % 7;
                          final List<int> assignedMeals = [];
                          final fullName = "${user.firstName} ${user.lastName}";
                          for (int meal = 0; meal < data[dayIdx].length; meal++) {
                            final names = data[dayIdx][meal];
                            if (names.contains(fullName)) {
                              assignedMeals.add(meal);
                            }
                          }
                          if (assignedMeals.isNotEmpty) {
                            final isToday = offset == 0;
                            final weekday = isToday ? 'Today' : weekDaysFull[dayIdx];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your next catering assignments:',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      weekday,
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                    ),
                                    const Text(': '),
                                    ...assignedMeals.asMap().entries.map((entry) => Row(
                                      children: [
                                        Text(
                                          mealNames[entry.value],
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                                        ),
                                        if (entry.key != assignedMeals.length - 1)
                                          const Text(', '),
                                      ],
                                    )),
                                  ],
                                ),
                              ],
                            );
                          }
                        }
                        return const Text('No upcoming catering assignment found.');
                      },
                      loading: () => const Text('Catering wird geladen...'),
                      error: (e, s) => const Text('Fehler beim Laden des Caterings.'),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  } // Ende build
} // Ende HomePage
