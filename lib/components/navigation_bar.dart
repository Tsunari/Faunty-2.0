import 'package:faunty/tools/translation_helper.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  const NavBar({super.key, required this.selectedIndex, required this.onDestinationSelected});


  @override
  Widget build(BuildContext context) {
    final destinations = [
      NavigationDestination(
        icon: Icon(Icons.home_filled),
        label: translation(context: context, 'Home'),
      ),
      NavigationDestination(
        icon: Icon(Icons.cleaning_services),
        label: translation(context: context, 'Cleaning'),
      ),
      NavigationDestination(
        icon: Icon(Icons.dining),
        label: translation(context: context, 'Catering'),
      ),
      // NavigationDestination(
      //   icon: Icon(Icons.today),
      //   label: translation(context: context, 'Program'),
      // ),
      NavigationDestination(
        icon: Icon(Icons.list_alt_outlined),
        label: translation(context: context, 'Lists'),
      ),
      NavigationDestination(
        icon: Icon(Icons.more_horiz_outlined),
        label: translation(context: context, 'More'),
      ),
    ];
    return NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      selectedIndex: selectedIndex,
      destinations: destinations,
      onDestinationSelected: onDestinationSelected,
    );
  }
}
