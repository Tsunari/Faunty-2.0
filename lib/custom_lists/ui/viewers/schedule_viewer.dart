import 'package:flutter/material.dart';

class ScheduleViewer extends StatelessWidget {
  final String listId;
  final Map<String, dynamic> content;
  const ScheduleViewer({
    super.key,
    required this.listId,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final weekProgram = Map<String, dynamic>.from(
      content['weekProgram'] as Map? ?? const {},
    );
    final days = weekProgram.keys.toList();
    if (days.isEmpty) {
      return Center(child: Text('No schedule yet'));
    }
    return ListView.builder(
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        final entries =
            (weekProgram[day] as List?)?.cast<Map>() ?? const <Map>[];
        return ExpansionTile(
          title: Text(day),
          children: [
            if (entries.isEmpty)
              const ListTile(title: Text('-'))
            else
              for (final e in entries)
                ListTile(
                  title: Text((e['title'] ?? '').toString()),
                  subtitle:
                      e['time'] != null && (e['time'] as String).isNotEmpty
                      ? Text((e['time']).toString())
                      : null,
                ),
          ],
        );
      },
    );
  }
}
