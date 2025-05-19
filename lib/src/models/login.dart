class Login {
  String? message;
  bool? success;
  Data? data;

  Login({required this.message, required this.success, this.data});

  Login.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    data = (json['data'] != null ? Data.fromJson(json['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['success'] = success;
    data['data'] = this.data?.toJson();
    return data;
  }
}

class Data {
  String? token;
  String? refreshToken;
  String? id;
  String? hosId;
  String? wardId;
  String? role;
  String? name;
  String? pic;

  Data(
      {required this.token,
      required this.refreshToken,
      required this.id,
      required this.hosId,
      required this.wardId,
      required this.role,
      required this.name,
      required this.pic});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    refreshToken = json['refreshToken'];
    id = json['id'];
    hosId = json['hosId'];
    wardId = json['wardId'];
    role = json['role'];
    name = json['name'];
    pic = json['pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['refreshToken'] = refreshToken;
    data['id'] = id;
    data['hosId'] = hosId;
    data['wardId'] = wardId;
    data['role'] = role;
    data['name'] = name;
    data['pic'] = pic;
    return data;
  }
}
