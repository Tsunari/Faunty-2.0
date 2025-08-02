import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';

class ProgramPage extends StatelessWidget {
  const ProgramPage({super.key});

  // Beispielhafte Programmpunkte für 7 Tage
  final List<List<Map<String, String>>> weekProgram = const [
    [
      {'from': '08:00', 'to': '09:00', 'event': 'Frühstück'},
      {'from': '09:30', 'to': '11:30', 'event': 'Unterricht'},
      {'from': '12:00', 'to': '13:00', 'event': 'Mittagessen'},
      {'from': '15:00', 'to': '17:00', 'event': 'Freizeit'},
      {'from': '18:00', 'to': '19:00', 'event': 'Abendessen'},
    ],
    [
      {'from': '08:00', 'to': '09:00', 'event': 'Frühstück'},
      {'from': '09:30', 'to': '12:00', 'event': 'Wandern'},
      {'from': '12:00', 'to': '13:00', 'event': 'Mittagessen'},
      {'from': '15:00', 'to': '17:00', 'event': 'Workshop'},
      {'from': '18:00', 'to': '19:00', 'event': 'Abendessen'},
    ],
    [
      {'from': '08:00', 'to': '09:00', 'event': 'Frühstück'},
      {'from': '09:30', 'to': '11:00', 'event': 'Sport'},
      {'from': '12:00', 'to': '13:00', 'event': 'Mittagessen'},
      {'from': '15:00', 'to': '16:30', 'event': 'Kreativzeit'},
      {'from': '18:00', 'to': '19:00', 'event': 'Abendessen'},
    ],
    [
      {'from': '08:00', 'to': '09:00', 'event': 'Frühstück'},
      {'from': '09:30', 'to': '13:00', 'event': 'Ausflug'},
      {'from': '13:00', 'to': '14:00', 'event': 'Picknick'},
      {'from': '15:00', 'to': '17:00', 'event': 'Spiele'},
      {'from': '18:00', 'to': '19:00', 'event': 'Abendessen'},
    ],
    [
      {'from': '08:00', 'to': '09:00', 'event': 'Frühstück'},
      {'from': '09:30', 'to': '11:30', 'event': 'Unterricht'},
      {'from': '12:00', 'to': '13:00', 'event': 'Mittagessen'},
      {'from': '15:00', 'to': '17:00', 'event': 'Freizeit'},
      {'from': '18:00', 'to': '19:00', 'event': 'Abendessen'},
    ],
    [
      {'from': '08:00', 'to': '09:00', 'event': 'Frühstück'},
      {'from': '09:30', 'to': '12:00', 'event': 'Wettbewerb'},
      {'from': '12:00', 'to': '13:00', 'event': 'Mittagessen'},
      {'from': '15:00', 'to': '17:00', 'event': 'Kino'},
      {'from': '18:00', 'to': '19:00', 'event': 'Abendessen'},
    ],
    [
      {'from': '08:00', 'to': '09:00', 'event': 'Frühstück'},
      {'from': '09:30', 'to': '11:00', 'event': 'Abreise'},
    ],
  ];

  String getWeekday(int weekday) {
    const days = ['Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag'];
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${getWeekday(idx)}, ${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDark ? Colors.white : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...weekProgram[idx].map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Expanded(
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
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
