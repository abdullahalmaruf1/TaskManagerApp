import 'package:task_manager_app/data/models/task_status_model.dart';

class TaskStatusCountRow {
  String? status;
  List<TaskStatusModel>? taskStatus;

  TaskStatusCountRow({this.status, this.taskStatus});

  TaskStatusCountRow.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      taskStatus = <TaskStatusModel>[];
      json['data'].forEach((v) {
        taskStatus!.add(TaskStatusModel.fromJson(v));
      });
    }
  }
}

