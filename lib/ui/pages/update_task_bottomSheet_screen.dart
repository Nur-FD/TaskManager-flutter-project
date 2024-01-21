import 'package:flutter/material.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../utils/showMessage.dart';

class UpdateTaskSheet extends StatefulWidget {
  final TaskData task;
  final VoidCallback onUpdate;

  const UpdateTaskSheet({super.key, required this.task, required this.onUpdate});
  @override
  State<UpdateTaskSheet> createState() => _UpdateTaskSheetState();
}

class _UpdateTaskSheetState extends State<UpdateTaskSheet> {
Future<void> updateTaskItem() async {
  _updateTaskInProgress = true;
  if (mounted) {
    setState(() {});
  }
  Map<String, dynamic> requestBody = {
    "title": _titleController.text.trim(),
    "description": _descriptionController.text.trim(),
  };
  final NetworkResponse response =
  await NetworkCaller().postRequest(Urls.createTask, requestBody);
  _updateTaskInProgress = false;
  if (mounted) {
    setState(() {});
  }
  if (response.isSuccess) {
    _titleController.clear();
    _descriptionController.clear();
    if (mounted) {
      showMsg(context, 'task Updated successfully');
    }
    widget.onUpdate();
  }
  else {
    if (mounted) {
      showMsg(context, 'Task updated failed!');
    }
  }
}
late TextEditingController _titleController;

late TextEditingController _descriptionController;

bool _updateTaskInProgress = false;
@override
void initState() {
  _titleController = TextEditingController(text: widget.task.title);
  _descriptionController =
      TextEditingController(text: widget.task.description);
  super.initState();
}

@override
Widget build(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(
      bottom: MediaQuery.of(context).viewInsets.bottom,
    ),
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Update Task',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'title'),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(hintText: 'description'),
            ),
            const SizedBox(
              height: 24.0,
            ),
            SizedBox(
              width: double.infinity,
              child: Visibility(
                visible: _updateTaskInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: ElevatedButton(
                    onPressed: () {
                      updateTaskItem();
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
@override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
