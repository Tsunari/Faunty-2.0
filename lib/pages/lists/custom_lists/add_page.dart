import 'package:faunty/components/custom_snackbar.dart';
import 'package:faunty/pages/lists/custom_lists/new_list_dialog.dart';
import 'package:flutter/material.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.9),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.list_alt_rounded, size: 48),
                    const SizedBox(height: 12),
                    Text('Create a new list', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text('Add a custom list or tab to organize tasks, items or events.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final name = await showDialog<String>(
                          context: context,
                          builder: (ctx) {
                            return NewListDialog();
                          },
                        );
                        if (name != null && name.isNotEmpty) {
                          if (context.mounted) showCustomSnackBar(context, 'Created list: $name');
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Create new list'),
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
