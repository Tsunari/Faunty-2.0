import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/custom_app_bar.dart';
import '../program/program_organisation_page.dart';
import '../../state_management/program_provider.dart';


const List<String> weekDays = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
];

class ProgramPage extends ConsumerStatefulWidget {
  const ProgramPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends ConsumerState<ProgramPage> {
  String getWeekdayFromDate(DateTime date) {
    return weekDays[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final weekProgramAsync = ref.watch(weekProgramProvider);
    return weekProgramAsync.when(
      data: (weekProgram) {
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
                  return SizedBox(
                    width: double.infinity,
                    child: Card(
                      color: isDark ? Colors.grey[850] : null,
                      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: IntrinsicHeight(
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
                                    if (entries.isEmpty)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Text(
                                          'No program for this day',
                                          style: TextStyle(
                                            color: isDark ? Colors.white70 : Colors.black54,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      )
                                    else
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
                                                    entry['event'] ?? '',
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
                final service = ref.read(programFirestoreServiceProvider);
                await service.setWeekProgram(result);
              }
            },
            tooltip: 'Edit program',
            child: const Icon(Icons.edit),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error loading program: $e')),
    );
  }
}
