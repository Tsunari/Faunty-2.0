import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cleaning_assign.dart';
import '../../components/custom_app_bar.dart';
import '../../state_management/cleaning_provider.dart';
import '../../state_management/user_list_provider.dart';

class CleaningPage extends ConsumerWidget {
  const CleaningPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cleaningDataAsync = ref.watch(cleaningDataProvider);
    final usersAsync = ref.watch(allUsersProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Cleaning',
        actions: [],
      ),
      body: usersAsync.when(
        data: (users) {
          final userMap = {for (var u in users) u.uid: u};
          return cleaningDataAsync.when(
            data: (data) {
              final places = data.entries.toList();
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (places.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          border: Border.all(color: Theme.of(context).dividerColor, width: 1.2),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        margin: const EdgeInsets.only(bottom: 0),
                        child: Row(
                          children: const [
                            Expanded(
                              flex: 2,
                              child: Text('Place', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, letterSpacing: 0.5)),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text('Assignees', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, letterSpacing: 0.5)),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: places.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 64.0, horizontal: 24.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.cleaning_services_rounded, size: 64, color: Theme.of(context).colorScheme.primary.withAlpha(180)),
                                    const SizedBox(height: 24),
                                    Text(
                                      'No cleaning places yet!',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.white70
                                            : Theme.of(context).colorScheme.primary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Tap below to create your first place and start assigning users.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.white54
                                            : Colors.black54,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 28),
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.add),
                                      label: const Text('Create Place'),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                      ),
                                      onPressed: () async {
                                        final controller = TextEditingController();
                                        final name = await showDialog<String>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Create Place'),
                                            content: TextField(
                                              controller: controller,
                                              autofocus: true,
                                              decoration: const InputDecoration(labelText: 'Place name'),
                                            ),
                                            actions: [
                                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                              ElevatedButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('Create')),
                                            ],
                                          ),
                                        );
                                        if (name != null && name.isNotEmpty) {
                                          final service = ref.read(cleaningFirestoreServiceProvider);
                                          await service.addPlace(name);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: places.length,
                              itemBuilder: (context, idx) {
                                final entry = places[idx];
                                final placeId = entry.key;
                                final placeData = entry.value as Map<String, dynamic>;
                                final placeName = placeData['name'] ?? '';
                                final assigned = (placeData['assignees'] as List?)?.cast<String>() ?? [];
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface,
                                    border: Border(
                                      left: BorderSide(color: Theme.of(context).dividerColor, width: 1.2),
                                      right: BorderSide(color: Theme.of(context).dividerColor, width: 1.2),
                                      bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1.2),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          placeName,
                                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, letterSpacing: 0.2),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: assigned.isNotEmpty
                                            ? Padding(
                                                padding: const EdgeInsets.only(left: 12.0),
                                                child: Wrap(
                                                  spacing: 8,
                                                  runSpacing: 4,
                                                  children: assigned
                                                      .map((entry) {
                                                        final parts = entry.split('_');
                                                        final label = parts.length >= 3 ? '${parts[1]} ${parts[2]}' : entry;
                                                        return Chip(
                                                          label: Text(label, style: const TextStyle(fontSize: 13)),
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                                          visualDensity: VisualDensity.compact,
                                                          backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(80),
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                          labelStyle: TextStyle(
                                                            color: Theme.of(context).colorScheme.onSurface,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        );
                                                      })
                                                      .toList(),
                                                ),
                                              )
                                            : const Text('No users assigned', style: TextStyle(color: Colors.grey)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error loading cleaning data: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error loading users: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final data = cleaningDataAsync.value ?? {};
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CleaningAssignPage(initialPlaces: Map<String, dynamic>.from(data)),
            ),
          );
        },
        tooltip: 'Edit',
        child: const Icon(Icons.edit),
      ),
    );
  }
}
