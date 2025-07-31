

import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  final List<Widget> pages;
  final List<String> titles;
  final List<List<Widget>>? actions;
  const NavBar({Key? key, required this.pages, required this.titles, this.actions}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

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
      icon: Icon(Icons.checklist),
      label: 'Program',
    ),
    NavigationDestination(
      icon: Icon(Icons.more_horiz_outlined),
      label: 'More',
    ),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.titles[_selectedIndex]),
        actions: widget.actions != null && widget.actions!.length > _selectedIndex
            ? widget.actions![_selectedIndex]
            : null,
      ),
      body: widget.pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: _selectedIndex,
        destinations: _destinations,
        onDestinationSelected: _onDestinationSelected,
      ),
    );
  }
}
