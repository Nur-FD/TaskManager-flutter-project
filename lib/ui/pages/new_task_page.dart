import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/network_response.dart';
import 'package:task_manager_app/data/models/summary_count_model.dart';
import 'package:task_manager_app/data/models/task_list_model.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/ui/custom_widgets/add_task_button.dart';
import 'package:task_manager_app/ui/custom_widgets/screen_background.dart';
import 'package:task_manager_app/ui/custom_widgets/summery_card.dart';
import 'package:task_manager_app/ui/pages/update_task_bottomSheet_screen.dart';
import 'package:task_manager_app/ui/update_task_status_sheet.dart';
import 'package:task_manager_app/ui/utils/showMessage.dart';

import '../../data/utils/urls.dart';
import '../custom_widgets/task_list_title.dart';
import '../custom_widgets/user_profile_appBar.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getSummeryCountInProgress = false, _getNewTaskInProgress = false;
  SummaryCountModel _summaryCountModel = SummaryCountModel();
  TaskListModel _taskListModel = TaskListModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSummeryCount();
      getNewTask();
    });
  }

  Future<void> getSummeryCount() async {
    _getSummeryCountInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.taskStatusCount);
    if (response.isSuccess) {
      _summaryCountModel = SummaryCountModel.fromJson(response.body!);
    } else {
      if (mounted) {
        showMsg(context, 'Summary data failed');
      }
    }
    _getSummeryCountInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getNewTask() async {
    _getNewTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.newTasks);
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.body!);
    } else {
      if (mounted) {
        showMsg(context, 'Summery date get failed');
      }
    }
    _getNewTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> updateTask(String taskId,String newStatus) async {
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.updateTask(taskId,newStatus));
    if (response.isSuccess) {
      _taskListModel.data!.removeWhere((element) => element.id == taskId);
      if (mounted) {
        setState(() {});
      }
    } else {
      if (mounted) {
        showMsg(context, 'Deletion of task has been failed');
      }
    }
  }
  Future<void> deleteTask(String taskId) async {
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.deleteTask(taskId));
    if (response.isSuccess) {
      _taskListModel.data!.removeWhere((element) => element.id == taskId);
      if (mounted) {
        setState(() {});
      }
    } else {
      if (mounted) {
        showMsg(context, 'Deletion of task has been failed');
      }
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
          child: Column(
        children: [
           const UserProfileAppBar(
             isUpdateScreen: false,
           ),
          const SizedBox(
            height: 5,
          ),
          _getSummeryCountInProgress
              ? const LinearProgressIndicator()
              : SizedBox(
                  height:80,
                  width:double.infinity,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return SummaryCard(
                          title: _summaryCountModel.data![index].id ?? 'New',
                          number: _summaryCountModel.data![index].sum ?? 0,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          height: 4,
                        );
                      },
                      itemCount: _summaryCountModel.data?.length ?? 0),
                ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                getNewTask();
                getSummeryCount();
              },
              child: _getNewTaskInProgress
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.separated(
                      itemCount: _taskListModel.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return TaskListTile(
                          data: _taskListModel.data![index],
                          onEditTap: () {
                            showStatusBottomSheet(_taskListModel.data![index]);
                          },
                          onDeleteTap: () {
                            deleteTask(_taskListModel.data![index].id!);
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          height: 4,
                        );
                      },
                    ),
            ),
          ),
        ],
      )),
      floatingActionButton: const AddTaskButton(),
    );
  }

  void showEditBottomSheet(TaskData task) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return UpdateTaskSheet(
            task: task,
            onUpdate: () {
              getNewTask();
            },
          );
        });
  }

  void showStatusBottomSheet(TaskData task) {

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return UpdateTaskStatusSheet(task: task,onUpdateStatus: (){
            getNewTask();
          },);

        });
  }
}
