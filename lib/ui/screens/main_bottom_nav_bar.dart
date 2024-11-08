import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/screens/canceled_task_screen.dart';
import 'package:task_manager_app/ui/screens/completed_task_screen.dart';
import 'package:task_manager_app/ui/screens/new_task_screen.dart';
import 'package:task_manager_app/ui/screens/progress_task_screen.dart';
import 'package:task_manager_app/ui/widgets/tm_app_bar.dart';

class MainBottomNavBar extends StatefulWidget {
  const MainBottomNavBar({super.key});

  @override
  State<MainBottomNavBar> createState() => _MainBottomNavBarState();
}

class _MainBottomNavBarState extends State<MainBottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    NewTaskScreen(),
    CompletedTaskScreen(),
    CancelTaskScreen(),
    ProgressTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  Widget _buildNavigationBar() {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onTapNavigateIndex,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.new_label_outlined),
          label: 'New',
        ),
        NavigationDestination(
          icon: Icon(Icons.check_circle_outline),
          label: 'Completed',
        ),
        NavigationDestination(
          icon: Icon(Icons.cancel_outlined),
          label: 'Canceled',
        ),
        NavigationDestination(
          icon: Icon(Icons.access_time_outlined),
          label: 'Progress',
        ),
      ],
    );
  }

  void _onTapNavigateIndex(int index) {
    _selectedIndex = index;
    setState(() {});
  }
}
