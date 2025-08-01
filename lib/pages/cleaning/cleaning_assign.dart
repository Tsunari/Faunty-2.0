import 'package:flutter/material.dart';


class CleaningAssignPage extends StatefulWidget {
  final List<String> places;
  final List<String> users;
  final Map<String, List<String>> currentAssignments;

  const CleaningAssignPage({
    super.key,
    required this.places,
    required this.users,
    required this.currentAssignments,
  });

  @override
  State<CleaningAssignPage> createState() => _CleaningAssignPageState();
}

class _CleaningAssignPageState extends State<CleaningAssignPage> {
  late Map<String, List<String>> assignments;

  @override
  void initState() {
    super.initState();
    assignments = Map<String, List<String>>.from(widget.currentAssignments);
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Users to Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save',
            onPressed: () => Navigator.of(context).pop(assignments),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.places.length,
        itemBuilder: (context, index) {
          final place = widget.places[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place),
                  Wrap(
                    spacing: 8.0,
                    children: widget.users.map((user) {
                      final isAssigned = assignments[place]?.contains(user) ?? false;
                      return FilterChip(
                        label: Text(user),
                        selected: isAssigned,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              assignments.putIfAbsent(place, () => []).add(user);
                            } else {
                              assignments[place]?.remove(user);
                              if (assignments[place]?.isEmpty ?? true) {
                                assignments.remove(place);
                              }
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
