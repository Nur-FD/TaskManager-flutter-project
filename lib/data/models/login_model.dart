class LoginModel {
  String? status;
  String? token;
  UserData? data;

  LoginModel({this.status, this.token, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    token = json["token"];
    data = json["data"] == null ? null : UserData.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["token"] = token;
    if (data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
  }

  LoginModel copyWith({
    String? status,
    String? token,
    UserData? data,
  }) =>
      LoginModel(
        status: status ?? this.status,
        token: token ?? this.token,
        data: data ?? this.data,
      );
}

class UserData {
  String? email;
  String? firstName;
  String? lastName;
  String? mobile;
  String? photo;

  UserData({this.email, this.firstName, this.lastName, this.mobile, this.photo});

  UserData.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    firstName = json["firstName"];
    lastName = json["lastName"];
    mobile = json["mobile"];
    photo = json["photo"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["email"] = email;
    _data["firstName"] = firstName;
    _data["lastName"] = lastName;
    _data["mobile"] = mobile;
    _data["photo"] = photo;
    return _data;
  }

  UserData copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? mobile,
    String? photo,
  }) =>
      UserData(
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        mobile: mobile ?? this.mobile,
        photo: photo ?? this.photo,
      );
}
