class User {
  String? userid;
  String? useremail;
  String? username;
  String? userpassword;
  String? status;
  String? userdatereg;

  User(
      {this.userid,
      this.useremail,
      this.username,
      this.userpassword,
      this.status,
      this.userdatereg});

  User.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    useremail = json['useremail'];
    username = json['username'];
    userpassword = json['userpassword'];
    status = json['status'];
    userdatereg = json['userdatereg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userid'] = userid;
    data['useremail'] = useremail;
    data['username'] = username;
    data['userpassword'] = userpassword;
    data['status'] = status;
    data['userdatereg'] = userdatereg;
    return data;
  }
}
