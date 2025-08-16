import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/tab_page.dart';

final communicationTabIndexProvider = StateProvider<int?>((ref) => null);

class CommunicationPage extends StatelessWidget {
  const CommunicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TabPage(
      tabs: const [
        TabMeta('Messenger', DummyPage('Messenger'), Icons.forum_outlined),
        TabMeta('Announcements', DummyPage('Announcements'), Icons.campaign_outlined),
        TabMeta('Surveys', DummyPage('Surveys'), Icons.thumbs_up_down_outlined),
        TabMeta('Permissions', DummyPage('Permissions'), Icons.shield_moon_outlined),
        TabMeta('Suggestion Box', DummyPage('Suggestion Box'), Icons.feedback_outlined),
        TabMeta('Forum', DummyPage('Forum'), Icons.feed_outlined),
      ],
      tabIndexProvider: communicationTabIndexProvider,
      prefsKey: 'communication_last_tab_index',
    );
  }
}

class DummyPage extends StatelessWidget {
  final String label;
  const DummyPage(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(label, style: const TextStyle(fontSize: 24)),
    );
  }
}
