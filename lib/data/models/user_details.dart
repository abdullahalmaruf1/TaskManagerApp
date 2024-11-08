
class UserDetails {
  String? sId;
  String? email;
  String? firstName;
  String? lastName;
  String? mobile;
  String? password;
  String? createdDate;

  UserDetails(
      {this.sId,
        this.email,
        this.firstName,
        this.lastName,
        this.mobile,
        this.password,
        this.createdDate});

  UserDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
    password = json['password'];
    createdDate = json['createdDate'];
  }
}