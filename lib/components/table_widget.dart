import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final isEditing = editingRowIndex == index;

    Widget leftCell;
    Widget rightCell;

  if (isEditing && editingLeft) {
      _controller.text = r.left;
      leftCell = TextField(
        controller: _controller,
        autofocus: true,
        onSubmitted: (val) => _saveEdit(index, true, val),
      );
    } else {
      leftCell = GestureDetector(
        onTap: () => _onCellTap(index, true, r.left),
        child: Padding(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12), child: Text(r.left, style: textStyle)),
      );
    }

  if (isEditing && !editingLeft) {
      _controller.text = r.right;
      rightCell = TextField(
        controller: _controller,
        autofocus: true,
        onSubmitted: (val) => _saveEdit(index, false, val),
      );
    } else {
      rightCell = GestureDetector(
        onTap: () => _onCellTap(index, false, r.right),
        child: Padding(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12), child: Text(r.right, style: textStyle)),
      );
    }

  return TableRow(children: [leftCell, rightCell]);
  }

  void _onCellTap(int index, bool left, String currentValue) {
    setState(() {
      editingRowIndex = index;
      editingLeft = left;
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
