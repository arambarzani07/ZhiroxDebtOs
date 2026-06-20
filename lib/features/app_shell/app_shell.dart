import 'package:flutter/material.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.pages,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<Widget> pages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: 'داشبۆرد',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            label: 'کڕیار',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'ڕاپۆرت',
          ),
          NavigationDestination(
            icon: Icon(Icons.health_and_safety_outlined),
            label: 'پشکنین',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'ڕێکخستن',
          ),
        ],
      ),
    );
  }
}
