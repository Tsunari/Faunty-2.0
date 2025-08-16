import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../more/kantin_page.dart';
import '../attendance/attendance_viewer.dart';
import '../../components/tab_page.dart';

final trackingTabIndexProvider = StateProvider<int?>((ref) => null);

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TabPage(
      tabs: const [
        TabMeta('Statistics', DummyPage('Statistics'), Icons.bar_chart_outlined),
        TabMeta('Attendance', AttendanceViewer(), Icons.checklist_outlined),
        TabMeta('Custom List Tracking', DummyPage('Custom List Tracking'), Icons.list_alt_outlined),
        TabMeta('Kantin', KantinPage(), Icons.local_cafe_outlined)
      ],
      tabIndexProvider: trackingTabIndexProvider,
      prefsKey: 'tracking_last_tab_index',
    );
  }
}

class DummyPage extends StatelessWidget {
  final String label;
  const DummyPage(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(label, style: const TextStyle(fontSize: 24)),
    );
  }
}
