import 'package:flutter/material.dart';

import '../pages/add_task_page.dart';

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        splashColor: Colors.indigo,
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () =>
            Navigator.pushNamed(context, AddNewTaskScreen.routeName),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ));
  }
}
