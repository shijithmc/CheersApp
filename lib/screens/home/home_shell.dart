import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';
import 'home_screen.dart';
import '../jobs/jobs_screen.dart';
import '../discover/discover_screen.dart';
import '../notifications/notifications_screen.dart';
import '../events/events_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    JobsScreen(),
    DiscoverScreen(),
    NotificationsScreen(),
    EventsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: CheersNavBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
