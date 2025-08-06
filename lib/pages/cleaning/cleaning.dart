import 'package:faunty/components/role_gate.dart';
import 'package:faunty/global_styles.dart';
import 'package:faunty/models/user_roles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cleaning_assign.dart';
import '../../components/custom_app_bar.dart';
import '../../state_management/cleaning_provider.dart';

class CleaningPage extends ConsumerWidget {
  const CleaningPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cleaningDataAsync = ref.watch(cleaningDataProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Cleaning',
        actions: [],
      ),
      body: cleaningDataAsync.when(
        data: (data) {
          final places = data.entries.toList();
          final placesNoUser = ref.watch(placesEmptyProvider);
          print('Places empty: $placesNoUser');
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (places.isNotEmpty && !placesNoUser)
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
                  child: (places.isEmpty || placesNoUser)
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 64.0, horizontal: 24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.cleaning_services_rounded, size: 64, color: notFoundIconColor(context)),
                                const SizedBox(height: 24),
                                Text(
                                  placesNoUser && places.isEmpty ? 'No cleaning places yet!' : 'No users assigned to any places.',
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
                                RoleGate(
                                  minRole: UserRole.baskan,
                                  child: Text(
                                    placesNoUser && places.isEmpty 
                                    ? 'Tap below to create your first place and start assigning users.' 
                                    : 'Assign users to your existing places using the action button below.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white54
                                          : Colors.black54,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 28),
                                placesNoUser && places.isEmpty ? RoleGate(
                                  minRole: UserRole.baskan,
                                  child: ElevatedButton.icon(
                                    icon: Icon(Icons.add_box, color: notFoundIconColor(context)),
                                    label: Text('Create Place', style: TextStyle(color: notFoundIconColor(context))),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                                ) : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: places.length,
                          itemBuilder: (context, idx) {
                            final entry = places[idx];
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
      ),
      floatingActionButton: RoleGate(
        minRole: UserRole.baskan,
        child: FloatingActionButton(
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
      ),
    );
  }
}
