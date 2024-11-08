import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/network_response.dart';
import 'package:task_manager_app/data/models/task_list_model.dart';
import 'package:task_manager_app/data/models/task_status_count_row.dart';
import 'package:task_manager_app/data/models/task_status_model.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/screens/add_new_screen.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';
import 'package:task_manager_app/ui/widgets/task_card.dart';
import 'package:task_manager_app/ui/widgets/task_summary_card.dart';
import '../../data/models/task_model.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  List<TaskModel> _newTaskList = [];
  List<TaskStatusModel> _taskCountList = [];
  bool inProgress = false;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() => inProgress = true);
    await Future.wait([
      _getNewTaskList(),
      _getListCount(),
    ]);
    setState(() => inProgress = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapFAB,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: RefreshIndicator(
          onRefresh: () async {
            _refreshData();
          },
          child: Column(
            children: [
              const SizedBox(height: 8),
              _buildTaskSummary(),
              Expanded(
                child: ListView.builder(
                  itemCount: _newTaskList.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      taskModel: _newTaskList[index],
                      onTapRefresh: _getNewTaskList,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskSummary() {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:[..._taskCountList.map((e){
            return TaskSummaryCard(count: e.sum ?? 0, title: e.sId ?? '');
          })],
        ),
      ),
    );
  }

  void _onTapFAB() async {
    final bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewScreen(),
      ),
    );
    if (shouldRefresh == true) {
      _refreshData();

    }
  }

  Future<void> _getNewTaskList() async {
    _newTaskList.clear();
    inProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.newTaskList,
    );

    if (response.isSuccess) {
      final TaskListModel taskListModel =
      TaskListModel.fromJson(response.responseBody);

      _newTaskList = taskListModel.taskList ?? [];
    } else {
      snackBarMessage(context, response.errorMessage, true);
    }
    inProgress = false;
    setState(() {});
  }

  Future<void> _getListCount() async {
    _taskCountList.clear();
    inProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.taskListCount);
    if (response.isSuccess) {
      final TaskStatusCountRow taskStatusCountRow = TaskStatusCountRow.fromJson(
          response.responseBody);
      _taskCountList = taskStatusCountRow.taskStatus ?? [];
    } else {
      snackBarMessage(context, response.errorMessage, true);
      inProgress = false;
      setState(() {});
    }
  }
}
