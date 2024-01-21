import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/task_list_model.dart';

class TaskListTile extends StatelessWidget {
  const TaskListTile({
    super.key,
    required this.data,
    required this.onDeleteTap,
    required this.onEditTap,
  });
  final VoidCallback onDeleteTap, onEditTap;
  final TaskData data;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(data.title ?? 'Unknown'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.description ?? ''),
          Text(data.createdDate ?? ''),
          Row(
            children: [
              Chip(
                label: Text(
                  data.status ?? 'New',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.blue,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              const Spacer(),
              IconButton(
                  onPressed: onEditTap,
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.indigo,
                  )),
              IconButton(
                  onPressed: onDeleteTap, icon: const Icon(Icons.delete)),
            ],
          ),
        ],
      ),
    );
  }
}
