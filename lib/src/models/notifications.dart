class Notifications {
  String? message;
  bool? success;
  List<NotiList>? data;

  Notifications({this.message, this.success, this.data});

  Notifications.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    if (json['data'] != null) {
      data = <NotiList>[];
      json['data'].forEach((v) {
        data!.add(NotiList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotiList {
  String? id;
  String? serial;
  String? message;
  String? detail;
  bool? status;
  String? createAt;
  String? updateAt;
  NotiDevice? device;

  NotiList({this.id, this.serial, this.message, this.detail, this.status, this.createAt, this.updateAt, this.device});

  NotiList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serial = json['serial'];
    message = json['message'];
    detail = json['detail'];
    status = json['status'];
    createAt = json['createAt'];
    updateAt = json['updateAt'];
    device = json['device'] != null ? NotiDevice.fromJson(json['device']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['serial'] = serial;
    data['message'] = message;
    data['detail'] = detail;
    data['status'] = status;
    data['createAt'] = createAt;
    data['updateAt'] = updateAt;
    if (device != null) {
      data['device'] = device!.toJson();
    }
    return data;
  }
}

class NotiDevice {
  String? name;
  String? hospital;
  String? ward;

  NotiDevice({this.name, this.hospital, this.ward});

  NotiDevice.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    hospital = json['hospital'];
    ward = json['ward'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['hospital'] = hospital;
    data['ward'] = ward;
    return data;
  }
}
