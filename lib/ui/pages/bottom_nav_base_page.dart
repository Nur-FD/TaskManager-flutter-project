import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/pages/cancelled_task_page.dart';
import 'package:task_manager_app/ui/pages/completed_task_page.dart';
import 'package:task_manager_app/ui/pages/in_progress_task_page.dart';
import 'package:task_manager_app/ui/pages/new_task_page.dart';

class BottomNavBaseScreen extends StatefulWidget {
  static const String routeName = '/bottom_navbar_screen';
  const BottomNavBaseScreen({super.key});

  @override
  State<BottomNavBaseScreen> createState() => _BottomNavBaseScreenState();
}

class _BottomNavBaseScreenState extends State<BottomNavBaseScreen> {
  int _selectedScreenIndex=0;
  final List<Widget> _screens=const[
    NewTaskScreen(),
    InProgressTaskScreen(),
    CancelledTaskScreen(),
    CompletedTaskScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedScreenIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedScreenIndex,
        onTap: (index){
          _selectedScreenIndex=index;
          if(mounted){
            setState(() {

            });
          }
        },
        unselectedItemColor: Colors.indigo,
        unselectedLabelStyle: const TextStyle(
          color: Colors.indigoAccent,
        ),
        showUnselectedLabels: true,
        selectedItemColor: Colors.green,
        items: const [

          BottomNavigationBarItem(
              icon: Icon(Icons.ac_unit), label: 'New'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_tree), label: 'In Progress'),
          BottomNavigationBarItem(
              icon: Icon(Icons.cancel_outlined), label: 'Cancel'),
          BottomNavigationBarItem(
              icon: Icon(Icons.done_all), label: 'Completed'),
        ],
      ),
    );
  }
}
