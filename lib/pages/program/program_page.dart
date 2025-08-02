import 'package:flutter/material.dart';
import '../../components/custom_app_bar.dart';
import '../program/program_organisation_page.dart';


class ProgramPage extends StatefulWidget {
  const ProgramPage({super.key});

  @override
  State<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  // Wochentage als Keys, damit Reihenfolge und Mapping immer stimmen
  final List<String> weekDays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  Map<String, List<Map<String, String>>> weekProgram = {
    'Monday': [
      {
       'from': '08:00',
       'to': '09:00',
       'event': 'Breakfast'
       },
      {'from': '09:30', 'to': '11:30', 'event': 'Class'},
      {'from': '12:00', 'to': '13:00', 'event': 'Lunch'},
      {'from': '15:00', 'to': '17:00', 'event': 'Free time'},
      {'from': '18:00', 'to': '19:00', 'event': 'Dinner'},
    ],
    'Tuesday': [
      {'from': '08:00', 'to': '09:00', 'event': 'Breakfast'},
      {'from': '09:30', 'to': '12:00', 'event': 'Hiking'},
      {'from': '12:00', 'to': '13:00', 'event': 'Lunch'},
      {'from': '15:00', 'to': '17:00', 'event': 'Workshop'},
      {'from': '18:00', 'to': '19:00', 'event': 'Dinner'},
    ],
    'Wednesday': [
      {'from': '08:00', 'to': '09:00', 'event': 'Breakfast'},
      {'from': '09:30', 'to': '11:00', 'event': 'Sports'},
      {'from': '12:00', 'to': '13:00', 'event': 'Lunch'},
      {'from': '15:00', 'to': '16:30', 'event': 'Creative time'},
      {'from': '18:00', 'to': '19:00', 'event': 'Dinner'},
    ],
    'Thursday': [
      {'from': '08:00', 'to': '09:00', 'event': 'Breakfast'},
      {'from': '09:30', 'to': '13:00', 'event': 'Excursion'},
      {'from': '13:00', 'to': '14:00', 'event': 'Picnic'},
      {'from': '15:00', 'to': '17:00', 'event': 'Games'},
      {'from': '18:00', 'to': '19:00', 'event': 'Dinner'},
    ],
    'Friday': [
      {'from': '08:00', 'to': '09:00', 'event': 'Breakfast'},
      {'from': '09:30', 'to': '11:30', 'event': 'Class'},
      {'from': '12:00', 'to': '13:00', 'event': 'Lunch'},
      {'from': '15:00', 'to': '17:00', 'event': 'Free time'},
      {'from': '18:00', 'to': '19:00', 'event': 'Dinner'},
    ],
    'Saturday': [
      {'from': '08:00', 'to': '09:00', 'event': 'Breakfast'},
      {'from': '09:30', 'to': '12:00', 'event': 'Competition'},
      {'from': '12:00', 'to': '13:00', 'event': 'Lunch'},
      {'from': '15:00', 'to': '17:00', 'event': 'Cinema'},
      {'from': '18:00', 'to': '19:00', 'event': 'Dinner'},
    ],
    'Sunday': [
      {'from': '08:00', 'to': '09:00', 'event': 'Breakfast'},
      {'from': '09:30', 'to': '11:00', 'event': 'Departure'},
    ],
  };

  String getWeekdayFromDate(DateTime date) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Program',
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 7,
            itemBuilder: (context, idx) {
              final date = now.add(Duration(days: idx));
              final dayName = getWeekdayFromDate(date);
              final entries = weekProgram[dayName] ?? [];
              final isToday = date.day == now.day && date.month == now.month && date.year == now.year;
              TimeOfDay nowTime = TimeOfDay.now();
              int? currentEventIdx;
              if (isToday) {
                for (int i = 0; i < entries.length; i++) {
                  final fromParts = entries[i]['from']!.split(':');
                  final toParts = entries[i]['to']!.split(':');
                  final from = TimeOfDay(hour: int.parse(fromParts[0]), minute: int.parse(fromParts[1]));
                  final to = TimeOfDay(hour: int.parse(toParts[0]), minute: int.parse(toParts[1]));
                  bool afterFrom = nowTime.hour > from.hour || (nowTime.hour == from.hour && nowTime.minute >= from.minute);
                  bool beforeTo = nowTime.hour < to.hour || (nowTime.hour == to.hour && nowTime.minute <= to.minute);
                  if (afterFrom && beforeTo) {
                    currentEventIdx = i;
                    break;
                  }
                }
              }
              return Card(
                color: isDark ? Colors.grey[850] : null,
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isToday
                              ? Colors.blue.shade400
                              : isDark
                                  ? Colors.grey[800]
                                  : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dayName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isToday ? Colors.white : isDark ? Colors.white : null,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}',
                              style: TextStyle(
                                fontSize: 14,
                                color: isToday ? Colors.white : isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...entries.asMap().entries.map((entryMap) {
                              final entry = entryMap.value;
                              final entryIdx = entryMap.key;
                              final isCurrent = isToday && currentEventIdx == entryIdx;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.green.shade900 : Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: isCurrent ? Border.all(color: Colors.red, width: 2) : null,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${entry['from']} - ${entry['to']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: isDark ? Colors.white : null,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          entry['event']!,
                                          style: TextStyle(
                                            color: isDark ? Colors.white : null,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProgramOrganisationPage(
                weekProgram: weekProgram,
              ),
            ),
          );
          if (result != null && result is Map<String, List<Map<String, String>>>) {
            setState(() {
              weekProgram = Map<String, List<Map<String, String>>>.from(result);
            });
          }
        },
        tooltip: 'Edit program',
        child: const Icon(Icons.edit),
      ),
    );
  }
}
