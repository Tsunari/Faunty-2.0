import 'package:flutter/material.dart';
import 'package:faunty/tools/translation_helper.dart';
import 'package:faunty/components/table_widget.dart';
import 'package:faunty/components/role_gate.dart';
import 'package:faunty/models/user_roles.dart';

class UiTestPage extends StatefulWidget {
  const UiTestPage({super.key});

  @override
  State<UiTestPage> createState() => _UiTestPageState();
}

class _UiTestPageState extends State<UiTestPage> {
  bool showColumnHeaders = true;

  @override
  Widget build(BuildContext context) {
  final sections = _generateDummySchedule();

    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context: context, 'UI Test Page')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text(
            translation(context: context, 'This page is only visible in debug mode.'),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),

          // toggle show column headers
          SwitchListTile(
            title: Text(translation(context: context, 'Show column headers')),
            value: showColumnHeaders,
            onChanged: (v) => setState(() => showColumnHeaders = v),
          ),

          const SizedBox(height: 12),

          // Attendance example (uses current left/right semantics)
          const SizedBox(height: 6),
          Text(translation(context: context, 'Attendance example'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          TableWidget(
            items: sections.cast<dynamic>(),
            showColumnHeaders: showColumnHeaders,
            leftHeader: translation(context: context, 'Location'),
            rightHeader: translation(context: context, 'Responsible'),
          ),

          const SizedBox(height: 16),

          // Schedule example (left=Time, right=Event) — flat rows
          const SizedBox(height: 6),
          Text(translation(context: context, 'Schedule example'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          TableWidget(
            items: _generateScheduleMixed(),
            showColumnHeaders: showColumnHeaders,
            leftHeader: translation(context: context, 'Time'),
            rightHeader: translation(context: context, 'Event'),
          ),
        ],
      ),
    );
  }
}

// TableWidget has been moved to `lib/components/table_widget.dart` and is imported above.

// Dummy data generator (generic names)
List<Subsection> _generateDummySchedule() {
  return [
    Subsection(title: 'Görevli', rows: [
      Assignment(left: 'Talebe Baskanı', right: 'Atuf'),
      Assignment(left: 'Yemekhane Baskanı', right: 'Ömer'),
      Assignment(left: 'Çöp', right: 'Abdullah'),
      Assignment(left: 'Merdiven 5-6', right: 'Kemal'),
    ]),
    Subsection(title: '5. Kat', rows: [
      Assignment(left: 'WC', right: 'Selim, Tunahan, Furkan'),
      Assignment(left: 'Mescid', right: 'Ingga'),
      Assignment(left: 'Koridor', right: 'Sevban'),
      Assignment(left: 'Freizeitraum', right: 'Zhuma, Şermirza'),
      Assignment(left: 'Yatakhaneler', right: 'Yatakhane Sakinleri'),
    ]),
    Subsection(title: '6. Kat', rows: [
      Assignment(left: 'Dershaneler', right: 'Dershane Sakinleri'),
      Assignment(left: 'Çayhane', right: 'Hilmi'),
      Assignment(left: 'WC', right: 'Nasser'),
      Assignment(left: 'Koridor', right: 'Yasin'),
      Assignment(left: 'Teras', right: 'Nizami, Talha'),
    ]),
  ];
}

// Schedule mixed generator: allows both Assignment and Subsection in same list
List<dynamic> _generateScheduleMixed() {
  return [
    Assignment(left: '08:00', right: 'Breakfast'),
    Assignment(left: '09:00', right: 'Morning Meeting'),
    Subsection(title: 'Midday', rows: [Assignment(left: '13:00', right: 'Workshops'),Assignment(left: '15:00', right: 'Cleaning Slot'),]),
    Subsection(title: 'Test', rows: [Assignment(left: '19:00', right: 'Dinner'),] ),
    Assignment(left: '21:00', right: 'Free Time'),
  ];
}

