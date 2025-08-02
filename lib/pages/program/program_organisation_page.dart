import 'package:flutter/material.dart';
import '../../components/custom_app_bar.dart';

class ProgramOrganisationPage extends StatefulWidget {
  final List<List<Map<String, String>>> weekProgram;
  const ProgramOrganisationPage({super.key, required this.weekProgram});

  @override
  State<ProgramOrganisationPage> createState() => _ProgramOrganisationPageState();
}

class _ProgramOrganisationPageState extends State<ProgramOrganisationPage> {
  late List<List<Map<String, String>>> localWeekProgram;

  @override
  void initState() {
    super.initState();
    localWeekProgram = widget.weekProgram.map((day) => day.map((entry) => Map<String, String>.from(entry)).toList()).toList();
  }

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
        title: 'Program Organisation',
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
                            ...localWeekProgram[idx].map((entry) => Padding(
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
        onPressed: () {
          Navigator.pop(context, localWeekProgram);
        },
        tooltip: 'Save and go back',
        backgroundColor: isDark ? Colors.teal[400] : null,
        foregroundColor: isDark ? Colors.black : null,
        child: const Icon(Icons.save),
      ),
    );
  }
}
