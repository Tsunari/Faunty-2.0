
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state_management/user_list_provider.dart';
import '../../state_management/cleaning_provider.dart';
import 'package:uuid/uuid.dart';

class CleaningAssignPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> initialPlaces;
  const CleaningAssignPage({super.key, required this.initialPlaces});

  @override
  ConsumerState<CleaningAssignPage> createState() => _CleaningAssignPageState();
}

class _CleaningAssignPageState extends ConsumerState<CleaningAssignPage> {
  late Map<String, dynamic> places;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    places = Map<String, dynamic>.from(widget.initialPlaces);
  }

  void _addPlaceDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Place'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Place name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('Add')),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        final id = const Uuid().v4();
        places[id] = {'name': result, 'assignees': <String>[]};
      });
    }
  }

  void _editPlaceDialog(String placeId, String currentName) async {
    final controller = TextEditingController(text: currentName);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Place'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Place name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('Save')),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        places[placeId]['name'] = result;
      });
    }
  }

  void _deletePlace(String placeId) {
    setState(() {
      places.remove(placeId);
    });
  }

  void _toggleAssignee(String placeId, dynamic user) {
    setState(() {
      final assignees = List<String>.from(places[placeId]['assignees'] ?? []);
      final entry = '${user.uid}_${user.firstName}_${user.lastName}';
      final exists = assignees.contains(entry);
      if (exists) {
        assignees.remove(entry);
      } else {
        assignees.add(entry);
      }
      places[placeId]['assignees'] = assignees;
    });
  }

  Future<void> _saveAll() async {
    setState(() => isSaving = true);
    final service = ref.read(cleaningFirestoreServiceProvider);
    await service.setCleaning(places);
    setState(() => isSaving = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final usersAsync = ref.watch(allUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Assignments'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add Place',
              onPressed: _addPlaceDialog,
            ),
          ),
        ],
      ),
      body: usersAsync.when(
        data: (users) {
          if (places.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'No places yet.',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Create Place'),
                      onPressed: _addPlaceDialog,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView(
            children: [
              ...places.entries.map((entry) {
                final placeId = entry.key;
                final place = entry.value as Map<String, dynamic>;
                final placeName = place['name'] ?? '';
                final assignees = (place['assignees'] as List?)?.cast<String>() ?? [];
                return Card(
                  margin: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(placeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: 'Edit Place',
                              onPressed: () => _editPlaceDialog(placeId, placeName),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: 'Delete Place',
                              onPressed: () => _deletePlace(placeId),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 120, // Set your desired max height here
                          ),
                          child: SingleChildScrollView(
                            child: Wrap(
                              spacing: 4.0,
                              runSpacing: 4.0,
                              children: [
                                ...users.map((user) {
                                  final userName = '${user.firstName} ${user.lastName}';
                                  final entry = '${user.uid}_${user.firstName}_${user.lastName}';
                                  final isAssigned = assignees.contains(entry);
                                  return FilterChip(
                                    label: Text(userName),
                                    selected: isAssigned,
                                    onSelected: (_) => _toggleAssignee(placeId, user),
                                  );
                                }),
                                // Show assigned users as Chips (for visual feedback)
                                ...assignees.where((entry) {
                                  final parts = entry.split('_');
                                  return parts.length >= 3 && !users.any((u) => u.uid == parts[0]);
                                }).map((entry) {
                                  final parts = entry.split('_');
                                  final label = parts.length >= 3 ? '${parts[1]} ${parts[2]}' : entry;
                                  return Chip(label: Text(label));
                                }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        error: (e, st) => Center(child: Text('Error loading users: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isSaving ? null : _saveAll,
        tooltip: 'Save',
        backgroundColor: isDark ? Colors.teal[400] : null,
        foregroundColor: isDark ? Colors.black : null,
        child: isSaving ? const Icon(Icons.save) : const Icon(Icons.save),
        // child: isSaving ? CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary) : const Icon(Icons.save),
      ),
    );
  }
}
