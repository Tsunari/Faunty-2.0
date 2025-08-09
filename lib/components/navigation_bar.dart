import 'package:faunty/tools/translation_helper.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  const NavBar({super.key, required this.selectedIndex, required this.onDestinationSelected});

  static final List<NavigationDestination> _destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_filled),
      label: translation('Home'),
    ),
    NavigationDestination(
      icon: Icon(Icons.cleaning_services),
      label: translation('Cleaning'),
    ),
    NavigationDestination(
      icon: Icon(Icons.dining),
      label: translation('Catering'),
    ),
    NavigationDestination(
      icon: Icon(Icons.today),
      label: translation('Program'),
    ),
    NavigationDestination(
      icon: Icon(Icons.more_horiz_outlined),
      label: translation('More'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      selectedIndex: selectedIndex,
      destinations: _destinations,
      onDestinationSelected: onDestinationSelected,
    );
  }
}
