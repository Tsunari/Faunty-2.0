import 'package:flutter/material.dart';
import 'cleaning_assign.dart';
import '../../components/custom_app_bar.dart';

class CleaningPage extends StatefulWidget {
  const CleaningPage({super.key});

  @override
  State<CleaningPage> createState() => _CleaningPageState();
}

class _CleaningPageState extends State<CleaningPage> {
  // Dummy data for cleaning places and users
  final List<String> places = ['Kitchen', 'Bathroom', 'Living Room Cool Wow', 'Hallway', 'Bedroom', 'Garage', 'Garden', 'Balcony', 'Office'];
  final List<String> users = [
    'Alice',
    'Bob',
    'Charlie',
    'Diana',
    'Eve',
    'Frank',
    'Grace',
    'Heidi',
  ];

  // Map to keep track of assignments (multiple users per place)
  late Map<String, List<String>> assignments;

  @override
  void initState() {
    super.initState();
    assignments = {
      for (var place in places) place: [
        users[0], 
        users[1], 
        users[2], 
        users[3], 
        users[4]
        ],
    };
  }

  void _navigateToAssignPage() async {
    final result = await Navigator.of(context).push<Map<String, List<String>>>(
      MaterialPageRoute(
        builder: (context) => CleaningAssignPage(
          places: places,
          users: users,
          currentAssignments: Map<String, List<String>>.from(assignments),
        ),
      ),
    );
    if (result != null) {
      setState(() {
        assignments = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Cleaning',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _navigateToAssignPage,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                border: Border.all(color: Theme.of(context).dividerColor, width: 1.2),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              margin: const EdgeInsets.only(bottom: 0),
              child: Row(
                children: const [
                  Expanded(
                    flex: 2,
                    child: Text('Place', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, letterSpacing: 0.5)),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text('Assignees', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, letterSpacing: 0.5)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: places.length,
                itemBuilder: (context, idx) {
                  final place = places[idx];
                  final assigned = assignments[place] ?? [];
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border(
                        left: BorderSide(color: Theme.of(context).dividerColor, width: 1.2),
                        right: BorderSide(color: Theme.of(context).dividerColor, width: 1.2),
                        bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1.2),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            place,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, letterSpacing: 0.2),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: assigned.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: assigned
                                        .map((u) => Chip(
                                              label: Text(u, style: const TextStyle(fontSize: 13)),
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                              visualDensity: VisualDensity.compact,
                                              backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.50),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                              labelStyle: TextStyle(
                                                color: Theme.of(context).colorScheme.onSurface,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                )
                              : const Text('No users assigned', style: TextStyle(color: Colors.grey)),
                        ),
                      ],
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
}
