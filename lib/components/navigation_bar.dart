
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const NavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  static const List<NavigationDestination> _destinations = [
    NavigationDestination(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.nature),
      label: 'Tree',
    ),
    NavigationDestination(
      icon: Icon(Icons.message),
      label: 'Messenger',
    ),
    NavigationDestination(
      icon: Icon(Icons.miscellaneous_services),
      label: 'Service',
    ),
    NavigationDestination(
      icon: Icon(Icons.more_horiz),
      label: 'More',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      selectedIndex: selectedIndex,
      destinations: _destinations,
      onDestinationSelected: onItemTapped,
    );
  }
}
