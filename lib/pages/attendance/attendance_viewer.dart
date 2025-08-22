import 'package:faunty/components/custom_app_bar.dart';
import 'package:faunty/state_management/user_provider.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state_management/attendance_provider.dart';
import 'package:faunty/tools/translation_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'attendance_items_page.dart';
import 'package:faunty/state_management/user_list_provider.dart';
import 'package:faunty/models/user_entity.dart';
import '../../firestore/attendance_firestore_service.dart';
import '../../components/role_gate.dart';
import '../../models/user_roles.dart';

class AttendanceViewer extends ConsumerStatefulWidget {
  const AttendanceViewer({
    super.key,
  });

  @override
  ConsumerState<AttendanceViewer> createState() => _AttendanceViewerState();
}

class _AttendanceViewerState extends ConsumerState<AttendanceViewer> {
  late final ScrollController _timeScrollCtrl;
  late final ScrollController _namesScrollCtrl;
  late final ScrollController _gridScrollCtrl;
  bool _isSyncingV = false;
  late DateTime _startDay;
  late DateTime _today;
  late String _todayKey;
  String _visibleMonth = '';
  String _selectedItem = '';
  int _numDays = 30; // initial window size
  Map<String, dynamic> _attendanceCache = {};
  bool _isExtending = false;
  static const int _pageDays = 30;
  static const double _colWidthConst = 36.0;
  final Map<String, bool> _expanded = {};

  @override
  void initState() {
    super.initState();
    _timeScrollCtrl = ScrollController();
    _namesScrollCtrl = ScrollController();
    _gridScrollCtrl = ScrollController();
    final now = DateTime.now();
  _today = DateTime(now.year, now.month, now.day);
  _todayKey = _fmt(_today);
  // Start the view at today so it's the first visible column by default
  _startDay = _today;
  _visibleMonth = _monthNameFromDate(_startDay);
    _timeScrollCtrl.addListener(_onHorizontalScroll);
    // Sync vertical scroll between names list and grid list
    _namesScrollCtrl.addListener(() {
      if (_isSyncingV) return;
      _isSyncingV = true;
      if (_gridScrollCtrl.hasClients) {
        _gridScrollCtrl.jumpTo(
          _namesScrollCtrl.position.pixels.clamp(
            0.0,
            _gridScrollCtrl.position.maxScrollExtent,
          ),
        );
      }
      _isSyncingV = false;
    });
    _gridScrollCtrl.addListener(() {
      if (_isSyncingV) return;
      _isSyncingV = true;
      if (_namesScrollCtrl.hasClients) {
        _namesScrollCtrl.jumpTo(
          _gridScrollCtrl.position.pixels.clamp(
            0.0,
            _namesScrollCtrl.position.maxScrollExtent,
          ),
        );
      }
      _isSyncingV = false;
    });
  // load saved default later in build when user is known
  }

  @override
  void dispose() {
    _timeScrollCtrl.removeListener(_onHorizontalScroll);
    _timeScrollCtrl.dispose();
    _namesScrollCtrl.dispose();
    _gridScrollCtrl.dispose();
    super.dispose();
  }

  void _onHorizontalScroll() {
    if (!_timeScrollCtrl.hasClients || _isExtending) return;
    final pos = _timeScrollCtrl.position;
    const double threshold = _colWidthConst * 8; // about 8 days from edge
    // Extend to the right when near end
    if (pos.maxScrollExtent - pos.pixels < threshold) {
      setState(() {
        _isExtending = true;
        _numDays += _pageDays;
      });
      _isExtending = false;
      _updateVisibleMonth();
      return;
    }
    // Extend to the left when near start
    if (pos.pixels < threshold) {
      setState(() {
        _isExtending = true;
        _startDay = _startDay.subtract(const Duration(days: _pageDays));
        _numDays += _pageDays;
      });
      // Keep visual position after prepending
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_timeScrollCtrl.hasClients) {
          _timeScrollCtrl.jumpTo(_timeScrollCtrl.offset + _pageDays * _colWidthConst);
        }
        _isExtending = false;
        _updateVisibleMonth();
      });
      return;
    }
    _updateVisibleMonth();
  }

  void _updateVisibleMonth() {
    if (!_timeScrollCtrl.hasClients) return;
    final offset = _timeScrollCtrl.offset;
    final firstIndex = (offset / _colWidthConst).floor().clamp(0, _numDays - 1);
    final firstDate = _startDay.add(Duration(days: firstIndex));
    final next = _monthNameFromDate(firstDate);
    if (next != _visibleMonth) {
      setState(() => _visibleMonth = next);
    }
  }

  Future<void> _scrollToToday() async {
    // Ensure today is within the loaded window
    if (_today.isBefore(_startDay)) {
      final diff = _startDay.difference(_today).inDays;
      setState(() {
        _startDay = _today.subtract(Duration(days: 5));
        _numDays = (_numDays + diff + 10).clamp(_numDays, 3650); // safety cap ~10y
      });
    } else if (_today.isAfter(_startDay.add(Duration(days: _numDays - 1)))) {
      final diff = _today.difference(_startDay.add(Duration(days: _numDays - 1))).inDays;
      setState(() {
        _numDays = _numDays + diff + 10;
      });
    }
    // After ensuring presence, jump to the correct offset
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_timeScrollCtrl.hasClients) return;
      final targetIndex = _today.difference(_startDay).inDays;
      final targetOffset = (targetIndex * _colWidthConst).toDouble();
      _timeScrollCtrl.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
  _updateVisibleMonth();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final usersAsync = ref.watch(usersByCurrentPlaceProvider);
    final currentUser = ref.watch(userProvider);
    final user = currentUser.asData?.value;
    final List<UserEntity> users = usersAsync.asData?.value ?? const <UserEntity>[];
    final attendanceAsync = ref.watch(attendanceProvider(user!.placeId));
    if (!attendanceAsync.hasValue) {
      return const Center(child: CircularProgressIndicator());
    }
    // Local mutable cache to allow optimistic updates so expanded cells reflect changes immediately
    if (_attendanceCache.isEmpty) {
      _attendanceCache = Map<String, dynamic>.from(attendanceAsync.value ?? {});
    }
    final Map<String, dynamic> attendance = _attendanceCache;
    final List<String> fallbackRoster = users.map((u) => u.uid).toList();
    final List<String> roster = attendance['roster'] is List
        ? (attendance['roster'] as List).cast<String>()
        : fallbackRoster;
    final Map<String, UserEntity> idToUser = {for (final u in users) u.uid: u};
    final List<String> columns = List.generate(
      _numDays,
      (i) => _fmt(_startDay.add(Duration(days: i))),
    );

  // listen to attendance meta (items + default)
  final metaAsync = ref.watch(attendanceMetaProvider(user.placeId));
  final meta = metaAsync.asData?.value ?? <String, dynamic>{};
  final List<Map<String, dynamic>> itemsMeta = (meta['items'] as List?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? <Map<String, dynamic>>[];
  final List<String> itemIds = itemsMeta.map((e) => e['id'] as String? ?? '').where((s) => s.isNotEmpty).toList();
    // load local default from SharedPreferences if not loaded (store itemId)
    if (_selectedItem.isEmpty) {
      SharedPreferences.getInstance().then((sp) {
        final key = 'attendance_default_${user.placeId}';
        final saved = sp.getString(key);
        String resolved = '';
        if (saved != null && saved.isNotEmpty) {
          // if saved is an id that exists, use it; otherwise try match by name
          if (itemIds.contains(saved)) {
            resolved = saved;
          } else {
            final match = itemsMeta.cast<Map<String, dynamic>?>().firstWhere(
              (e) => e != null && (e['name'] as String? ?? '') == saved,
              orElse: () => null,
            );
            if (match != null) resolved = match['id'] as String? ?? '';
          }
        }
        if (resolved.isEmpty && itemIds.isNotEmpty) resolved = itemIds.first;
        if (!mounted) return; // avoid calling setState after dispose
        setState(() {
          _selectedItem = resolved; // may be empty if no items
        });
        if (resolved.isNotEmpty) sp.setString(key, resolved);
      });
    }

    String displayNameFor(String userId) {
      final u = idToUser[userId];
      if (u == null) return userId;
      final full = '${u.firstName} ${u.lastName}'.trim();
      return full.isEmpty ? userId : full;
    }

    final double nameColWidth = 170;
    final double rowHeight = 28;
    final double baseDayColWidth = _colWidthConst;
    final double headingHeight = 72;
    final double availableWidth =
        MediaQuery.of(context).size.width - nameColWidth - 24;
    final double dayColWidth = baseDayColWidth;
    final double totalWidth = (columns.length * dayColWidth) > availableWidth
        ? columns.length * dayColWidth
        : availableWidth;

  final monthLabel = _visibleMonth.isEmpty ? _monthNameFromDate(_startDay) : _visibleMonth;

    // Flat full-width layout (no card)
    return Scaffold(
      appBar: CustomAppBar(
        title: translation(context: context, 'Attendance'),
        actions: [
          itemsMeta.isNotEmpty ? RoleGate(
            minRole: UserRole.baskan,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                children: [
                    DropdownButton<String>(
                      value: itemIds.contains(_selectedItem) ? _selectedItem : null,
                      alignment: Alignment.center,
                      underline: const SizedBox.shrink(),
                      onChanged: (val) async {
                        if (val == null) return;
                        const manageKey = '__manage__';
                        if (val == manageKey) {
                          // open management page and then restore selection
                          await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => AttendanceItemsPage(placeId: user.placeId)));
                            if (!mounted) return;
                            setState(() {});
                          return;
                        }
                        setState(() => _selectedItem = val);
                        final sp = await SharedPreferences.getInstance();
                        await sp.setString('attendance_default_${user.placeId}', val);
                        // remove default in firestore meta if present
                        final metaMap = await AttendanceFirestoreService(user.placeId).getAttendanceMeta();
                        if (metaMap.containsKey('default')) {
                          metaMap.remove('default');
                          await AttendanceFirestoreService(user.placeId).setAttendanceMeta(metaMap);
                        }
                      },
                      items: [
                        ...itemsMeta.map((it) => DropdownMenuItem(
                              value: it['id'] as String? ?? it['name'],
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                child: Text(it['name'] as String? ?? ''),
                              ),
                            )),
                        const DropdownMenuItem(
                          value: '__manage__',
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                            child: Text('Manage'),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ) : const SizedBox.shrink(),
        ],
      ),
      body: itemsMeta.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: 64,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      translation(
                        context: context,
                        'No tracking items have been configured yet.',
                      ),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      translation(
                        context: context,
                        'Ask a manager to add tracking items or add them yourself.',
                      ),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 12),
                    RoleGate(
                      minRole: UserRole.baskan,
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) =>
                                  AttendanceItemsPage(placeId: user.placeId),
                            ),
                          );
                              if (!mounted) return;
                              setState(() {});
                        },
                        child: Text(
                          translation(
                            context: context,
                            'Manage tracking items',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
        child: Row(
          children: [
            // ...existing code for left and right columns...
            SizedBox(
              width: nameColWidth,
              child: Column(
                children: [
                  Container(
                    height: headingHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.25),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            monthLabel,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _scrollToToday,
                          icon: const Icon(Icons.today),
                          color: theme.colorScheme.primary,
                          tooltip: translation(context: context, 'Today'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.builder(
                      controller: _namesScrollCtrl,
                      itemCount: roster.isEmpty ? 1 : roster.length,
                      itemBuilder: (context, idx) {
                        if (roster.isEmpty) {
                          return Container(
                            height: rowHeight,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: theme.dividerColor.withOpacity(0.2),
                                ),
                              ),
                            ),
                            child: Text(
                              'No users in roster',
                              style: theme.textTheme.bodyMedium,
                            ),
                          );
                        }
                        final userId = roster[idx];
                        final expanded = _expanded[userId] ?? false;
                        final itemCount = itemsMeta.isEmpty ? 1 : itemsMeta.length;
                        // If collapsed show only the name row; when expanded reserve space for all item rows so grid and names align.
                        final blockHeight = expanded ? rowHeight * (1 + itemCount) : rowHeight;
                        return InkWell(
                          onTap: () => setState(() => _expanded[userId] = !(expanded)),
                          child: Container(
                            height: blockHeight,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: theme.dividerColor.withOpacity(0.2),
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: SizedBox(
                                    height: rowHeight,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(displayNameFor(userId), overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium),
                                        ),
                                        Icon(expanded ? Icons.expand_less : Icons.expand_more, size: 18),
                                      ],
                                    ),
                                  ),
                                ),
                                        if (expanded)
                                          for (var i = 0; i < itemCount; i++)
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: SizedBox(
                                                height: rowHeight,
                                                child: Container(
                                                  alignment: Alignment.centerLeft,
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Text(
                                                    i < itemsMeta.length ? (itemsMeta[i]['name'] as String? ?? '') : '',
                                                    style: theme.textTheme.bodySmall,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    softWrap: false,
                                                  ),
                                                ),
                                              ),
                                            ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Ensure heights are non-negative to avoid creating SizedBox with
                  // negative height when the available area is very small.
                  final gridHeight = math.max(0.0, constraints.maxHeight - 1); // after header divider inside scrollable
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _timeScrollCtrl,
                    child: SizedBox(
                      width: totalWidth,
                      child: Column(
                        children: [
                          Container(
                            height: headingHeight,
                            color: theme.colorScheme.surfaceVariant.withOpacity(0.25),
                            child: Row(
                              children: [
                                for (final d in columns)
                                  Container(
                                    width: dayColWidth,
                                    decoration: BoxDecoration(
                                      color: d == _todayKey
                                          ? theme.colorScheme.primary.withOpacity(0.08)
                                          : null,
                                      border: Border(
                                        right: BorderSide(
                                          color: theme.dividerColor.withOpacity(0.2),
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: RotatedBox(
                                        quarterTurns: 3,
                                        child: Text(
                                          _verticalLabel(d),
                                          style: theme.textTheme.labelSmall,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          SizedBox(
                            height: math.max(0.0, gridHeight - headingHeight),
                            child: ListView.builder(
                                controller: _gridScrollCtrl,
                                itemCount: roster.isEmpty ? 1 : roster.length,
                                itemBuilder: (context, rIdx) {
                                  if (roster.isEmpty) {
                                    return Container(
                                      height: rowHeight,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: theme.dividerColor.withOpacity(0.2),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          for (final _ in columns)
                                            Container(
                                              width: dayColWidth,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(
                                                    color: theme.dividerColor.withOpacity(0.2),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  }
                                  final userId = roster[rIdx];
                                  final expanded = _expanded[userId] ?? false;
                                  // Build rows: first row is the selected/default item; if expanded, show all items extra.
                  final renderedItems = <Map<String, dynamic>>[];
                  // default first (find by id)
                  final defaultIdOrName = _selectedItem.isNotEmpty ? _selectedItem : (itemsMeta.isNotEmpty ? (itemsMeta.first['id'] as String) : 'presence');
                  final defaultItem = itemsMeta.firstWhere((e) => (e['id'] == defaultIdOrName) || (e['name'] == defaultIdOrName), orElse: () => itemsMeta.isNotEmpty ? itemsMeta.first : {'id': 'presence', 'name': 'Presence'});
                  renderedItems.add(defaultItem);
                  // then all items as extras when expanded
                  if (expanded) renderedItems.addAll(itemsMeta);
                                  return Column(
                                    children: [
                    for (final it in renderedItems)
                                        Container(
                                          height: rowHeight,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: theme.dividerColor.withOpacity(0.2),
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                                      for (final d in columns)
                                                Container(
                                                  width: dayColWidth,
                                                  decoration: BoxDecoration(
                                                    color: d == _todayKey
                                                        ? theme.colorScheme.primary.withOpacity(0.06)
                                                        : null,
                                                    border: Border(
                                                      right: BorderSide(
                                                        color: theme.dividerColor.withOpacity(0.2),
                                                      ),
                                                    ),
                                                  ),
                                                  child: Center(
                                                        child: Transform.scale(
                                                      scale: 0.9,
                                                        child: _InlineCell(
                                                        placeId: user.placeId,
                                                        dateKey: d,
                                                        userId: userId,
                                                        attendance: attendance,
                                                        itemName: it['id'] as String,
                                                        onToggleLocal: (dateK, itemId, uid, isChecked) {
                                                          // mutate local cache and rebuild so other cells update immediately
                                                          setState(() {
                                                            final next = Map<String, dynamic>.from(_attendanceCache);
                                                            final dateRec = Map<String, dynamic>.from(next[dateK] as Map? ?? {});
                                                            final rec = Map<String, dynamic>.from(dateRec[itemId] as Map? ?? {});
                                                            final present = List<String>.from((rec['present'] as List?)?.cast<String>() ?? <String>[]);
                                                            final absent = List<String>.from((rec['absent'] as List?)?.cast<String>() ?? <String>[]);
                                                            if (isChecked) {
                                                              if (!present.contains(uid)) present.add(uid);
                                                              absent.remove(uid);
                                                            } else {
                                                              present.remove(uid);
                                                              if (!absent.contains(uid)) absent.add(uid);
                                                            }
                                                            rec['present'] = present;
                                                            rec['absent'] = absent;
                                                            dateRec[itemId] = rec;
                                                            next[dateK] = dateRec;
                                                            _attendanceCache = next;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime d) {
    String two(int v) => v < 10 ? '0$v' : '$v';
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  String _verticalLabel(String key) {
    final dt = _parseKey(key);
    final weekday = _weekdayAbbr(dt.weekday);
    return '${two(dt.day)} $weekday';
  }

  // _monthNameFromKey removed; replaced with _monthNameFromDate

  String _monthNameFromDate(DateTime dt) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[dt.month - 1];
  }

  DateTime _parseKey(String key) {
    try {
      final parts = key.split('-');
      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    } catch (_) {
      return DateTime.now();
    }
  }

  String two(int v) => v < 10 ? '0$v' : '$v';
  String _weekdayAbbr(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }
}

class _InlineCell extends StatefulWidget {
  final String placeId;
  final String dateKey;
  final String userId;
  final Map<String, dynamic> attendance;
  final String itemName; // here we store itemId
  final void Function(String dateKey, String itemId, String userId, bool checked)? onToggleLocal;
  const _InlineCell({
    required this.placeId,
    required this.dateKey,
    required this.userId,
    required this.attendance,
  required this.itemName,
  this.onToggleLocal,
  });

  @override
  State<_InlineCell> createState() => _InlineCellState();
}

class _InlineCellState extends State<_InlineCell> {
  late bool checked;

  @override
  void initState() {
    super.initState();
    final dateRec = Map<String, dynamic>.from(
      widget.attendance[widget.dateKey] as Map? ?? const {},
    );
    final rec = Map<String, dynamic>.from(
      dateRec[widget.itemName] as Map? ?? const {},
    );
    final present = (rec['present'] as List?)?.cast<String>() ?? const <String>[];
    checked = present.contains(widget.userId);
  }

  @override
  void didUpdateWidget(covariant _InlineCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recompute checked when attendance or itemName changes (local cache updated)
    final dateRec = Map<String, dynamic>.from(
      widget.attendance[widget.dateKey] as Map? ?? const {},
    );
    final rec = Map<String, dynamic>.from(
      dateRec[widget.itemName] as Map? ?? const {},
    );
    final present = (rec['present'] as List?)?.cast<String>() ?? const <String>[];
    final newChecked = present.contains(widget.userId);
    if (newChecked != checked) setState(() => checked = newChecked);
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: checked,
      onChanged: (val) async {
        setState(() => checked = val ?? false);
        // Update local UI synchronously via callback
        widget.onToggleLocal?.call(widget.dateKey, widget.itemName, widget.userId, checked);
        // Persist using atomic helper (now using itemId)
        await AttendanceFirestoreService(widget.placeId).toggleAttendanceItem(
          dateId: widget.dateKey,
          itemId: widget.itemName,
          userId: widget.userId,
          checked: checked,
        );
      },
    );
  }
}
