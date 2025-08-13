import 'package:flutter/material.dart';

class ScheduleEditor extends StatefulWidget {
  final String listId;
  final Map<String, dynamic> initialContent;
  final void Function(Map<String, dynamic> updated) onSave;

  const ScheduleEditor({
    super.key,
    required this.listId,
    required this.initialContent,
    required this.onSave,
  });

  @override
  State<ScheduleEditor> createState() => _ScheduleEditorState();
}

class _ScheduleEditorState extends State<ScheduleEditor> {
  late Map<String, dynamic> _local;

  @override
  void initState() {
    super.initState();
    _local = {
      'weekProgram': Map<String, dynamic>.from(
        widget.initialContent['weekProgram'] as Map? ?? const {},
      ),
    };
    // Ensure all days exist
    for (final d in const [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ]) {
      _local['weekProgram'][d] ??= <Map<String, dynamic>>[];
    }
  }

  Future<void> _addEntry(String day) async {
    final titleController = TextEditingController();
    final timeController = TextEditingController();
    final res = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add entry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(labelText: 'Time (optional)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (res == true) {
      final entries = List<Map<String, dynamic>>.from(
        _local['weekProgram'][day] as List,
      );
      entries.add({
        'title': titleController.text.trim(),
        'time': timeController.text.trim(),
      });
      setState(() => _local['weekProgram'][day] = entries);
    }
  }

  void _deleteEntry(String day, int idx) {
    final entries = List<Map<String, dynamic>>.from(
      _local['weekProgram'][day] as List,
    );
    if (idx >= 0 && idx < entries.length) {
      entries.removeAt(idx);
      setState(() => _local['weekProgram'][day] = entries);
    }
  }

  @override
  Widget build(BuildContext context) {
    final weekProgram = Map<String, dynamic>.from(_local['weekProgram'] as Map);
    final days = const [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => widget.onSave(_local),
              icon: const Icon(Icons.save),
              label: const Text('Save'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              final entries =
                  (weekProgram[day] as List?)?.cast<Map>() ?? const <Map>[];
              return ExpansionTile(
                title: Row(
                  children: [
                    Text(day),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _addEntry(day),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                children: [
                  if (entries.isEmpty)
                    const ListTile(title: Text('-'))
                  else
                    for (int i = 0; i < entries.length; i++)
                      ListTile(
                        title: Text((entries[i]['title'] ?? '').toString()),
                        subtitle:
                            entries[i]['time'] != null &&
                                (entries[i]['time'] as String).isNotEmpty
                            ? Text((entries[i]['time']).toString())
                            : null,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _deleteEntry(day, i),
                        ),
                      ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
