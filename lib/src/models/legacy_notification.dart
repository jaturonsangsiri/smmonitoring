class LegacyNotification {
  List<LegacyNotificationList>? data;
  String? message;
  bool? success;

  LegacyNotification({this.data, this.message, this.success});

  LegacyNotification.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <LegacyNotificationList>[];
      json['data'].forEach((v) {
        data!.add(LegacyNotificationList.fromJson(v));
      });
    }
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['success'] = success;
    return data;
  }
}

class LegacyNotificationList {
  String? createdAt;
  LegacyDevice? device;
  String? mcuId;
  String? message;
  String? probe;

  LegacyNotificationList({this.createdAt, this.mcuId, this.message, this.probe, this.device});

  LegacyNotificationList.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    device = json['device'] != null ? LegacyDevice.fromJson(json['device']) : null;
    mcuId = json['mcuId'];
    message = json['message'];
    probe = json['probe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    if (device != null) {
      data['device'] = device!.toJson();
    }
    data['mcuId'] = mcuId;
    data['message'] = message;
    data['probe'] = probe;
    return data;
  }
}

class LegacyDevice {
  String? hospitalName;
  String? name;
  String? wardName;

  LegacyDevice({this.hospitalName, this.name, this.wardName});

  LegacyDevice.fromJson(Map<String, dynamic> json) {
    hospitalName = json['hospitalName'];
    name = json['name'];
    wardName = json['wardName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hospitalName'] = hospitalName;
    data['name'] = name;
    data['wardName'] = wardName;
    return data;
  }
}
