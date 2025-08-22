import 'package:faunty/tools/translation_helper.dart';
import 'package:flutter/material.dart';

// Kürzt lange Labels so, dass sie in die verfügbare Breite passen.
// Verwendet TextPainter, um die gerenderte Breite zu messen und
// per binärer Suche die längste passende Substring+Ellipsen zu finden.
String _shortToFit(BuildContext context, String text, double maxWidth, {TextStyle? style}) {
  final TextStyle txtStyle = style ?? DefaultTextStyle.of(context).style;
  final tp = TextPainter(textDirection: TextDirection.ltr);

  // Quick check: full text fits?
  tp.text = TextSpan(text: text, style: txtStyle);
  tp.layout();
  if (tp.width <= maxWidth) return text;

  // Binary search the longest substring that fits when adding an ellipsis.
  const ell = '…';
  int low = 0;
  int high = text.length;
  while (low < high) {
    final mid = (low + high + 1) >> 1;
    final candidate = text.substring(0, mid) + ell;
    tp.text = TextSpan(text: candidate, style: txtStyle);
    tp.layout();
    if (tp.width <= maxWidth) {
      low = mid;
    } else {
      high = mid - 1;
    }
  }

  if (low <= 0) return ell; // fallback when nothing fits
  return text.substring(0, low) + ell;
}

class NavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  const NavBar({super.key, required this.selectedIndex, required this.onDestinationSelected});


  @override
  Widget build(BuildContext context) {
    // Wrap the NavigationBar in a LayoutBuilder so we can compute the
    // available width per item and truncate labels precisely to that width.
    return LayoutBuilder(builder: (context, constraints) {
      // Define the translations first to know the count.
      final rawLabels = [
        translation(context: context, 'Home'),
        translation(context: context, 'Communication'),
        translation(context: context, 'Tracking'),
        // translation(context: context, 'Program'),
        translation(context: context, 'Lists'),
        translation(context: context, 'More'),
      ];

      // Number of visible destinations (skip commented ones).
      final visibleCount = rawLabels.length;
      // Conservative available width per item. Multiply by 0.9 to leave padding.
      final itemWidth = (constraints.maxWidth / visibleCount) * 0.9;

      final textStyle = Theme.of(context).textTheme.labelSmall ?? DefaultTextStyle.of(context).style;

      final destinations = [
        NavigationDestination(
          icon: Icon(Icons.home_filled),
          label: _shortToFit(context, rawLabels[0], itemWidth, style: textStyle),
        ),
        NavigationDestination(
          icon: Icon(Icons.group_outlined),
          label: _shortToFit(context, rawLabels[1], itemWidth, style: textStyle),
        ),
        NavigationDestination(
          icon: Icon(Icons.track_changes),
          label: _shortToFit(context, rawLabels[2], itemWidth, style: textStyle),
        ),
        NavigationDestination(
          icon: Icon(Icons.list_alt_outlined),
          label: _shortToFit(context, rawLabels[3], itemWidth, style: textStyle),
        ),
        NavigationDestination(
          icon: Icon(Icons.more_horiz_outlined),
          label: _shortToFit(context, rawLabels[4], itemWidth, style: textStyle),
        ),
      ];

      return NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: selectedIndex,
        destinations: destinations,
        onDestinationSelected: onDestinationSelected,
      );
    });
  }
}
