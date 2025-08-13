import 'package:flutter/material.dart';

class AttendanceEditor extends StatefulWidget {
  final String listId;
  final Map<String, dynamic> initialContent;
  final void Function(Map<String, dynamic> updated) onSave;

  const AttendanceEditor({
    super.key,
    required this.listId,
    required this.initialContent,
    required this.onSave,
  });

  @override
  State<AttendanceEditor> createState() => _AttendanceEditorState();
}

class _AttendanceEditorState extends State<AttendanceEditor> {
  late Map<String, dynamic> _local;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _presentController = TextEditingController();
  final TextEditingController _absentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _local = {
      'attendance': Map<String, dynamic>.from(
        widget.initialContent['attendance'] as Map? ?? const {},
      ),
      'roster': List<String>.from(
        widget.initialContent['roster'] as List? ?? const <String>[],
      ),
    };
  }

  @override
  void dispose() {
    _dateController.dispose();
    _presentController.dispose();
    _absentController.dispose();
    super.dispose();
  }

  Future<void> _addDay() async {
    final res = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add attendance'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Date (yyyy-MM-dd)'),
            ),
            TextField(
              controller: _presentController,
              decoration: const InputDecoration(
                labelText: 'Present (comma-separated user ids)',
              ),
            ),
            TextField(
              controller: _absentController,
              decoration: const InputDecoration(
                labelText: 'Absent (comma-separated user ids)',
              ),
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
      final date = _dateController.text.trim();
      final present = _presentController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      final absent = _absentController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      setState(() {
        final att = Map<String, dynamic>.from(_local['attendance'] as Map);
        att[date] = {'present': present, 'absent': absent};
        _local['attendance'] = att;
      });
    }
  }

  void _deleteDay(String date) {
    setState(() {
      final att = Map<String, dynamic>.from(_local['attendance'] as Map);
      att.remove(date);
      _local['attendance'] = att;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                // Add roster manager: enter comma separated ids for now (later can be user picker)
                final controller = TextEditingController(
                  text: (_local['roster'] as List?)?.join(',') ?? '',
                );
                final res = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Set roster (user IDs, comma-separated)'),
                    content: TextField(controller: controller),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                );
                if (res == true) {
                  setState(() {
                    _local['roster'] = controller.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList();
                  });
                }
              },
              icon: const Icon(Icons.group_outlined),
              label: const Text('Roster'),
            ),
            ElevatedButton.icon(
              onPressed: _addDay,
              icon: const Icon(Icons.add),
              label: const Text('Entry'),
            ),
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
          child: _AttendanceGrid(
            local: _local,
            onChanged: (next) => setState(() => _local = next),
            onDeleteDay: _deleteDay,
          ),
        ),
      ],
    );
  }
}

class _AttendanceGrid extends StatelessWidget {
  final Map<String, dynamic> local;
  final void Function(Map<String, dynamic>) onChanged;
  final void Function(String) onDeleteDay;
  const _AttendanceGrid({
    required this.local,
    required this.onChanged,
    required this.onDeleteDay,
  });

  @override
  Widget build(BuildContext context) {
    final attendance = Map<String, dynamic>.from(
      local['attendance'] as Map? ?? const {},
    );
    final roster =
        (local['roster'] as List?)?.cast<String>() ?? const <String>[];
    final dates = attendance.keys.toList()..sort();
    if (dates.isEmpty || roster.isEmpty) {
      return Center(child: Text('Add entries and roster to track attendance'));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          const DataColumn(label: Text('User')),
          for (final d in dates)
            DataColumn(
              label: Row(
                children: [
                  Text(d),
                  IconButton(
                    tooltip: 'Delete day',
                    onPressed: () => onDeleteDay(d),
                    icon: const Icon(Icons.close, size: 14),
                  ),
                ],
              ),
            ),
        ],
        rows: [
          for (final userId in roster)
            DataRow(
              cells: [
                DataCell(Text(userId)),
                for (final d in dates)
                  DataCell(
                    Checkbox(
                      value:
                          ((attendance[d] as Map?)?['present'] as List?)
                              ?.contains(userId) ??
                          false,
                      onChanged: (val) {
                        final next = Map<String, dynamic>.from(local);
                        final att = Map<String, dynamic>.from(
                          next['attendance'] as Map? ?? const {},
                        );
                        final rec = Map<String, dynamic>.from(
                          att[d] as Map? ?? const {},
                        );
                        final present = List<String>.from(
                          (rec['present'] as List?)?.cast<String>() ??
                              const <String>[],
                        );
                        final absent = List<String>.from(
                          (rec['absent'] as List?)?.cast<String>() ??
                              const <String>[],
                        );
                        if (val == true) {
                          if (!present.contains(userId)) present.add(userId);
                          absent.remove(userId);
                        } else {
                          present.remove(userId);
                          if (!absent.contains(userId)) absent.add(userId);
                        }
                        rec['present'] = present;
                        rec['absent'] = absent;
                        att[d] = rec;
                        next['attendance'] = att;
                        onChanged(next);
                      },
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
