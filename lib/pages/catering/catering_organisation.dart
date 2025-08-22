import 'package:faunty/tools/translation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state_management/catering_provider.dart';
import '../../components/custom_confirm_dialog.dart';

class CateringOrganisationPage extends ConsumerStatefulWidget {
  final List<List<List<String>>> weekPlan;
  final List<String> users;
  final List<String> meals;
  final List<String> mealsTranslated;

  const CateringOrganisationPage({super.key, required this.weekPlan, required this.users, required this.meals, required this.mealsTranslated});

  @override
  ConsumerState<CateringOrganisationPage> createState() => _CateringOrganisationPageState();
}

class _CateringOrganisationPageState extends ConsumerState<CateringOrganisationPage> {
  List<List<List<String>>>? localWeekPlan;
  bool isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final weekPlanAsync = ref.watch(cateringWeekPlanProvider);
    if (weekPlanAsync is AsyncData<List<List<List<String>>>>) {
      final firestorePlan = weekPlanAsync.value;
      if (localWeekPlan == null || !_deepEquals(localWeekPlan!, firestorePlan)) {
        // Only update if different (prevents overwriting local edits)
        localWeekPlan = firestorePlan.map((day) => day.map((meal) => List<String>.from(meal)).toList()).toList();
      }
    }
  }

  bool _deepEquals(List<List<List<String>>> a, List<List<List<String>>> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].length != b[i].length) return false;
      for (int j = 0; j < a[i].length; j++) {
        if (a[i][j].length != b[i][j].length) return false;
        for (int k = 0; k < a[i][j].length; k++) {
          if (a[i][j][k] != b[i][j][k]) return false;
        }
      }
    }
    return true;
  }

  String getWeekday(int weekday, bool translated) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final daysTranslated = [
      translation(context: context, 'Montag'),
      translation(context: context, 'Dienstag'),
      translation(context: context, 'Mittwoch'),
      translation(context: context, 'Donnerstag'),
      translation(context: context, 'Freitag'),
      translation(context: context, 'Samstag'),
      translation(context: context, 'Sonntag')
    ];
    return translated ? daysTranslated[weekday % 7] : days[weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    final users = widget.users;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    if (localWeekPlan == null) {
      // Show loading until Firestore data is available
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catering Organisation'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        actions: [],
      ),
      body: Row(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: 500,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) => true,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: 7,
                    itemBuilder: (context, dayIdx) {
                      return Card(
                        color: theme.colorScheme.onPrimary.withAlpha(85),
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      getWeekday(dayIdx, true),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: theme.colorScheme.onSurface,
                                      size: 20,
                                    ),
                                    padding: const EdgeInsets.all(0),
                                    constraints: const BoxConstraints(),
                                    onPressed: () async {
                                      final confirm = await showConfirmDialog(
                                        context: context,
                                        title: 'Delete Day',
                                        content: RichText(
                                          text: TextSpan(
                                            style: DefaultTextStyle.of(context).style,
                                            children: [
                                              const TextSpan(text: 'Are you sure you want to delete all entries for '),
                                              TextSpan(
                                                text: getWeekday(dayIdx, true),
                                                style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const TextSpan(text: '?'),
                                            ],
                                          ),
                                        ),
                                        confirmText: 'Delete',
                                      );
                                      if (confirm == true) {
                                        setState(() {
                                          localWeekPlan![dayIdx] = List.generate(widget.meals.length, (_) => []);
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                              // Stacked drop zones: 3 vertically, label inside the drag box
                              Column(
                                children: List.generate(widget.meals.length, (mealIdx) {
                                  final mealName = widget.mealsTranslated[mealIdx];
                                  final usersForMeal = localWeekPlan![dayIdx][mealIdx];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                                    child: DragTarget<String>(
                                      builder: (context, candidateData, rejectedData) {
                                        return Container(
                                          constraints: const BoxConstraints(minHeight: 54),
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.background,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: isDark ? Colors.white24 : Colors.grey),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.restaurant_menu, size: 18, color: isDark ? Colors.white54 : Colors.black45),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    mealName,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: isDark ? Colors.white70 : Colors.black87,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              usersForMeal.isNotEmpty
                                                  ? Wrap(
                                                      spacing: 4,
                                                      runSpacing: 4,
                                                      children: usersForMeal.map((user) => Container(
                                                        margin: const EdgeInsets.only(bottom: 2),
                                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                        decoration: BoxDecoration(
                                                          color: theme.colorScheme.primary.withOpacity(isDark ? 0.18 : 0.08),
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        child: Wrap(
                                                          spacing: 4,
                                                          crossAxisAlignment: WrapCrossAlignment.center,
                                                          children: [
                                                            Text(user, style: TextStyle(color: isDark ? Colors.white : null)),
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                    usersForMeal.remove(user);
                                                                });
                                                              },
                                                              child: Icon(Icons.remove_circle_outline, size: 18, color: isDark ? Colors.red[200] : Colors.red[700]),
                                                            ),
                                                          ],
                                                        ),
                                                      )).toList(),
                                                    )
                                                  : Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                      child: Center(
                                                        child: Text(
                                                          'Drag here for $mealName',
                                                          style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        );
                                      },
                                      onAccept: (user) {
                                        setState(() {
                                          if (!usersForMeal.contains(user)) {
                                            usersForMeal.add(user);
                                          }
                                        });
                                      },
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 160,
            color: isDark ? Colors.grey[900] : Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Users', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: ListView(
                    children: users.map((user) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      child: Draggable<String>(
                        data: user,
                        feedback: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(user, style: TextStyle(color: theme.colorScheme.primary)),
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(isDark ? 0.18 : 0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(user, style: TextStyle(color: theme.colorScheme.primary)),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user,
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontSize: 17, // slightly larger
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isSaving
            ? null
            : () async {
                setState(() => isSaving = true);
                final service = ref.read(cateringFirestoreServiceProvider);
                await service.setWeekPlan(localWeekPlan!);
                setState(() => isSaving = false);
                if (context.mounted) Navigator.pop(context, localWeekPlan);
              },
        tooltip: 'Save and go back',
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: isDark ? Colors.black : Colors.white,
        child: isSaving ? const CircularProgressIndicator() : const Icon(Icons.save),
      ),
    );
  }
}
