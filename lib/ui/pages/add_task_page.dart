import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/network_response.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/ui/custom_widgets/screen_background.dart';
import 'package:task_manager_app/ui/utils/showMessage.dart';
import '../../data/utils/urls.dart';
import '../custom_widgets/user_profile_appBar.dart';

class AddNewTaskScreen extends StatefulWidget {
  static const String routeName = '/add_new task';
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  bool _addNewTaskInProgress = false;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey=GlobalKey<FormState>();

  Future<void> addNewTask() async {
    _addNewTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    Map<String, dynamic> requestBody = {
      "title": _titleController.text.trim(),
      "description": _descriptionController.text.trim(),
      "status": "New"
    };
    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.createTask, requestBody);
    _addNewTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      _titleController.clear();
      _descriptionController.clear();
      if (mounted) {
        showMsg(context, 'Task added successfully');
      }
    }
    else {
      if (mounted) {
        showMsg(context, 'Task add failed!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const UserProfileAppBar( isUpdateScreen:false),
                const SizedBox(
                  height: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add New Task',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(hintText: 'title'),
                        validator: (String? value){
                          if(value?.isEmpty ?? true){
                            return 'Please write your title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration:
                            const InputDecoration(hintText: 'description'),
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Visibility(
                          visible: _addNewTaskInProgress==false,
                          replacement: const Center(child: CircularProgressIndicator(),),
                          child: ElevatedButton(
                              onPressed: () {
                                if(!_formKey.currentState!.validate()){
                                  return;
                                }
                                addNewTask();
                              },
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              )),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
