import 'package:flutter/material.dart';

class AssignmentViewer extends StatelessWidget {
  final String listId;
  final Map<String, dynamic> content;
  const AssignmentViewer({
    super.key,
    required this.listId,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final categories = Map<String, dynamic>.from(
      content['categories'] as Map? ?? const {},
    );
    if (categories.isEmpty) {
      return Center(child: Text('No categories yet'));
    }
    return ListView.separated(
      itemCount: categories.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final key = categories.keys.elementAt(index);
        final category = Map<String, dynamic>.from(
          categories[key] as Map? ?? const {},
        );
        final name = category['name']?.toString() ?? key;
        final assignees =
            (category['assignees'] as List?)?.cast<String>() ??
            const <String>[];
        return ListTile(
          title: Text(name),
          subtitle: assignees.isEmpty
              ? const Text('-')
              : Wrap(
                  spacing: 6,
                  children: assignees.map((e) => Chip(label: Text(e))).toList(),
                ),
        );
      },
    );
  }
}
