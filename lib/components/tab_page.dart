import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabMeta {
  final String title;
  final Widget page;
  final IconData icon;
  const TabMeta(this.title, this.page, this.icon);
}

class TabPage extends ConsumerStatefulWidget {
  final List<TabMeta> tabs;
  final StateProvider<int?> tabIndexProvider;
  final String prefsKey;
  const TabPage({
    super.key,
    required this.tabs,
    required this.tabIndexProvider,
    required this.prefsKey,
  });

  @override
  ConsumerState<TabPage> createState() => _TabPageState();
}

class _TabPageState extends ConsumerState<TabPage> with TickerProviderStateMixin {
  TabController? _tabController;
  bool _isTabControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    _initTabController();
  }

  Future<void> _initTabController() async {
    int initialIndex = ref.read(widget.tabIndexProvider) ?? 0;
    if (ref.read(widget.tabIndexProvider) == null) {
      final prefs = await SharedPreferences.getInstance();
      int? storedIndex = prefs.getInt(widget.prefsKey);
      if (storedIndex != null && storedIndex >= 0 && storedIndex < widget.tabs.length) {
        initialIndex = storedIndex;
      } else {
        initialIndex = 0;
      }
      ref.read(widget.tabIndexProvider.notifier).state = initialIndex;
    }
    _tabController = TabController(length: widget.tabs.length, vsync: this, initialIndex: initialIndex);
    _tabController!.addListener(_handleTabChange);
    _isTabControllerInitialized = true;
    if (mounted) setState(() {});
  }

  void _handleTabChange() async {
    if (_tabController == null || _tabController!.indexIsChanging) return;
    final index = _tabController!.index;
    ref.read(widget.tabIndexProvider.notifier).state = index;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(widget.prefsKey, index);
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
    if (!_isTabControllerInitialized || _tabController == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              for (int i = 0; i < widget.tabs.length; i++)
                Tab(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(widget.tabs[i].icon, size: 18),
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
              children: [for (final tab in widget.tabs) tab.page],
            ),
          ),
        ],
      ),
    );
  }
}
