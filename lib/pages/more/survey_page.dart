import 'package:flutter/material.dart';
import 'package:faunty/components/custom_app_bar.dart';
import 'package:faunty/tools/translation_helper.dart';
import 'package:faunty/components/custom_snackbar.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  // Dummy survey data
  final List<Map<String, dynamic>> surveys = [
    {
      'title': 'Satisfaction Survey bla bbla bla bla bla lrem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',  
      'options': [
        {'label': 'Very Satisfied lorem ipsum  dasasd asdda dasd asda dasd as ', 'value': 5},
        {'label': 'Satisfied', 'value': 4},
        {'label': 'Neutral', 'value': 3},
        {'label': 'Dissatisfied', 'value': 2},
        {'label': 'Very Dissatisfied', 'value': 1},
      ],
    },
    {
      'title': 'Event Feedback',
      'options': [
        {'label': 'Excellent', 'value': 'excellent'},
        {'label': 'Good', 'value': 'good'},
        {'label': 'Average', 'value': 'average'},
        {'label': 'Poor', 'value': 'poor'},
      ],
    },
    {
      'title': 'Weekly Check-in',
      'options': [
        {'label': 'All Good', 'value': 'all_good'},
        {'label': 'Some Issues', 'value': 'some_issues'},
        {'label': 'Need Help', 'value': 'need_help'},
      ],
    },
  ];

  // Local vote counts for each survey option
  final Map<String, Map<dynamic, int>> voteCounts = {};
  // Local user selection for each survey
  final Map<String, dynamic> userSelections = {};

  String _surveyId(String title) => title.toLowerCase().replaceAll(' ', '_');

  bool debugMode = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: CustomAppBar(
        title: translation('Survey', context: context),
        actions: [
          IconButton(
            icon: Icon(debugMode ? Icons.bug_report : Icons.bug_report_outlined, color: debugMode ? Colors.red : null),
            tooltip: 'Debug Mode',
            onPressed: () {
              setState(() {
                debugMode = !debugMode;
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        itemCount: surveys.length,
        itemBuilder: (context, index) {
          final survey = surveys[index];
          final options = survey['options'] as List<Map<String, dynamic>>;
          final surveyId = _surveyId(survey['title']);
          voteCounts.putIfAbsent(surveyId, () => {for (var o in options) o['value']: 0});
          final selectedValue = userSelections[surveyId];
          return Card(
            color: isDark ? Colors.grey[850] : null,
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          translation(survey['title'], context: context),
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: translation('Edit', context: context),
                        onPressed: () async {
                          String editTitle = survey['title'];
                          List<String> editOptions = List<String>.from((survey['options'] as List).map((o) => o['label'].toString()));
                          List<FocusNode> optionFocusNodes = List.generate(editOptions.length, (_) => FocusNode());
                          bool allowMultiple = survey['allowMultiple'] == true;
                          bool updated = false;
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setStateDialog) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              translation('Edit Survey', context: context),
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                            ),
                                            const SizedBox(height: 16),
                                            TextField(
                                              controller: TextEditingController(text: editTitle),
                                              decoration: InputDecoration(
                                                labelText: translation('Survey Title', context: context),
                                                border: const OutlineInputBorder(),
                                              ),
                                              onChanged: (val) => editTitle = val,
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              translation('Options', context: context),
                                              style: const TextStyle(fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(height: 8),
                                            ...List.generate(editOptions.length, (i) => Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: TextField(
                                                      focusNode: optionFocusNodes[i],
                                                      controller: TextEditingController(text: editOptions[i]),
                                                      decoration: InputDecoration(
                                                        labelText: translation('Option', context: context) + ' ${i + 1}',
                                                        border: const OutlineInputBorder(),
                                                      ),
                                                      onChanged: (val) => editOptions[i] = val,
                                                    ),
                                                  ),
                                                ),
                                                if (editOptions.length > 1)
                                                  IconButton(
                                                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                                                    onPressed: () {
                                                      setStateDialog(() {
                                                        optionFocusNodes[i].dispose();
                                                        optionFocusNodes.removeAt(i);
                                                        editOptions.removeAt(i);
                                                      });
                                                    },
                                                  ),
                                              ],
                                            )),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: TextButton.icon(
                                                icon: const Icon(Icons.add),
                                                label: Text(translation('Add Option', context: context)),
                                                onPressed: () {
                                                  setStateDialog(() {
                                                    editOptions.add('');
                                                    optionFocusNodes.add(FocusNode());
                                                  });
                                                  Future.delayed(Duration(milliseconds: 100), () {
                                                    if (optionFocusNodes.isNotEmpty) {
                                                      optionFocusNodes.last.requestFocus();
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              children: [
                                                Text(
                                                  translation('Allow multiple answers', context: context),
                                                  style: const TextStyle(fontSize: 15),
                                                ),
                                                const SizedBox(width: 8),
                                                Switch(
                                                  value: allowMultiple,
                                                  onChanged: (val) {
                                                    setStateDialog(() {
                                                      allowMultiple = val;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    for (final node in optionFocusNodes) {
                                                      node.dispose();
                                                    }
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(translation('Cancel', context: context)),
                                                ),
                                                const SizedBox(width: 8),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    if (editTitle.trim().isEmpty || editOptions.any((o) => o.trim().isEmpty)) {
                                                      showCustomSnackBar(context, translation('Please fill in all fields', context: context));
                                                      return;
                                                    }
                                                    for (final node in optionFocusNodes) {
                                                      node.dispose();
                                                    }
                                                    updated = true;
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(translation('Save', context: context)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                          if (updated) {
                            setState(() {
                              surveys[index] = {
                                'title': editTitle.trim(),
                                'options': [for (var o in editOptions) {'label': o.trim(), 'value': o.trim()}],
                                'allowMultiple': allowMultiple,
                              };
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...options.map((option) {
                    final allowMultiple = survey['allowMultiple'] == true;
                    final selected = userSelections[surveyId];
                    final isSelected = allowMultiple
                        ? (selected is Set ? selected.contains(option['value']) : false)
                        : selected == option['value'];
                    final count = voteCounts[surveyId]![option['value']] ?? 0;
                    final totalVotes = voteCounts[surveyId]!.values.fold<int>(0, (a, b) => a + b);
                    final percent = totalVotes > 0 ? count / totalVotes : 0.0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: LinearProgressIndicator(
                                value: percent,
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.primary.withOpacity(0.35),
                                ),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            elevation: 0.5,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                setState(() {
                                  if (debugMode) {
                                    voteCounts[surveyId]![option['value']] = (voteCounts[surveyId]![option['value']] ?? 0) + 1;
                                  } else {
                                    if (allowMultiple) {
                                      userSelections.putIfAbsent(surveyId, () => <dynamic>{});
                                      final selectedSet = userSelections[surveyId] as Set;
                                      if (selectedSet.contains(option['value'])) {
                                        selectedSet.remove(option['value']);
                                        voteCounts[surveyId]![option['value']] = (voteCounts[surveyId]![option['value']] ?? 1) - 1;
                                      } else {
                                        selectedSet.add(option['value']);
                                        voteCounts[surveyId]![option['value']] = (voteCounts[surveyId]![option['value']] ?? 0) + 1;
                                      }
                                    } else {
                                      final prev = userSelections[surveyId];
                                      if (prev != null) {
                                        voteCounts[surveyId]![prev] = (voteCounts[surveyId]![prev] ?? 1) - 1;
                                      }
                                      userSelections[surveyId] = option['value'];
                                      voteCounts[surveyId]![option['value']] = (voteCounts[surveyId]![option['value']] ?? 0) + 1;
                                    }
                                  }
                                });
                              },
                              onLongPress: debugMode
                                  ? () {
                                      setState(() {
                                        voteCounts[surveyId]![option['value']] = (voteCounts[surveyId]![option['value']] ?? 1) - 1;
                                        if (voteCounts[surveyId]![option['value']]! < 0) {
                                          voteCounts[surveyId]![option['value']] = 0;
                                        }
                                      });
                                    }
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                child: Row(
                                  children: [
                                    allowMultiple
                                        ? Icon(
                                            isSelected
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: Theme.of(context).colorScheme.primary,
                                            size: 22,
                                          )
                                        : Icon(
                                            isSelected
                                                ? Icons.radio_button_checked
                                                : Icons.radio_button_unchecked,
                                            color: Theme.of(context).colorScheme.primary,
                                            size: 22,
                                          ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        translation(option['label'], context: context),
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        count.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        translation('Votes for', context: context) + ': ' + translation(survey['title'], context: context),
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                      const SizedBox(height: 16),
                                      ...options.map((option) {
                                        final count = voteCounts[surveyId]![option['value']] ?? 0;
                                        // Dummy user list: In echter App hier Usernamen aus DB holen
                                        final users = List.generate(count, (i) => 'User ${i + 1}');
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    translation(option['label'], context: context),
                                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(left: 8),
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Text(
                                                    count.toString(),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: Theme.of(context).colorScheme.primary,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (users.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(left: 12, top: 2, bottom: 8),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: users.map((u) => Text(u, style: const TextStyle(fontSize: 13, color: Colors.grey))).toList(),
                                                ),
                                              ),
                                            const Divider(height: 16),
                                          ],
                                        );
                                      }).toList(),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: Text(translation('Close', context: context)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Text('View votes'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String newTitle = '';
          List<String> newOptions = [''];
          List<FocusNode> optionFocusNodes = [FocusNode()];
          bool added = false;
          bool allowMultiple = false;
          await showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setStateDialog) {
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              translation('Add Survey', context: context),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              decoration: InputDecoration(
                                labelText: translation('Survey Title', context: context),
                                border: const OutlineInputBorder(),
                              ),
                              onChanged: (val) => newTitle = val,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              translation('Options', context: context),
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            ...List.generate(newOptions.length, (i) => Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      focusNode: optionFocusNodes[i],
                                      autofocus: i == newOptions.length - 1 && optionFocusNodes.length == newOptions.length,
                                      decoration: InputDecoration(
                                        labelText: translation('Option', context: context) + ' ${i + 1}',
                                        border: const OutlineInputBorder(),
                                      ),
                                      onChanged: (val) => newOptions[i] = val,
                                    ),
                                  ),
                                ),
                                if (newOptions.length > 1)
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                                    onPressed: () {
                                      setStateDialog(() {
                                        optionFocusNodes[i].dispose();
                                        optionFocusNodes.removeAt(i);
                                        newOptions.removeAt(i);
                                      });
                                    },
                                  ),
                              ],
                            )),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                icon: const Icon(Icons.add),
                                label: Text(translation('Add Option', context: context)),
                                onPressed: () {
                                  setStateDialog(() {
                                    newOptions.add('');
                                    optionFocusNodes.add(FocusNode());
                                  });
                                  // Nach dem Build den neuen FocusNode fokussieren
                                  Future.delayed(Duration(milliseconds: 100), () {
                                    if (optionFocusNodes.isNotEmpty) {
                                      optionFocusNodes.last.requestFocus();
                                    }
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  translation('Allow multiple answers', context: context),
                                  style: const TextStyle(fontSize: 15),
                                ),
                                const SizedBox(width: 8),
                                Switch(
                                  value: allowMultiple,
                                  onChanged: (val) {
                                    setStateDialog(() {
                                      allowMultiple = val;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    for (final node in optionFocusNodes) {
                                      node.dispose();
                                    }
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(translation('Cancel', context: context)),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    if (newTitle.trim().isEmpty || newOptions.any((o) => o.trim().isEmpty)) {
                                      showCustomSnackBar(context, translation('Please fill in all fields', context: context));
                                      return;
                                    }
                                    for (final node in optionFocusNodes) {
                                      node.dispose();
                                    }
                                    added = true;
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(translation('Add', context: context)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
          if (added) {
            setState(() {
              surveys.add({
                'title': newTitle.trim(),
                'options': [
                  for (var o in newOptions)
                    {'label': o.trim(), 'value': o.trim()},
                ],
                'allowMultiple': allowMultiple,
              });
            });
          }
        },
        tooltip: translation('Add Survey', context: context),
        child: const Icon(Icons.add),
      ),
    );
  }
}