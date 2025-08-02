import 'package:flutter/material.dart';

class CateringOrganisationPage extends StatefulWidget {
  final List<List<List<String>>> weekPlan;
  final List<String> users;
  final List<String> meals;

  const CateringOrganisationPage({
    super.key,
    required this.weekPlan,
    required this.users,
    required this.meals,
  });

  @override
  State<CateringOrganisationPage> createState() => _CateringOrganisationPageState();
}

class _CateringOrganisationPageState extends State<CateringOrganisationPage> {
  late List<List<List<String>>> localWeekPlan;

  @override
  void initState() {
    super.initState();
    localWeekPlan = widget.weekPlan.map((day) => day.map((meal) => List<String>.from(meal)).toList()).toList();
  }

  String getWeekday(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catering Organisation'),
        backgroundColor: isDark ? Colors.grey[900] : null,
        foregroundColor: isDark ? Colors.white : null,
        actions: [
          // Test-Button entfernt
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: 500,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) => true, // disables scrollbar
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getWeekday(dayIdx),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : null,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline, 
                                      color: isDark ? Colors.white : Colors.black,
                                      size: 20,
                                    ),
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
                                                    localWeekPlan[dayIdx] = List.generate(widget.meals.length, (_) => []);
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
                              ...List.generate(widget.meals.length, (mealIdx) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        widget.meals[mealIdx],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: isDark ? Colors.white : null,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: DragTarget<String>(
                                        builder: (context, candidateData, rejectedData) {
                                          return Wrap(
                                            children: localWeekPlan[dayIdx][mealIdx].isNotEmpty
                                              ? localWeekPlan[dayIdx][mealIdx].map((user) => Container(
                                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: isDark ? Colors.green.shade900 : Colors.green.shade100,
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Text(user, style: TextStyle(color: isDark ? Colors.white : null)),
                                                )).toList()
                                              : [
                                                  Container(
                                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: isDark ? Colors.grey[800] : Colors.grey.shade200,
                                                      borderRadius: BorderRadius.circular(12),
                                                      border: Border.all(color: isDark ? Colors.white24 : Colors.grey),
                                                    ),
                                                    child: Text('Drag here', style: TextStyle(color: isDark ? Colors.white54 : Colors.black54)),
                                                  )
                                                ],
                                          );
                                        },
                                        onAccept: (user) {
                                          setState(() {
                                            localWeekPlan[dayIdx][mealIdx].add(user);
                                          });
                                        },
                                      ),
                                    ),
                                    if (localWeekPlan[dayIdx][mealIdx].isNotEmpty)
                                      IconButton(
                                        icon: Icon(Icons.remove, size: 18, color: isDark ? Colors.white : Colors.black),
                                        onPressed: () {
                                          setState(() {
                                            localWeekPlan[dayIdx][mealIdx].removeLast();
                                          });
                                        },
                                      ),
                                  ],
                                ),
                              )),
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
                    children: widget.users.map((user) => Padding(
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
                          child: Text(user, style: TextStyle(color: isDark ? Colors.white : null)),
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
        onPressed: () {
          Navigator.pop(context, localWeekPlan);
        },
        child: const Icon(Icons.save),
        tooltip: 'Save and go back',
        backgroundColor: isDark ? Colors.teal[400] : null,
        foregroundColor: isDark ? Colors.black : null,
      ),
    );
  }
}
