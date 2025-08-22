import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faunty/models/custom_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faunty/state_management/custom_list_provider.dart';

class AssignmentListWidget extends ConsumerWidget {
  final String placeId;
  final CustomList list;
  const AssignmentListWidget({super.key, required this.placeId, required this.list});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final itemsAsync = ref.watch(customListItemsProvider(ListKey(placeId, list.id)));
    return itemsAsync.when(
      data: (items) {
        if (items.isEmpty) return Center(child: Text('No items yet. Tap + to add.'));
        return ReorderableListView.builder(
          itemCount: items.length,
          onReorder: (oldIndex, newIndex) async {
            final ids = items.map((e) => e.id).toList();
            final moved = ids.removeAt(oldIndex);
            ids.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, moved);
            await ref.read(customListServiceProvider).reorderItems(placeId, list.id, ids);
          },
          itemBuilder: (ctx, index) {
            final item = items[index];
            return _AssignmentRow(key: ValueKey(item.id), item: item, placeId: placeId, listId: list.id);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }
}

class _AssignmentRow extends ConsumerStatefulWidget {
  final ListItem item;
  final String placeId;
  final String listId;
  const _AssignmentRow({required this.item, required this.placeId, required this.listId, Key? key}) : super(key: key);

  @override
  ConsumerState<_AssignmentRow> createState() => _AssignmentRowState();
}

class _AssignmentRowState extends ConsumerState<_AssignmentRow> {
  late TextEditingController leftCtrl;
  late TextEditingController rightCtrl;

  @override
  void initState() {
    super.initState();
    leftCtrl = TextEditingController(text: widget.item.payload['left']?.toString() ?? '');
    rightCtrl = TextEditingController(text: widget.item.payload['right']?.toString() ?? '');
  }

  @override
  void dispose() {
    leftCtrl.dispose();
    rightCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await ref.read(customListServiceProvider).updateItem(widget.placeId, widget.listId, widget.item.id, {
      'payload': {'left': leftCtrl.text.trim(), 'right': rightCtrl.text.trim()},
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: widget.key,
      title: Row(
        children: [
          Expanded(child: TextField(controller: leftCtrl, decoration: const InputDecoration(border: InputBorder.none, hintText: 'Task'))),
          const SizedBox(width: 12),
          SizedBox(width: 160, child: TextField(controller: rightCtrl, decoration: const InputDecoration(border: InputBorder.none, hintText: 'Assignee'))),
        ],
      ),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(icon: const Icon(Icons.save), onPressed: _save),
        IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => ref.read(customListServiceProvider).deleteItem(widget.placeId, widget.listId, widget.item.id)),
      ]),
    );
  }
}
