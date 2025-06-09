class User {
  String? message;
  bool? success;
  UserData? data;

  User({this.message, this.success, this.data});

  User.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserData {
  String? id;
  String? wardId;
  String? username;
  bool? status;
  String? role;
  String? display;
  String? pic;
  WardInfo? ward;

  UserData({
    this.id,
    this.wardId,
    this.username,
    this.status,
    this.role,
    this.display,
    this.pic,
    this.ward,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wardId = json['wardId'];
    username = json['username'];
    status = json['status'];
    role = json['role'];
    display = json['display'];
    pic = json['pic'];
    ward = json['ward'] != null ? WardInfo.fromJson(json['ward']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['wardId'] = wardId;
    data['username'] = username;
    data['status'] = status;
    data['role'] = role;
    data['display'] = display;
    data['pic'] = pic;
    if (ward != null) {
      data['ward'] = ward!.toJson();
    }
    return data;
  }

  Map<String, dynamic> toJsonDisplayname() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['display'] = display;
    return data;
  }

  Map<String, dynamic> toJsonDisble() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    return data;
  }
}

class WardInfo {
  String? wardName;
  String? type;
  String? hosId;

  WardInfo({this.wardName, this.hosId, this.type});

  WardInfo.fromJson(Map<String, dynamic> json) {
    wardName = json['wardName'];
    type = json['type'];
    hosId = json['hosId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wardName'] = wardName;
    data['type'] = type;
    data['hosId'] = hosId;
    return data;
  }
}

class ChangePassword {
  String? oldPassword;
  String? password;

  ChangePassword({this.oldPassword, this.password});

  ChangePassword.fromJson(Map<String, dynamic> json) {
    oldPassword = json['oldPassword'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oldPassword'] = oldPassword;
    data['password'] = password;
    return data;
  }
}
