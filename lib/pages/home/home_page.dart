import 'package:faunty/components/role_gate.dart';
import 'package:faunty/helper/logging.dart';
import 'package:faunty/models/user_roles.dart';
import 'package:faunty/pages/more/kantin_page.dart';
import 'package:faunty/tools/translation_helper.dart';
import 'package:flutter/foundation.dart';
import '../../tools/message_prefs.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../components/custom_app_bar.dart';
import '../../components/custom_snackbar.dart';
import '../../notifications/notification_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../state_management/user_list_provider.dart';
import '../../state_management/user_provider.dart';
import '../../state_management/program_provider.dart';
import '../../state_management/catering_provider.dart';
import '../../state_management/cleaning_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _navigated = false;
  bool _notificationInitialized = false;
  final _scrollController = ScrollController();
  late Timer _timer;
  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  static const List<String> weekDaysFull = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];
  static const List<String> weekDaysShort = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];
  static const List<String> mealNames = [
    'Breakfast', 'Lunch', 'Dinner'
  ];

  List<Map<String, String>> getNextAppointments(Map<String, List<Map<String, String>>>? weekProgram) {
    if (weekProgram == null) return [];
    final now = DateTime.now();
    final todayIdx = now.weekday - 1; // Monday=0
    final nowTime = TimeOfDay(hour: now.hour, minute: now.minute);
    List<Map<String, String>> upcoming = [];
    for (int i = 0; i < 7; i++) {
      final dayIdx = (todayIdx + i) % 7;
      final dayFull = weekDaysFull[dayIdx];
      final dayShort = weekDaysShort[dayIdx];
      final events = weekProgram[dayFull] ?? [];
      for (final event in events) {
        if (i == 0) {
          final fromParts = event['from']!.split(':');
          final toParts = event['to']!.split(':');
          final from = TimeOfDay(hour: int.parse(fromParts[0]), minute: int.parse(fromParts[1]));
          final to = TimeOfDay(hour: int.parse(toParts[0]), minute: int.parse(toParts[1]));
          // Only show if event is current or in the future
          bool afterFrom = nowTime.hour > from.hour || (nowTime.hour == from.hour && nowTime.minute >= from.minute);
          bool beforeTo = nowTime.hour < to.hour || (nowTime.hour == to.hour && nowTime.minute <= to.minute);
          if (!(afterFrom && beforeTo) && (from.hour < nowTime.hour || (from.hour == nowTime.hour && from.minute <= nowTime.minute))) {
            continue;
          }
        }
        upcoming.add({
          'day': dayShort,
          'from': event['from']! ,
          'to': event['to']! ,
          'event': event['event']! ,
        });
        if (upcoming.length >= 10) return upcoming;
      }
    }
    return upcoming;
  }

  @override
  void initState() {
    super.initState();
    // Sync timer to next full minute
    final now = DateTime.now();
    final secondsToNextMinute = 60 - now.second;
    _timer = Timer(Duration(seconds: secondsToNextMinute), () {
      if (mounted) setState(() {});
      // After first tick, switch to periodic 1-minute timer
      _timer = Timer.periodic(const Duration(minutes: 1), (_) {
        if (mounted) setState(() {});
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userAsync = ref.read(userProvider);
      final user = userAsync.asData?.value;
      if (_navigated) return;
      if (user == null && mounted && ModalRoute.of(context)?.settings.name != '/splash') {
        printError('UserEntity not loaded - HomePage build() called without loaded user!');
        printWarning('Navigiere automatisch zur SplashPage, weil kein User geladen ist.');
        _navigated = true;
        Navigator.of(context).pushReplacementNamed('/splash');
        return;
      }

      // Only check and request notification permission from Home.
      // The full NotificationService.init() should run early (e.g., in main()).
      if (!_notificationInitialized && user != null) {
        _notificationInitialized = true;
        try {
          await NotificationService.checkAndRequestPermission(requestIfNot: true);
        } catch (e) {
          if (mounted) {
            if (kDebugMode) print('Notification permission check/request error: $e');
          }
        }
      }
    });
  }

  String _formatTimestamp(Object ts) {
    try {
      if (ts is Timestamp) {
        final dt = ts.toDate().toLocal();
        return DateFormat('yyyy-MM-dd HH:mm').format(dt);
      }
      if (ts is DateTime) {
        return DateFormat('yyyy-MM-dd HH:mm').format(ts.toLocal());
      }
      return ts.toString();
    } catch (_) {
      return ts.toString();
    }
  }

  Widget _platformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'android':
        return const Icon(Icons.android, color: Colors.green);
      case 'ios':
      case 'iphone':
        return const Icon(Icons.phone_iphone, color: Colors.blue);
      case 'web':
        return const Icon(Icons.language, color: Colors.orange);
      default:
        return const Icon(Icons.devices_other);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    return userAsync.when(
      data: (user) {
        printInfo(user != null ? 'UserEntity: uid=${user.uid}, email=${user.email}, role=${user.role}, place=${user.placeId}' : 'UserEntity NOT LOADED');
        if (user == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(translation(context: context, 'Waiting for UserEntity... (HomePage was built without a loaded user)'))
                ],
              ),
            ),
          );
        }

        Future<void> showTokensDialog(BuildContext context) async {
          final firestore = FirebaseFirestore.instance;

          Future<void> showEditMessageDialog(BuildContext parentCtx) async {
            final currentTitle = await getTestNotificationTitle();
            final currentBody = await getTestNotificationBody();
            final titleCtl = TextEditingController(text: currentTitle ?? 'Test notification');
            final bodyCtl = TextEditingController(text: currentBody ?? 'This is a test message.');
            await showDialog<void>(
              context: parentCtx,
              builder: (c) => AlertDialog(
                title: Text(translation(context: context, 'Edit test notification message')),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleCtl,
                      decoration: InputDecoration(labelText: translation(context: context, 'Title')),
                    ),
                    TextField(
                      controller: bodyCtl,
                      decoration: InputDecoration(labelText: translation(context: context, 'Body')),
                    ),
                  ],
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.of(c).pop(), child: Text(translation(context: context, 'Cancel'))),
                  TextButton(onPressed: () async {
                    try {
                      await setTestNotificationTitle(titleCtl.text);
                      await setTestNotificationBody(bodyCtl.text);
                      if (parentCtx.mounted) showCustomSnackBar(parentCtx, translation(context: context, 'Saved'));
                    } catch (e) {
                      if (parentCtx.mounted) showCustomSnackBar(parentCtx, 'Save failed: $e');
                    }
                    Navigator.of(c).pop();
                  }, child: Text(translation(context: context, 'Save'))),
                ],
              ),
            );
            titleCtl.dispose();
            bodyCtl.dispose();
          }

          // Query top-level fcm_tokens and group tokens by uid for display
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(translation(context: context, 'Saved FCM tokens'))),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: translation(context: context, 'Edit test notification message'),
                    onPressed: () async {
                      await showEditMessageDialog(ctx);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: translation(context: context, 'Refresh tokens'),
                    onPressed: () async {
                      try {
                        // Re-fetch current user's token by triggering NotificationService to get token
                        await NotificationService.init(requestPermissions: false);
                        if (context.mounted) showCustomSnackBar(context, translation(context: context, 'Refreshed tokens'));
                      } catch (e) {
                        if (context.mounted) showCustomSnackBar(context, 'Refresh failed: $e');
                      }
                    },
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestore.collection('fcm_tokens').orderBy('lastSeenAt', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
                    if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                    final tokenDocs = snapshot.data?.docs ?? [];
                    if (tokenDocs.isEmpty) return Text(translation(context: context, 'No tokens found'));

                    // Group tokens by uid
                    final Map<String, List<QueryDocumentSnapshot>> byUser = {};
                    for (final d in tokenDocs) {
                      final data = d.data() as Map<String, dynamic>?;
                      final uid = data?['uid'] ?? 'unknown';
                      byUser.putIfAbsent(uid, () => []).add(d);
                    }

                    final entries = byUser.entries.toList();

                    // Use cached provider data first, then batch-fetch only missing uids
                    final allUsersAsync = ref.watch(allUsersProvider);
                    final Map<String, String> providerNames = {};
                    final usersList = allUsersAsync.asData?.value;
                    if (usersList != null) {
                      for (final u in usersList) {
                        final full = '${u.firstName} ${u.lastName}'.trim();
                        providerNames[u.uid] = full.isNotEmpty ? full : u.uid;
                      }
                    }

                    final uids = entries.map((e) => e.key).where((u) => u != 'unknown').toList();
                    final missing = uids.where((u) => !providerNames.containsKey(u)).toList();
                    final Future<List<DocumentSnapshot>> usersFuture = missing.isEmpty
                        ? Future.value([])
                        : Future.wait(missing.map((u) => firestore.collection('user_list').doc(u).get()));

                    return FutureBuilder<List<DocumentSnapshot>>(
                      future: usersFuture,
                      builder: (context, usersSnap) {
                        final Map<String, String> displayNames = {...providerNames};
                        if (usersSnap.hasData) {
                          for (final ds in usersSnap.data!) {
                            if (ds.exists) {
                              final d = ds.data() as Map<String, dynamic>?;
                              final name = (d?['firstName'] ?? '').toString().trim();
                              final last = (d?['lastName'] ?? '').toString().trim();
                              final full = [name, last].where((s) => s.isNotEmpty).join(' ');
                              displayNames[ds.id] = full.isNotEmpty ? full : ds.id;
                            }
                          }
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: entries.length,
                          itemBuilder: (context, idx) {
                            final uid = entries[idx].key;
                            final tokens = entries[idx].value;
                            final resolvedName = displayNames[uid] ?? (uid == 'unknown' ? uid : translation(context: context, 'Loading...'));
                            return ExpansionTile(
                              leading: const Icon(Icons.person_outline),
                              title: Text(resolvedName),
                              subtitle: uid == 'unknown' ? Text(uid, style: const TextStyle(fontSize: 12)) : null,
                              trailing: IconButton(
                                icon: const Icon(Icons.copy_all),
                                tooltip: translation(context: context, 'Copy all tokens for user'),
                                onPressed: () async {
                                  final all = tokens.map((t) => t.id).join('\n');
                                          await Clipboard.setData(ClipboardData(text: all));
                                          if (context.mounted) showCustomSnackBar(context, translation(context: context, 'All tokens copied'));
                                },
                              ),
                              children: tokens.map((t) {
                                final data = t.data() as Map<String, dynamic>;
                                final platform = data['platform'] ?? '?';
                                final lastSeen = data['lastSeenAt'];
                                String subtitle = 'platform: $platform';
                                if (lastSeen != null) subtitle += ' • lastSeen: ${_formatTimestamp(lastSeen)}';
                                return ListTile(
                                  leading: _platformIcon(platform),
                                  title: Text(t.id, overflow: TextOverflow.ellipsis),
                                  subtitle: Text(subtitle),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.copy),
                                        tooltip: translation(context: context, 'Copy token'),
                                        onPressed: () async {
                                          await Clipboard.setData(ClipboardData(text: t.id));
                                          if (context.mounted) showCustomSnackBar(context, translation(context: context, 'Token copied'));
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.send),
                                        tooltip: translation(context: context, 'Send test notification'),
                                        onPressed: () async {
                                          if (kDebugMode) print('Sending test notification to ${t.id}');
                                          try {
                                            if (t.id.trim().isEmpty) throw Exception('Token is empty');
                                            final functions = FirebaseFunctions.instanceFor(region: 'europe-west1');
                                            final callable = functions.httpsCallable('testNotification');
                                            // Use stored title/body if available
                                            final storedTitle = await getTestNotificationTitle();
                                            final storedBody = await getTestNotificationBody();
                                            final platform = (t.data() as Map<String, dynamic>)['platform'] ?? 'device';
                                            final safeTokenPreview = t.id.length > 20 ? '${t.id.substring(0, 20)}...' : t.id;
                                            final title = (storedTitle?.isNotEmpty ?? false) ? storedTitle! : 'Test notification — $platform';
                                            final body = (storedBody?.isNotEmpty ?? false) ? storedBody! : 'Token: $safeTokenPreview';
                                            final result = await callable.call(<String, dynamic>{'token': t.id, 'title': title, 'body': body});
                                            if (context.mounted) showCustomSnackBar(context, '${translation(context: context, 'Test notification sent')}: ${result.data}');
                                          } catch (e) {
                                            if (context.mounted) showCustomSnackBar(context, 'Send failed: $e');
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                                        tooltip: translation(context: context, 'Delete token'),
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (c) => AlertDialog(
                                              title: Text(translation(context: context, 'Delete token?')),
                                              content: Text(translation(context: context, 'Are you sure you want to delete this FCM token?')),
                                              actions: [
                                                TextButton(onPressed: () => Navigator.of(c).pop(false), child: Text(translation(context: context, 'Cancel'))),
                                                TextButton(onPressed: () => Navigator.of(c).pop(true), child: Text(translation(context: context, 'Delete'))),
                                              ],
                                            ),
                                          );
                                          if (confirm == true) {
                                            try {
                                              await FirebaseFirestore.instance.collection('fcm_tokens').doc(t.id).delete();
                                              if (context.mounted) showCustomSnackBar(context, translation(context: context, 'Token deleted'));
                                            } catch (e) {
                                              if (context.mounted) showCustomSnackBar(context, 'Delete failed: $e');
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(translation(context: context, 'Close'))),
              ],
            ),
          );
        }

        final weekProgramAsync = ref.watch(weekProgramProvider);
        final cateringAsync = ref.watch(cateringWeekPlanProvider);
        final cleaningAsync = ref.watch(cleaningDataProvider);
        final width = MediaQuery.of(context).size.width;
        return Scaffold(
          appBar: CustomAppBar(
            title: translation(context: context, 'Home'),
            actions: [
              RoleGate(
                minRole: UserRole.superuser,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    tooltip: translation(context: context, 'Show saved FCM tokens'),
                    icon: const Icon(Icons.notifications),
                    onPressed: () async {
                      await showTokensDialog(context);
                    },
                  ),
                ),
              ),
            ],
          ),
          body: Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  SizedBox(
                    width: width,
                    child: Card(
                      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              translation(context: context, 'Program'),
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            weekProgramAsync.when(
                              data: (data) {
                                final appointments = getNextAppointments(data);
                                if (appointments.isEmpty) {
                                  return Text(translation(context: context, 'No program entries found for this week.'));
                                }
                                final now = DateTime.now();
                                final todayIdx = now.weekday - 1;
                                final nowTime = TimeOfDay(hour: now.hour, minute: now.minute);
                                return Column(
                                  children: appointments.asMap().entries.map((entry) {
                                    final a = entry.value;
                                    bool isCurrent = false;
                                    final eventDayIdx = weekDaysShort.indexOf(a['day']!);
                                    if (eventDayIdx == todayIdx) {
                                      final fromParts = a['from']!.split(':');
                                      final from = TimeOfDay(hour: int.parse(fromParts[0]), minute: int.parse(fromParts[1]));
                                      // Find next event for today
                                      TimeOfDay? nextFrom;
                                      if (entry.key < appointments.length - 1) {
                                        final next = appointments[entry.key + 1];
                                        final nextDayIdx = weekDaysShort.indexOf(next['day']!);
                                        if (nextDayIdx == todayIdx) {
                                          final nextFromParts = next['from']!.split(':');
                                          nextFrom = TimeOfDay(hour: int.parse(nextFromParts[0]), minute: int.parse(nextFromParts[1]));
                                        }
                                      }
                                      bool afterFrom = nowTime.hour > from.hour || (nowTime.hour == from.hour && nowTime.minute >= from.minute);
                                      bool beforeNext = nextFrom == null || (nowTime.hour < nextFrom.hour || (nowTime.hour == nextFrom.hour && nowTime.minute < nextFrom.minute));
                                      isCurrent = afterFrom && beforeNext;
                                    }
                                    bool isNewDay = false;
                                    if (entry.key == 0) {
                                      isNewDay = true;
                                    } else {
                                      final prev = appointments[entry.key - 1];
                                      isNewDay = a['day'] != prev['day'];
                                    }
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (isNewDay && entry.key != 0) const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.surface,
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: isCurrent ? Colors.red : Theme.of(context).colorScheme.primary.withAlpha(200),
                                                width: 2,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${a['day']} ',
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                Text('${a['from']} - ${a['to']}: '),
                                                Expanded(child: Text(a['event']!)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                );
                              },
                              loading: () => const Center(child: CircularProgressIndicator()),
                              error: (e, s) => Text(translation(context: context, 'Error loading Program: $e')),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.dining, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: cateringAsync.when(
                              data: (data) {
                                final now = DateTime.now();
                                final todayIdx = now.weekday - 1; // Monday=0
                                for (int offset = 0; offset < 7; offset++) {
                                  final dayIdx = (todayIdx + offset) % 7;
                                  final List<int> assignedMeals = [];
                                  final fullName = "${user.firstName} ${user.lastName}";
                                  for (int meal = 0; meal < data[dayIdx].length; meal++) {
                                    final names = data[dayIdx][meal];
                                    if (names.contains(fullName)) {
                                      assignedMeals.add(meal);
                                    }
                                  }
                                  if (assignedMeals.isNotEmpty) {
                                    final isToday = offset == 0;
                                    final weekday = isToday ? translation(context: context, 'Today') : weekDaysFull[dayIdx];
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          translation(context: context, 'Your next catering assignment:'),
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              weekday,
                                              style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                                            ),
                                            const Text(': '),
                                            ...assignedMeals.asMap().entries.map((entry) => Row(
                                              children: [
                                                Text(
                                                  mealNames[entry.value],
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.tertiary),
                                                ),
                                                if (entry.key != assignedMeals.length - 1)
                                                  const Text(', '),
                                              ],
                                            )),
                                          ],
                                        ),
                                      ],
                                    );
                                  }
                                }
                                return Text(translation(context: context, 'No upcoming catering assignment found.'));
                              },
                              loading: () => Text(translation(context: context, 'Catering wird geladen...')),
                              error: (e, s) => Text(translation(context: context, 'Error loading Catering.')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.cleaning_services, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: cleaningAsync.when(
                              data: (data) {
                                final places = data as Map<String, dynamic>? ?? {};
                                if (places.isEmpty) {
                                  return Text(translation(context: context, 'No cleaning assignments found.'));
                                }
                                final userPlaces = <String>[];
                                places.forEach((placeId, placeData) {
                                  if (placeData is Map) {
                                    final assignees = placeData['assignees'];
                                    if (assignees is List && assignees.any((a) {
                                      if (a is String) {
                                        final assigneeUid = a.split('_').first;
                                        return assigneeUid == user.uid;
                                      }
                                      return false;
                                    })) {
                                      userPlaces.add(placeData['name'] as String? ?? placeId);
                                    }
                                  }
                                });
                                if (userPlaces.isEmpty) {
                                  return Text(translation(context: context, 'You have no cleaning assignment'));
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      translation(context: context, 'Your cleaning assignment:'),
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    ...userPlaces.map((place) => Text(
                                          place,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                        )),
                                  ],
                                );
                              },
                              loading: () => Text(translation(context: context, 'Cleaning assignments are loading...')),
                              error: (e, s) => Text(translation(context: context, 'Error loading Cleaning data.')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: CantineWidget(placeId: user.placeId, userUid: user.uid, userRole: user.role))
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => Scaffold(
        body: Center(child: Text('Error loading user: $e')),
      ),
    );
  } // Ende build
} // Ende HomePage
