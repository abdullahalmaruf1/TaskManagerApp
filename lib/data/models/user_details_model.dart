import 'package:task_manager_app/data/models/user_details.dart';

class UserDetailsModel {
  String? status;
  List<UserDetails>? data;

  UserDetailsModel({this.status, this.data});

  UserDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <UserDetails>[];
      json['data'].forEach((v) {
        data!.add(UserDetails.fromJson(v));
      });
    }
  }
}

