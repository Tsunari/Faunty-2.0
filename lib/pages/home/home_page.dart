import 'package:faunty/components/role_gate.dart';
import 'package:faunty/helper/logging.dart';
import 'package:faunty/models/user_roles.dart';
import 'package:faunty/pages/welcome/user_welcome_page.dart';
import 'package:flutter/material.dart';
import '../../components/custom_app_bar.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state_management/user_provider.dart';
import '../../state_management/program_provider.dart';
import '../../state_management/catering_provider.dart';
import '../../state_management/cleaning_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _navigated = false;

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
  void initState() {
    super.initState();
    // Navigation logic moved out of build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userProvider);
      if (_navigated) return;
      if (user == null && mounted && ModalRoute.of(context)?.settings.name != '/splash') {
        printError('UserEntity not loaded - HomePage build() called without loaded user!');
        printWarning('Navigiere automatisch zur SplashPage, weil kein User geladen ist.');
        _navigated = true;
        Navigator.of(context).pushReplacementNamed('/splash');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    printInfo(user != null ? 'UserEntity: uid=${user.uid}, email=${user.email}, role=${user.role}, place=${user.placeId}' : 'UserEntity NOT LOADED');
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Warte auf UserEntity... (HomePage wurde ohne geladenen User gebaut)')
            ],
          ),
        ),
      );
    }
    final weekProgramAsync = ref.watch(weekProgramProvider);
    final cateringAsync = ref.watch(cateringWeekPlanProvider);
    final cleaningAsync = ref.watch(cleaningDataProvider);
    final width = MediaQuery.of(context).size.width;
    return RoleGate(
      minRole: UserRole.talebe,
      fallback: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const UserWelcomePage(),
                settings: const RouteSettings(name: '/user-welcome'),
              ),
            );
          });
          return const SizedBox.shrink();
        },
      ),
      child: Scaffold(
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
                            return const Text('No program entries found for this week.');
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
                        error: (e, s) => Text('Fehler beim Laden des Programms: $e'), // TODO: send to support with error
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
                    const Icon(Icons.dining, color: Colors.green),
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
                                    'Your next catering assignment:',
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
            ),
            // Cleaning assignment widget
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.cleaning_services, color: Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: cleaningAsync.when(
                        data: (data) {
                          final user = ref.read(userProvider);
                          if (user == null) {
                            return const Text('No user loaded.');
                          }
                          final places = data as Map<String, dynamic>? ?? {};
                          // print('DEBUG: Firestore cleaning places: $places');
                          // print('DEBUG: Current user.uid: ${user.uid}');
                          if (places.isEmpty) {
                            return const Text('No cleaning assignments found.');
                          }
                          // Find all place names where the user is assigned
                          final userPlaces = <String>[];
                          places.forEach((placeId, placeData) {
                            // print('DEBUG: placeId=$placeId, placeData=$placeData');
                            if (placeData is Map) {
                              final assignees = placeData['assignees'];
                              // print('DEBUG:   assignees=$assignees');
                              if (assignees is List && assignees.any((a) {
                                if (a is String) {
                                  final assigneeUid = a.split('_').first;
                                  return assigneeUid == user.uid;
                                }
                                return false;
                              })) {
                                // print('DEBUG:   MATCH for user.uid in $assignees');
                                userPlaces.add(placeData['name'] as String? ?? placeId);
                              }
                            }
                          });
                          // print('DEBUG: userPlaces=$userPlaces');
                          if (userPlaces.isEmpty) {
                            return const Text('You have no cleaning assignment');
                          }
                          // if (userPlaces.length == places.length) {
                          //   return const Text('You are assigned to all cleaning places this week.');
                          // }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your cleaning assignment:',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              ...userPlaces.map((place) => Text( 
                                    place,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  )),
                            ],
                          );
                        },
                        loading: () => const Text('Cleaning assignments are loading...'),
                        error: (e, s) => const Text('Fehler beim Laden der Cleaning-Daten.'),
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
  } // Ende build
} // Ende HomePage
