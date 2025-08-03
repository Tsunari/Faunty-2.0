import 'package:faunty/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'catering_organisation.dart';
import '../../state_management/catering_provider.dart';
import '../../state_management/user_list_provider.dart';

// Users will be loaded from allUsersProvider
final List<String> meals = ['Breakfast', 'Lunch', 'Dinner'];

class CateringPage extends ConsumerStatefulWidget {
  const CateringPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CateringPage> createState() => _CateringPageState();
}

class _CateringPageState extends ConsumerState<CateringPage> {

  // No local weekPlan, use provider

  String getWeekday(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final usersAsync = ref.watch(allUsersProvider);
    return usersAsync.when(
      data: (userList) {
        final userNames = userList.map((u) => '${u.firstName} ${u.lastName}').toList();
        final weekPlanAsync = ref.watch(cateringWeekPlanProvider);
        return weekPlanAsync.when(
          data: (weekPlan) {
            // Only show days with at least one user in any meal
            List<int> visibleDays = [];
            bool hasAnyUser = false;
            for (int day = 0; day < 7; day++) {
              bool hasUser = false;
              for (int meal = 0; meal < meals.length; meal++) {
                if (weekPlan[day][meal].isNotEmpty) {
                  hasUser = true;
                  hasAnyUser = true;
                  break;
                }
              }
              if (hasUser) visibleDays.add(day);
            }
            return Scaffold(
              appBar: CustomAppBar(
                title: 'Catering',
              ),
              body: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: hasAnyUser
                      ? ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: visibleDays.length,
                          itemBuilder: (context, idx) {
                            final dayIdx = visibleDays[idx];
                            final date = monday.add(Duration(days: dayIdx));
                            return Card(
                              color: isDark ? Colors.grey[850] : null,
                              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: isDark ? Colors.grey[800] : Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${days[dayIdx]}, ${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: isDark ? Colors.white : null,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ...List.generate(meals.length, (mealIdx) =>
                                      weekPlan[dayIdx][mealIdx].isNotEmpty
                                          ? Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 100,
                                                    child: Text(
                                                      meals[mealIdx],
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: isDark ? Colors.white : null,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Wrap(
                                                      spacing: 8,
                                                      runSpacing: 4,
                                                      children: weekPlan[dayIdx][mealIdx].map((user) => Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                            decoration: BoxDecoration(
                                                              color: isDark ? Colors.green.shade900 : Colors.green.shade100,
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            child: Text(
                                                              user,
                                                              style: TextStyle(color: isDark ? Colors.white : null),
                                                            ),
                                                          )).toList(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 64.0, horizontal: 24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.emoji_food_beverage, size: 64, color: isDark ? Colors.white54 : Colors.blue.shade200),
                              const SizedBox(height: 24),
                              Text(
                                'No catering assignments yet!',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white70 : Colors.blue.shade700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Tap the edit button below to assign users to meals for the week.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDark ? Colors.white54 : Colors.black54,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CateringOrganisationPage(
                        weekPlan: weekPlan,
                        users: userNames,
                        meals: meals,
                      ),
                    ),
                  );
                  if (result != null && result is List<List<List<String>>>) {
                    // Save to Firestore
                    final service = ref.read(cateringFirestoreServiceProvider);
                    await service.setWeekPlan(result);
                  }
                },
                child: const Icon(Icons.edit),
                tooltip: 'Bearbeiten',
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error loading catering data: $e')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error loading users: $e')),
    );
  }
}
