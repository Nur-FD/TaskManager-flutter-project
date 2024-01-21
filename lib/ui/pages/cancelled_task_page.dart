import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/task_list_model.dart';
import 'package:task_manager_app/ui/custom_widgets/screen_background.dart';
import 'package:task_manager_app/ui/custom_widgets/task_list_title.dart';

import '../../data/models/network_response.dart';
import '../../data/models/summary_count_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../custom_widgets/add_task_button.dart';
import '../custom_widgets/summery_card.dart';
import '../custom_widgets/user_profile_appBar.dart';
import '../update_task_status_sheet.dart';
import '../utils/showMessage.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getCancelledTasks();
      getSummeryCount();
    });
    super.initState();
  }

  bool _getCancelledTasks = false;
   bool  _getSummeryCountInProgress=false;
  TaskListModel _taskListModel = TaskListModel();
  SummaryCountModel summaryCountModel = SummaryCountModel();

  Future<void> getSummeryCount() async {
    _getSummeryCountInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.taskStatusCount);
    if (response.isSuccess) {
      summaryCountModel = SummaryCountModel.fromJson(response.body!);
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
  Future<void> getCancelledTasks() async {
    _getCancelledTasks = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.cancelledTasks);
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.body!);
    } else {
      if (mounted) {
        showMsg(context, 'Cancelled tasks get failed');
      }
    }
    _getCancelledTasks = false;
    if (mounted) {
      setState(() {});
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Column(
          children: [
            const UserProfileAppBar(isUpdateScreen: false),
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
                      title: summaryCountModel.data![index].id ?? 'Cancelled',
                      number:summaryCountModel.data![index].sum ?? 0,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      height: 4,
                    );
                  },
                  itemCount:summaryCountModel.data?.length ?? 0),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: ()async{
                  getCancelledTasks();
                  getSummeryCount();
                },
                child: _getCancelledTasks
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
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
                        separatorBuilder: (context, index) {
                          return const Divider(
                            height: 4,
                          );
                        },
                        itemCount: _taskListModel.data?.length ?? 0),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const AddTaskButton(),
    );
  }
  void showStatusBottomSheet(TaskData task) {

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return UpdateTaskStatusSheet(task: task,onUpdateStatus: (){
            getCancelledTasks();
          },);

        });
  }
}
