import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faunty/models/custom_list.dart';
import 'package:faunty/state_management/custom_list_provider.dart';
import 'package:faunty/components/table_widget.dart';

class AssignmentListWidget extends ConsumerWidget {
  final String placeId;
  final CustomList list;
  const AssignmentListWidget({super.key, required this.placeId, required this.list});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(customListItemsProvider(ListKey(placeId, list.id)));
    return itemsAsync.when(
      data: (items) {
        // Convert ListItem to table items (Assignment or Subsection)
        List<dynamic> tableItems = [];
        List<(ListItem, int?)> pairs = [];
        for (final item in items) {
          final payload = item.payload;
          if (payload['type'] == 'subsection' && payload['rows'] != null) {
            final sub = Subsection(
              title: payload['title'] as String? ?? '',
              rows: (payload['rows'] as List).map((rowData) => Assignment(
                left: rowData['left'] as String? ?? '',
                right: rowData['right'] as String? ?? '',
                extras: rowData['extras'] ?? [],
              )).toList(),
            );
            tableItems.add(sub);
            pairs.add((item, null));
            for (int i = 0; i < sub.rows.length; i++) {
              pairs.add((item, i));
            }
          } else {
            final assignment = Assignment(
              left: payload['left'] as String? ?? '',
              right: payload['right'] as String? ?? '',
              extras: payload['extras'] ?? [],
            );
            tableItems.add(assignment);
            pairs.add((item, null));
          }
        }
        return TableWidget(
          items: tableItems,
          onSave: (index, left, newValue) async {
            final (item, rowIndex) = pairs[index];
            if (rowIndex == null) {
              // Assignment
              item.payload[left ? 'left' : 'right'] = newValue;
            } else {
              // Row in Subsection
              (item.payload['rows'] as List)[rowIndex][left ? 'left' : 'right'] = newValue;
            }
            await ref.read(customListActionsProvider).updateItem(placeId, list.id, item.id, {'payload': item.payload});
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }
}

