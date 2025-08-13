import 'package:flutter/material.dart';

class AssignmentEditor extends StatefulWidget {
  final String listId;
  final Map<String, dynamic> initialContent;
  final void Function(Map<String, dynamic> updated) onSave;

  const AssignmentEditor({
    super.key,
    required this.listId,
    required this.initialContent,
    required this.onSave,
  });

  @override
  State<AssignmentEditor> createState() => _AssignmentEditorState();
}

class _AssignmentEditorState extends State<AssignmentEditor> {
  late Map<String, dynamic> _local;

  @override
  void initState() {
    super.initState();
    _local = {
      'categories': Map<String, dynamic>.from(
        widget.initialContent['categories'] as Map? ?? const {},
      ),
    };
  }

  void _addCategory() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (name != null && name.isNotEmpty) {
      setState(() {
        final id = DateTime.now().microsecondsSinceEpoch.toString();
        final categories = Map<String, dynamic>.from(
          _local['categories'] as Map,
        );
        categories[id] = {'name': name, 'assignees': <String>[]};
        _local['categories'] = categories;
      });
    }
  }

  void _deleteCategory(String id) {
    setState(() {
      final categories = Map<String, dynamic>.from(_local['categories'] as Map);
      categories.remove(id);
      _local['categories'] = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = Map<String, dynamic>.from(_local['categories'] as Map);
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _addCategory,
              icon: const Icon(Icons.add),
              label: const Text('Category'),
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
          child: ListView.separated(
            itemCount: categories.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final id = categories.keys.elementAt(index);
              final category = Map<String, dynamic>.from(categories[id] as Map);
              final name = category['name']?.toString() ?? id;
              final assignees =
                  (category['assignees'] as List?)?.cast<String>() ??
                  <String>[];
              return ListTile(
                title: Text(name),
                subtitle: Wrap(
                  spacing: 6,
                  children: assignees
                      .map(
                        (e) => InputChip(
                          label: Text(e),
                          onDeleted: () {
                            setState(() {
                              final updated = List<String>.from(assignees);
                              updated.remove(e);
                              categories[id] = {
                                ...category,
                                'assignees': updated,
                              };
                              _local['categories'] = categories;
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _deleteCategory(id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
