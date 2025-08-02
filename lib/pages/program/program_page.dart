import 'package:flutter/material.dart';
import '../../components/custom_app_bar.dart';
import 'program_organisation_page.dart';


class ProgramPage extends StatefulWidget {
  const ProgramPage({super.key});

  @override
  State<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  List<List<Map<String, String>>> weekProgram = [
    [
      {'from': '08:00', 'to': '09:00', 'event': 'Breakfast'},
      {'from': '09:30', 'to': '11:30', 'event': 'Class'},
      {'from': '12:00', 'to': '13:00', 'event': 'Lunch'},
      {'from': '15:00', 'to': '17:00', 'event': 'Free time'},
      {'from': '18:00', 'to': '19:00', 'event': 'Dinner'},
    ],
    [
      {'from': '08:00', 'to': '09:00', 'event': 'Breakfast'},
      {'from': '09:30', 'to': '12:00', 'event': 'Hiking'},
      {'from': '12:00', 'to': '13:00', 'event': 'Lunch'},
      {'from': '15:00', 'to': '17:00', 'event': 'Workshop'},
      {'from': '18:00', 'to': '19:00', 'event': 'Dinner'},
    ],
    [
      {'from': '08:00', 'to': '09:00', 'event': 'Breakfast'},
      {'from': '09:30', 'to': '11:00', 'event': 'Sports'},
      {'from': '12:00', 'to': '13:00', 'event': 'Lunch'},
      {'from': '15:00', 'to': '16:30', 'event': 'Creative time'},
      {'from': '18:00', 'to': '19:00', 'event': 'Dinner'},
    ],
    [
      {'from': '08:00', 'to': '09:00', 'event': 'Breakfast'},
      {'from': '09:30', 'to': '13:00', 'event': 'Excursion'},
      {'from': '13:00', 'to': '14:00', 'event': 'Picnic'},
      {'from': '15:00', 'to': '17:00', 'event': 'Games'},
      {'from': '18:00', 'to': '19:00', 'event': 'Dinner'},
    ],
    [
      {'from': '08:00', 'to': '09:00', 'event': 'Breakfast'},
      {'from': '09:30', 'to': '11:30', 'event': 'Class'},
      {'from': '12:00', 'to': '13:00', 'event': 'Lunch'},
      {'from': '15:00', 'to': '17:00', 'event': 'Free time'},
      {'from': '18:00', 'to': '19:00', 'event': 'Dinner'},
    ],
    [
      {'from': '08:00', 'to': '09:00', 'event': 'Breakfast'},
      {'from': '09:30', 'to': '12:00', 'event': 'Competition'},
      {'from': '12:00', 'to': '13:00', 'event': 'Lunch'},
      {'from': '15:00', 'to': '17:00', 'event': 'Cinema'},
      {'from': '18:00', 'to': '19:00', 'event': 'Dinner'},
    ],
    [
      {'from': '08:00', 'to': '09:00', 'event': 'Breakfast'},
      {'from': '09:30', 'to': '11:00', 'event': 'Departure'},
    ],
  ];

  String getWeekday(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
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
              final date = monday.add(Duration(days: idx));
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
                          color: isDark ? Colors.grey[800] : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getWeekday(idx),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isDark ? Colors.white : null,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? Colors.white70 : Colors.black87,
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
                            ...weekProgram[idx].map((entry) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.green.shade900 : Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(12),
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
                            )),
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
          if (result != null && result is List<List<Map<String, String>>>) {
            setState(() {
              weekProgram = result;
            });
          }
        },
        tooltip: 'Edit program',
        child: const Icon(Icons.edit),
      ),
    );
  }
}
