import 'package:faunty/models/user_roles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state_management/user_list_provider.dart';
import '../models/user_entity.dart';

// Generic models exported for consumers
class Assignment {
  final String left;
  final String right;
  final List<String> extras;
  Assignment({required this.left, required this.right, this.extras = const []});
}

class Subsection {
  final String title;
  final List<Assignment> rows;
  Subsection({required this.title, required this.rows});
}

class TableWidget extends ConsumerStatefulWidget {
  final List<dynamic> items; // can be Assignment or Subsection in any order
  final bool showColumnHeaders;
  final String? leftHeader;
  final String? rightHeader;

  const TableWidget({
    super.key,
    required this.items,
    this.showColumnHeaders = true,
    this.leftHeader,
    this.rightHeader,
  });

  @override
  ConsumerState<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends ConsumerState<TableWidget> {
  int? editingRowIndex;
  bool editingLeft = true;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  final headerStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);
    final headerHeight = 36.0;

    final theme = Theme.of(context);
    final containerColor = theme.cardColor;
    final primary = theme.colorScheme.primary;

    // Build blocks: either Tables of assignments or subsection header + table
    final blocks = <Widget>[];
    final pending = <Assignment>[];
    int flatCounter = 0;

    void flushPending() {
      if (pending.isEmpty) return;
      final table = Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1)},
        border: TableBorder(
          horizontalInside: BorderSide(color: Colors.grey.shade300),
          verticalInside: BorderSide(color: Colors.grey.shade200),
        ),
        children: pending.map((r) => _buildRow(context, r, flatCounter++)).toList(),
      );
      blocks.add(table);
      pending.clear();
    }

    for (var item in widget.items) {
      if (item is Assignment) {
        pending.add(item);
      } else if (item is Subsection) {
        // flush assignments before subsection
        flushPending();
        // subsection header full-width
        blocks.add(Container(
          height: headerHeight,
          color: primary.withOpacity(0.12),
          alignment: Alignment.center,
          child: Text(item.title, style: headerStyle?.copyWith(color: primary)),
        ));
        // add subsection rows as a separate table
        final subTable = Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1)},
          border: TableBorder(
            horizontalInside: BorderSide(color: Colors.grey.shade300),
            verticalInside: BorderSide(color: Colors.grey.shade200),
          ),
          children: item.rows.map((r) => _buildRow(context, r, flatCounter++)).toList(),
        );
        blocks.add(subTable);
      }
    }
    flushPending();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: containerColor,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.showColumnHeaders) ...[
            Table(
              columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1)},
              children: [
                TableRow(children: [
                  Container(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), child: Text(widget.leftHeader ?? 'Left', style: headerStyle)),
                  Container(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), child: Text(widget.rightHeader ?? 'Right', style: headerStyle)),
                ]),
              ],
            ),
            const SizedBox(height: 6),
          ],

          // render blocks sequentially with separators between them so borders remain visible
          ..._interleaveWithSeparators(blocks, Theme.of(context).dividerColor),
        ],
      ),
    );
  }

  List<Widget> _interleaveWithSeparators(List<Widget> blocks, Color sepColor) {
    final out = <Widget>[];
    for (int i = 0; i < blocks.length; i++) {
      out.add(blocks[i]);
      if (i < blocks.length - 1) {
        // use Divider with same color/thickness as table horizontalInside for identical appearance
        out.add(Divider(height: 1, thickness: 1, color: Colors.grey.shade300));
      }
    }
    return out;
  }

  TableRow _buildRow(BuildContext context, Assignment r, int index) {
    final textStyle = Theme.of(context).textTheme.bodySmall;
  // watch users with roles hoca,baskan,talebe for the current place
  final rolesKey = [UserRole.talebe, UserRole.baskan, UserRole.hoca].map((r) => r.name).join(',');
  final usersAsync = ref.watch(usersByRolesAndPlaceProvider(rolesKey));
  final usersList = usersAsync.asData?.value ?? <UserEntity>[];
  final Map<String, UserEntity> usersById = {for (var u in usersList) u.uid: u};
    final isEditing = editingRowIndex == index;
    Widget leftCell;
    Widget rightCell;

    // Keep rows visually stable: fixed minimum height for both display and edit states
    const minRowHeight = 44.0;
    const iconSize = 20.0;

    // Helper to build the trailing icon buttons (do nothing for now)
    List<Widget> buildTrailingButtons() {
      return [
        // IconButton opens a custom overlay dropdown for multi-select
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(Icons.person, size: iconSize),
          onPressed: () => _showUserDropdown(index, editingLeft, context, usersList, editingLeft ? r.left : r.right),
        ),
        const SizedBox(width: 6),
        IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: const Icon(Icons.calendar_today, size: iconSize), onPressed: () {}),
        const SizedBox(width: 6),
        editingLeft ? Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: const Icon(Icons.access_time, size: iconSize), onPressed: () {}),
        ) : IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: const Icon(Icons.access_time, size: iconSize), onPressed: () {}),
      ];
    }

    if (isEditing && editingLeft) {
      leftCell = ConstrainedBox(
        constraints: const BoxConstraints(minHeight: minRowHeight),
        child: Row(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 2),
              child: TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                ),
                onSubmitted: (val) => _saveEdit(index, true, val),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ...buildTrailingButtons(),
        ]),
      );
    } else {
      leftCell = ConstrainedBox(
        constraints: const BoxConstraints(minHeight: minRowHeight),
        child: Row(children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _onCellTap(index, true, r.left),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                child: () {
                  final parts = r.left.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
                  final found = parts.where((p) => usersById.containsKey(p)).toList();
                  if (found.isNotEmpty) {
                    return Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: found.map((uid) {
                        final u = usersById[uid]!;
                        return Chip(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                          labelPadding: EdgeInsets.zero,
                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          label: Text('${u.firstName} ${u.lastName}', style: Theme.of(context).textTheme.bodySmall),
                        );
                      }).toList(),
                    );
                  }
                  return Text(r.left, style: textStyle, softWrap: true);
                }(),
              ),
            ),
          ),
        ]),
      );
    }

    if (isEditing && !editingLeft) {
      rightCell = ConstrainedBox(
        constraints: const BoxConstraints(minHeight: minRowHeight),
        child: Row(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                ),
                onSubmitted: (val) => _saveEdit(index, false, val),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ...buildTrailingButtons(),
        ]),
      );
    } else {
      rightCell = ConstrainedBox(
        constraints: const BoxConstraints(minHeight: minRowHeight),
        child: Row(children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _onCellTap(index, false, r.right),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                child: () {
                  final parts = r.right.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
                  final found = parts.where((p) => usersById.containsKey(p)).toList();
                  if (found.isNotEmpty) {
                    return Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: found.map((uid) {
                        final u = usersById[uid]!;
                        return Chip(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                          labelPadding: EdgeInsets.zero,
                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          label: Text('${u.firstName} ${u.lastName}', style: Theme.of(context).textTheme.bodySmall),
                        );
                      }).toList(),
                    );
                  }
                  return Text(r.right, style: textStyle, softWrap: true);
                }(),
              ),
            ),
          ),
        ]),
      );
    }

    return TableRow(children: [leftCell, rightCell]);
  }

  Future<void> _showUserDropdown(int index, bool editingLeft, BuildContext context, List<UserEntity> usersList, String currentValue) async {
    final currentUids = currentValue.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toSet();
    final selected = <String>{}..addAll(currentUids);

    final items = <PopupMenuEntry<int>>[];
    // use StatefulBuilder inside a custom menu to manage selection
    items.add(PopupMenuItem<int>(enabled: false, child: SizedBox(height: 300, width: 300, child: StatefulBuilder(builder: (ctx, setState) {
      return ListView.separated(
        shrinkWrap: true,
        itemCount: usersList.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final u = usersList[i];
          final isSel = selected.contains(u.uid);
          return CheckboxListTile(
            value: isSel,
            onChanged: (v) {
              setState(() {
                if (v == true) selected.add(u.uid); else selected.remove(u.uid);
              });
              // persist selection immediately
              _saveEdit(index, editingLeft, selected.join(','));
            },
            title: Text('${u.firstName} ${u.lastName}'),
            controlAffinity: ListTileControlAffinity.leading,
          );
        },
      );
    }))));

    // showMenu requires a position; use a simple center position
    await showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 100, 100),
      items: items,
    );
  }

  void _onCellTap(int index, bool left, String currentValue) {
    setState(() {
  editingRowIndex = index;
  editingLeft = left;
  // populate controller once when beginning to edit so caret/selection is stable
  _controller.text = currentValue;
    });
  }

  void _saveEdit(int index, bool left, String newValue) {
    // Find corresponding item and update it in-place
    int counter = 0;
    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      if (item is Assignment) {
        if (counter == index) {
          final updated = Assignment(left: left ? newValue : item.left, right: left ? item.right : newValue, extras: item.extras);
          setState(() {
            widget.items[i] = updated;
            editingRowIndex = null;
          });
          return;
        }
        counter++;
      } else if (item is Subsection) {
        for (int j = 0; j < item.rows.length; j++) {
          if (counter == index) {
            final old = item.rows[j];
            final updated = Assignment(left: left ? newValue : old.left, right: left ? old.right : newValue, extras: old.extras);
            final newRows = List<Assignment>.from(item.rows);
            newRows[j] = updated;
            final newSub = Subsection(title: item.title, rows: newRows);
            setState(() {
              widget.items[i] = newSub;
              editingRowIndex = null;
            });
            return;
          }
          counter++;
        }
      }
    }
  }
}
