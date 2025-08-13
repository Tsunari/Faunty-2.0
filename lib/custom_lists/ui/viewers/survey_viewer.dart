import 'package:flutter/material.dart';

class SurveyViewer extends StatelessWidget {
  final String listId;
  final Map<String, dynamic> content;
  const SurveyViewer({super.key, required this.listId, required this.content});

  @override
  Widget build(BuildContext context) {
    final questions = Map<String, dynamic>.from(
      content['questions'] as Map? ?? const {},
    );
    final ids = questions.keys.toList();
    if (ids.isEmpty) return Center(child: Text('No questions yet'));
    return ListView.builder(
      itemCount: ids.length,
      itemBuilder: (context, index) {
        final qId = ids[index];
        final q = Map<String, dynamic>.from(questions[qId] as Map? ?? const {});
        final qText = (q['question'] ?? '').toString();
        final options =
            (q['options'] as List?)?.cast<String>() ?? const <String>[];
        final responses = Map<String, dynamic>.from(
          q['responses'] as Map? ?? const {},
        );
        return ExpansionTile(
          title: Text(qText),
          children: [
            for (int i = 0; i < options.length; i++)
              ListTile(
                title: Text(options[i]),
                trailing: Text(
                  '${responses.values.where((v) => v == i).length}',
                ),
              ),
          ],
        );
      },
    );
  }
}
