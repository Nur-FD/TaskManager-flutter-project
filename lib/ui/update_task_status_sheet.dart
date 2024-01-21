import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/task_list_model.dart';
import 'package:task_manager_app/ui/utils/showMessage.dart';

import '../data/models/network_response.dart';
import '../data/services/network_caller.dart';
import '../data/utils/urls.dart';

class UpdateTaskStatusSheet extends StatefulWidget {
  final VoidCallback onUpdateStatus;
  final TaskData task;
  const UpdateTaskStatusSheet(
      {super.key, required this.onUpdateStatus, required this.task});

  @override
  State<UpdateTaskStatusSheet> createState() => _UpdateTaskStatusSheetState();
}

class _UpdateTaskStatusSheetState extends State<UpdateTaskStatusSheet> {
  List<String> taskStatusList = ['New', 'Progress', 'Cancelled', 'Completed'];
  late String _selectedTask;
  bool updateTaskProgress = false;
  @override
  void initState() {
    _selectedTask = widget.task.status!.toLowerCase();
    super.initState();
  }

  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    updateTaskProgress =true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.updateTask(taskId,newStatus));
    updateTaskProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      widget.onUpdateStatus();
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        showMsg(context, 'Updated task status failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(16)),
          const Text(
            'Update status',
            style: TextStyle(fontSize: 22),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: taskStatusList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    _selectedTask = taskStatusList[index];
                    setState(() {});
                  },
                  title: Text(taskStatusList[index].toUpperCase()),
                  trailing: _selectedTask == taskStatusList[index]
                      ? const Icon(Icons.check)
                      : null,
                );
              },
            ),
          ),
          Visibility(
            visible: updateTaskProgress == false,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: SizedBox(
                height: 50,
                width: 100,
                child: ElevatedButton(
                    onPressed: () {
                      updateTaskStatus(widget.task.id!,_selectedTask);
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ))),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
