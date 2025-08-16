import 'package:faunty/pages/catering/catering.dart';
import 'package:faunty/pages/cleaning/cleaning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../program/program_page.dart';
import '../more/kantin_page.dart';
import '../attendance/attendance_viewer.dart';

class ListsPage extends ConsumerStatefulWidget {
  const ListsPage({super.key});

  @override
  ConsumerState<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends ConsumerState<ListsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<_ListTabMeta> _tabs = [
    _ListTabMeta('Cleaning', CleaningPage(), Icons.cleaning_services_outlined),
    _ListTabMeta('Catering', CateringPage(), Icons.restaurant_outlined),
    _ListTabMeta('Program', ProgramPage(), Icons.event_outlined),
    _ListTabMeta('Kantin', KantinPage(), Icons.local_cafe_outlined),
    _ListTabMeta('Attendance', AttendanceViewer(), Icons.checklist_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Optionally, you can add a minimal AppBar for ListsPage itself, or none at all
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              for (int i = 0; i < _tabs.length; i++)
                Tab(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_tabs[i].icon, size: 18),
                      // if (_tabController.index == i)
                      //   Text(
                      //     _tabs[i].title,
                      //     style: TextStyle(fontSize: 12)
                      //   ),
                    ],
                  ),
                )
            ],
            isScrollable: true,
            labelPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            indicatorSize: TabBarIndicatorSize.label,
            // Center the tabs
            tabAlignment: TabAlignment.center,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [for (final tab in _tabs) tab.page],
            ),
          ),
        ],
      ),
    );
  }
}

class _ListTabMeta {
  final String title;
  final Widget page;
  final IconData icon;
  const _ListTabMeta(this.title, this.page, this.icon);
}
