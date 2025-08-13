import 'package:flutter/material.dart';

class SurveyEditor extends StatefulWidget {
  final String listId;
  final Map<String, dynamic> initialContent;
  final void Function(Map<String, dynamic> updated) onSave;

  const SurveyEditor({
    super.key,
    required this.listId,
    required this.initialContent,
    required this.onSave,
  });

  @override
  State<SurveyEditor> createState() => _SurveyEditorState();
}

class _SurveyEditorState extends State<SurveyEditor> {
  late Map<String, dynamic> _local;

  @override
  void initState() {
    super.initState();
    _local = {
      'questions': Map<String, dynamic>.from(
        widget.initialContent['questions'] as Map? ?? const {},
      ),
    };
  }

  Future<void> _addQuestion() async {
    final qController = TextEditingController();
    final oController = TextEditingController();
    final res = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add question'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: qController,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: oController,
              decoration: const InputDecoration(
                labelText: 'Options (comma-separated)',
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
      final id = DateTime.now().microsecondsSinceEpoch.toString();
      final options = oController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      setState(() {
        final q = Map<String, dynamic>.from(_local['questions'] as Map);
        q[id] = {
          'question': qController.text.trim(),
          'options': options,
          'responses': <String, int>{},
        };
        _local['questions'] = q;
      });
    }
  }

  void _deleteQuestion(String qId) {
    setState(() {
      final q = Map<String, dynamic>.from(_local['questions'] as Map);
      q.remove(qId);
      _local['questions'] = q;
    });
  }

  @override
  Widget build(BuildContext context) {
    final questions = Map<String, dynamic>.from(_local['questions'] as Map);
    final ids = questions.keys.toList();
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _addQuestion,
              icon: const Icon(Icons.add),
              label: const Text('Question'),
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
          child: ListView.builder(
            itemCount: ids.length,
            itemBuilder: (context, index) {
              final qId = ids[index];
              final q = Map<String, dynamic>.from(questions[qId] as Map);
              final qText = (q['question'] ?? '').toString();
              final options =
                  (q['options'] as List?)?.cast<String>() ?? const <String>[];
              return ExpansionTile(
                title: Text(qText),
                children: [
                  for (final opt in options) ListTile(title: Text(opt)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _deleteQuestion(qId),
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
