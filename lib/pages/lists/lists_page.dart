import 'package:faunty/pages/catering/catering.dart';
import 'package:faunty/pages/cleaning/cleaning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../program/program_page.dart';
import '../more/kantin_page.dart';
import '../attendance/attendance_viewer.dart';

final lastTabIndexProvider = StateProvider<int?>((ref) => null);

class ListsPage extends ConsumerStatefulWidget {
  const ListsPage({super.key});

  @override
  ConsumerState<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends ConsumerState<ListsPage> with TickerProviderStateMixin {
  TabController? _tabController;
  final List<_ListTabMeta> _tabs = [
    _ListTabMeta('Cleaning', CleaningPage(), Icons.cleaning_services_outlined),
    _ListTabMeta('Catering', CateringPage(), Icons.restaurant_outlined),
    _ListTabMeta('Program', ProgramPage(), Icons.event_outlined),
    _ListTabMeta('Kantin', KantinPage(), Icons.local_cafe_outlined),
    _ListTabMeta('Attendance', AttendanceViewer(), Icons.checklist_outlined),
  ];

  // Key for SharedPreferences
  static const String _prefsKey = 'lists_last_tab_index';
  bool _isTabControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    // Get initial tab index from provider or SharedPreferences
    _initTabController();
  }

  Future<void> _initTabController() async {
    int initialIndex = ref.read(lastTabIndexProvider) ?? 0;
    if (ref.read(lastTabIndexProvider) == null) {
      final prefs = await SharedPreferences.getInstance();
      initialIndex = prefs.getInt(_prefsKey) ?? 0;
      ref.read(lastTabIndexProvider.notifier).state = initialIndex;
    }
    _tabController = TabController(length: _tabs.length, vsync: this, initialIndex: initialIndex);
    _tabController!.addListener(_handleTabChange);
    _isTabControllerInitialized = true;
    if (mounted) setState(() {});
  }

  void _handleTabChange() async {
    if (_tabController == null || _tabController!.indexIsChanging) return;
    final index = _tabController!.index;
    ref.read(lastTabIndexProvider.notifier).state = index;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, index);
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    if (_tabController != null) {
      _tabController!.removeListener(_handleTabChange);
      _tabController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If tabController is not initialized yet, show a loader
    if (!_isTabControllerInitialized || _tabController == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
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
