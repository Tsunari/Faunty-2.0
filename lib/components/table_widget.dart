import 'package:flutter/material.dart';

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

class TableWidget extends StatelessWidget {
  final List<Subsection>? subsections;
  final List<Assignment>? flatRows;
  final bool showColumnHeaders;
  final String? leftHeader;
  final String? rightHeader;

  const TableWidget({
    super.key,
    this.subsections,
    this.flatRows,
    this.showColumnHeaders = true,
    this.leftHeader,
    this.rightHeader,
  }) : assert(subsections != null || flatRows != null, 'Either subsections or flatRows must be provided');

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall;
    final headerStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);
    final headerHeight = 36.0;

    final theme = Theme.of(context);
    final containerColor = theme.cardColor;
    final primary = theme.colorScheme.primary;

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
          if (showColumnHeaders) ...[
            Table(
              columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1)},
              children: [
                TableRow(children: [
                  Container(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), child: Text(leftHeader ?? 'Left', style: headerStyle)),
                  Container(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), child: Text(rightHeader ?? 'Right', style: headerStyle)),
                ]),
              ],
            ),
            const SizedBox(height: 6),
          ],

          // if flatRows provided render a single table; otherwise render subsections
          if (flatRows != null) ...[
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1)},
              border: TableBorder(
                horizontalInside: BorderSide(color: Colors.grey.shade300),
                verticalInside: BorderSide(color: Colors.grey.shade200),
              ),
              children: flatRows!.map((r) {
                return TableRow(children: [
                  Container(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12), child: Text(r.left, style: textStyle)),
                  Container(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12), child: Text(r.right, style: textStyle)),
                ]);
              }).toList(),
            ),
          ] else ...[
            ...?subsections?.map((sub) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: headerHeight,
                    color: primary.withOpacity(0.12),
                    alignment: Alignment.center,
                    child: Text(sub.title, style: headerStyle?.copyWith(color: primary)),
                  ),
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1)},
                    border: TableBorder(
                      horizontalInside: BorderSide(color: Colors.grey.shade300),
                      verticalInside: BorderSide(color: Colors.grey.shade200),
                    ),
                    children: sub.rows.map((r) {
                      return TableRow(children: [
                        Container(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12), child: Text(r.left, style: textStyle)),
                        Container(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12), child: Text(r.right, style: textStyle)),
                      ]);
                    }).toList(),
                  ),
                ],
              );
            }).toList(),
          ],
        ],
      ),
    );
  }
}
