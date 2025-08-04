import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  const NavBar({super.key, required this.selectedIndex, required this.onDestinationSelected});

  static const List<NavigationDestination> _destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_filled),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.cleaning_services),
      label: 'Cleaning',
    ),
    NavigationDestination(
      icon: Icon(Icons.dining),
      label: 'Catering',
    ),
    NavigationDestination(
      icon: Icon(Icons.today),
      label: 'Program',
    ),
    NavigationDestination(
      icon: Icon(Icons.more_horiz_outlined),
      label: 'More',
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
