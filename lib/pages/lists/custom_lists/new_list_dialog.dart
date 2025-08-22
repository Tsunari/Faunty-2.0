import 'package:flutter/material.dart';

class NewListDialog extends StatelessWidget {
  const NewListDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return AlertDialog(
      title: const Text('Create new list'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: 'List name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = controller.text.trim();
            Navigator.of(context).pop(name);
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
