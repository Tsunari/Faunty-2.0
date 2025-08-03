import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state_management/catering_provider.dart';

class CateringOrganisationPage extends ConsumerStatefulWidget {
  final List<List<List<String>>> weekPlan;
  final List<String> users;
  final List<String> meals;

  const CateringOrganisationPage({Key? key, required this.weekPlan, required this.users, required this.meals}) : super(key: key);

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

  String getWeekday(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final users = widget.users;
    final weekPlanAsync = ref.watch(cateringWeekPlanProvider);
    if (localWeekPlan == null) {
      // Show loading until Firestore data is available
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catering Organisation'),
        backgroundColor: isDark ? Colors.grey[900] : null,
        foregroundColor: isDark ? Colors.white : null,
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
                        color: isDark ? Colors.grey[850] : null,
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
                                      getWeekday(dayIdx),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : null,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline, 
                                      color: isDark ? Colors.white : Colors.black,
                                      size: 20,
                                    ),
                                    padding: const EdgeInsets.all(0),
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Delete Day'),
                                            content: Text('Are you sure you want to delete all entries for ${getWeekday(dayIdx)}?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    localWeekPlan![dayIdx] = List.generate(widget.meals.length, (_) => []);
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                              // Stacked drop zones: 3 vertically, label inside the drag box
                              Column(
                                children: List.generate(widget.meals.length, (mealIdx) {
                                  final mealName = widget.meals[mealIdx];
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
                                            color: isDark ? Colors.grey[800] : Colors.grey.shade200,
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
                                                          color: isDark ? Colors.green.shade900 : Colors.green.shade100,
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Text(user, style: TextStyle(color: isDark ? Colors.white : null)),
                                                            const SizedBox(width: 4),
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
                              color: isDark ? Colors.blue.shade400 : Colors.blue.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(user, style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.blue.shade900 : Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(user, style: TextStyle(color: isDark ? Colors.white : null)),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.blue.shade900 : Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user,
                            style: TextStyle(
                              color: isDark ? Colors.white : null,
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
                if (mounted) Navigator.pop(context, localWeekPlan);
              },
        child: isSaving ? const CircularProgressIndicator() : const Icon(Icons.save),
        tooltip: 'Save and go back',
        backgroundColor: isDark ? Colors.teal[400] : null,
        foregroundColor: isDark ? Colors.black : null,
      ),
    );
  }
}
