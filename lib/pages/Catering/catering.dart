import 'package:faunty/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'catering_organisation.dart';

  // Dummy user data for each meal and day
  final List<String> users = ['Anna', 'Ben', 'Chris', 'Dana', 'Eli', 'Fiona', 'Gus'];
  final List<String> meals = ['Breakfast', 'Lunch', 'Dinner'];
  // Initialize with dummy data: jede Mahlzeit hat mehrere User pro Tag
  List<List<List<String>>> weekPlan = List.generate(7, (day) =>
      List.generate(3, (meal) => [
            users[(day + meal) % users.length],
            users[(day + meal + 1) % users.length],
            users[(day + meal) % users.length],
            users[(day + meal + 1) % users.length],
          ])
    ); // [day][meal][user]

class CateringPage extends StatefulWidget {
  const CateringPage({super.key});

  @override
  State<CateringPage> createState() => _CateringPageState();
}

class _CateringPageState extends State<CateringPage> {

  @override
  void initState() {
    super.initState();
  }

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
    // Only show days with at least one user in any meal
    List<int> visibleDays = [];
    for (int day = 0; day < 7; day++) {
      bool hasUser = false;
      for (int meal = 0; meal < meals.length; meal++) {
        if (weekPlan[day][meal].isNotEmpty) {
          hasUser = true;
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
          child: ListView.builder(
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
                users: users,
                meals: meals,
              ),
            ),
          );
          if (result != null && result is List<List<List<String>>>) {
            setState(() {
              weekPlan = result;
            });
          }
        },
        child: const Icon(Icons.edit),
        tooltip: 'Bearbeiten',
      ),
    );
  }
}
