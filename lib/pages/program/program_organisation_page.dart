import 'package:flutter/material.dart';
import '../../components/custom_app_bar.dart';

class ProgramOrganisationPage extends StatefulWidget {
  final Map<String, List<Map<String, String>>> weekProgram;
  const ProgramOrganisationPage({super.key, required this.weekProgram});

  @override
  State<ProgramOrganisationPage> createState() => _ProgramOrganisationPageState();
}

class _ProgramOrganisationPageState extends State<ProgramOrganisationPage> {
  late Map<String, List<Map<String, String>>> localWeekProgram;
  final List<String> weekDays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    localWeekProgram = {
      for (final day in weekDays)
        day: widget.weekProgram[day]?.map((entry) => Map<String, String>.from(entry)).toList() ?? []
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
              final dayName = weekDays[idx];
              return Card(
                color: isDark ? Colors.grey[850] : null,
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[800] : Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              dayName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isDark ? Colors.white : null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 90,
                            height: 38,
                            child: DropdownButton<String>(
                              hint: const Text('Copy', style: TextStyle(fontSize: 12)),
                              value: null,
                              style: const TextStyle(fontSize: 12),
                              isDense: true,
                              alignment: Alignment.centerLeft,
                              underline: SizedBox.shrink(),
                              iconSize: 18,
                              items: weekDays.map((copyDay) => DropdownMenuItem(
                                value: copyDay,
                                child: Text(copyDay, style: const TextStyle(fontSize: 12)),
                              )).toList(),
                              onChanged: (copyDay) {
                                if (copyDay != null && copyDay != dayName) {
                                  setState(() {
                                    localWeekProgram[dayName] = localWeekProgram[copyDay]!.map((e) => Map<String, String>.from(e)).toList();
                                  });
                                }
                              },
                              dropdownColor: isDark ? Colors.grey[800] : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...localWeekProgram[dayName]!.asMap().entries.map((entryMap) {
                              final entry = entryMap.value;
                              final entryIdx = entryMap.key;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    final fromParts = entry['from']!.split(':');
                                    final toParts = entry['to']!.split(':');
                                    TimeOfDay? fromTime = TimeOfDay(hour: int.parse(fromParts[0]), minute: int.parse(fromParts[1]));
                                    TimeOfDay? toTime = TimeOfDay(hour: int.parse(toParts[0]), minute: int.parse(toParts[1]));
                                    final eventController = TextEditingController(text: entry['event']);
                                    final result = await showDialog<Map<String, String>>(
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return AlertDialog(
                                              title: const Text('Edit event'),
                                              content: SizedBox(
                                                width: 350,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: OutlinedButton(
                                                            onPressed: () async {
                                                              final picked = await showTimePicker(
                                                                context: context,
                                                                initialTime: fromTime ?? TimeOfDay.now(),
                                                                builder: (context, child) {
                                                                  return MediaQuery(
                                                                    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                                                    child: child!,
                                                                  );
                                                                },
                                                              );
                                                              if (picked != null) {
                                                                setState(() => fromTime = picked);
                                                              }
                                                            },
                                                            child: Text(fromTime == null ? 'Select start time' : (fromTime!.hour.toString().padLeft(2, '0') + ':' + fromTime!.minute.toString().padLeft(2, '0'))),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Expanded(
                                                          child: OutlinedButton(
                                                            onPressed: () async {
                                                              final picked = await showTimePicker(
                                                                context: context,
                                                                initialTime: toTime ?? TimeOfDay.now(),
                                                                builder: (context, child) {
                                                                  return MediaQuery(
                                                                    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                                                    child: child!,
                                                                  );
                                                                },
                                                              );
                                                              if (picked != null) {
                                                                setState(() => toTime = picked);
                                                              }
                                                            },
                                                            child: Text(toTime == null ? 'Select end time' : (toTime!.hour.toString().padLeft(2, '0') + ':' + toTime!.minute.toString().padLeft(2, '0'))),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 16),
                                                    TextField(
                                                      controller: eventController,
                                                      decoration: const InputDecoration(labelText: 'Title'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: const Text('Cancel'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    if (fromTime != null && toTime != null && eventController.text.isNotEmpty) {
                                                      String fromStr = fromTime!.hour.toString().padLeft(2, '0') + ':' + fromTime!.minute.toString().padLeft(2, '0');
                                                      String toStr = toTime!.hour.toString().padLeft(2, '0') + ':' + toTime!.minute.toString().padLeft(2, '0');
                                                      Navigator.pop(context, {
                                                        'from': fromStr,
                                                        'to': toStr,
                                                        'event': eventController.text,
                                                      });
                                                    }
                                                  },
                                                  child: const Text('Save'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    );
                                    if (result != null) {
                                      setState(() {
                                        localWeekProgram[dayName]![entryIdx] = result;
                                      });
                                    }
                                  },
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
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Color.fromARGB(255, 63, 63, 63)),
                                          tooltip: 'Delete event',
                                          onPressed: () {
                                            setState(() {
                                              localWeekProgram[dayName]!.removeAt(entryIdx);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                            // Add button
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                onPressed: () async {
                                  final newEntry = await showDialog<Map<String, String>>(
                                    context: context,
                                    builder: (context) {
                                      TimeOfDay? fromTime;
                                      TimeOfDay? toTime;
                                      final eventController = TextEditingController();
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                            title: const Text('Add new event'),
                                            content: SizedBox(
                                              width: 350,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: OutlinedButton(
                                                          onPressed: () async {
                                                            final picked = await showTimePicker(
                                                              context: context,
                                                              initialTime: fromTime ?? TimeOfDay.now(),
                                                              builder: (context, child) {
                                                                return MediaQuery(
                                                                  data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                                                  child: child!,
                                                                );
                                                              },
                                                            );
                                                            if (picked != null) {
                                                              setState(() => fromTime = picked);
                                                            }
                                                          },
                                                          child: Text(fromTime == null ? 'Select start time' : (fromTime!.hour.toString().padLeft(2, '0') + ':' + fromTime!.minute.toString().padLeft(2, '0'))),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: OutlinedButton(
                                                          onPressed: () async {
                                                            final picked = await showTimePicker(
                                                              context: context,
                                                              initialTime: toTime ?? TimeOfDay.now(),
                                                              builder: (context, child) {
                                                                return MediaQuery(
                                                                  data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                                                  child: child!,
                                                                );
                                                              },
                                                            );
                                                            if (picked != null) {
                                                              setState(() => toTime = picked);
                                                            }
                                                          },
                                                          child: Text(toTime == null ? 'Select end time' : (toTime!.hour.toString().padLeft(2, '0') + ':' + toTime!.minute.toString().padLeft(2, '0'))),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 16),
                                                  TextField(
                                                    controller: eventController,
                                                    decoration: const InputDecoration(labelText: 'Title'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('Cancel'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (fromTime != null && toTime != null && eventController.text.isNotEmpty) {
                                                    String fromStr = fromTime!.hour.toString().padLeft(2, '0') + ':' + fromTime!.minute.toString().padLeft(2, '0');
                                                    String toStr = toTime!.hour.toString().padLeft(2, '0') + ':' + toTime!.minute.toString().padLeft(2, '0');
                                                    Navigator.pop(context, {
                                                      'from': fromStr,
                                                      'to': toStr,
                                                      'event': eventController.text,
                                                    });
                                                  }
                                                },
                                                child: const Text('Add'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                  if (newEntry != null) {
                                    setState(() {
                                      localWeekProgram[dayName]!.add(newEntry);
                                    });
                                  }
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Add event'),
                              ),
                            ),
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
