import 'package:faunty/pages/catering/catering.dart';
import 'package:faunty/pages/cleaning/cleaning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../program/program_page.dart';
import '../../components/tab_page.dart';

final lastTabIndexProvider = StateProvider<int?>((ref) => null);

class ListsPage extends StatelessWidget {
  const ListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TabPage(
      tabs: const [
        TabMeta('Cleaning', CleaningPage(), Icons.cleaning_services_outlined),
        TabMeta('Catering', CateringPage(), Icons.restaurant_outlined),
        TabMeta('Program', ProgramPage(), Icons.event_outlined),
      ],
      tabIndexProvider: lastTabIndexProvider,
      prefsKey: 'lists_last_tab_index',
    );
  }
}

