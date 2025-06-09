class MobileLog {
  List<DeviceInfo>? data;
  String? message;
  bool? success;

  MobileLog({this.data, this.message, this.success});

  MobileLog.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DeviceInfo>[];
      json['data'].forEach((v) {
        data!.add(DeviceInfo.fromJson(v));
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

class DeviceInfo {
  String? hospital;
  List<LogInfo>? log;
  String? name;
  List<NotificationInfo>? notification;
  bool? online;
  String? position;
  String? positionPic;
  String? serial;
  String? ward;

  DeviceInfo({this.hospital, this.log, this.name, this.notification, this.online, this.serial, this.ward, this.position, this.positionPic});

  DeviceInfo.fromJson(Map<String, dynamic> json) {
    hospital = json['hospital'];
    if (json['log'] != null) {
      log = <LogInfo>[];
      json['log'].forEach((v) {
        log!.add(LogInfo.fromJson(v));
      });
    }
    name = json['name'];
    if (json['notification'] != null) {
      notification = <NotificationInfo>[];
      json['notification'].forEach((v) {
        notification!.add(NotificationInfo.fromJson(v));
      });
    }
    online = json['online'];
    serial = json['serial'];
    ward = json['ward'];
    position = json['position'];
    positionPic = json['positionPic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hospital'] = hospital;
    if (log != null) {
      data['log'] = log!.map((v) => v.toJson()).toList();
    }
    data['name'] = name;
    if (notification != null) {
      data['notification'] = notification!.map((v) => v.toJson()).toList();
    }
    data['online'] = online;
    data['serial'] = serial;
    data['ward'] = ward;
    return data;
  }
}

class LogInfo {
  int? battery;
  String? createAt;
  bool? door1;
  bool? door2;
  bool? door3;
  bool? extMemory;
  num? humidity;
  num? humidityDisplay;
  String? id;
  bool? internet;
  bool? plug;
  String? probe;
  String? sendTime;
  String? serial;
  num? temp;
  num? tempDisplay;
  num? tempInternal;
  String? updateAt;

  LogInfo(
      {this.battery,
      this.createAt,
      this.door1,
      this.door2,
      this.door3,
      this.extMemory,
      this.humidity,
      this.humidityDisplay,
      this.id,
      this.internet,
      this.plug,
      this.probe,
      this.sendTime,
      this.serial,
      this.temp,
      this.tempDisplay,
      this.tempInternal,
      this.updateAt});

  LogInfo.fromJson(Map<String, dynamic> json) {
    battery = json['battery'];
    createAt = json['createAt'];
    door1 = json['door1'];
    door2 = json['door2'];
    door3 = json['door3'];
    extMemory = json['extMemory'];
    humidity = json['humidity'];
    humidityDisplay = json['humidityDisplay'];
    id = json['id'];
    internet = json['internet'];
    plug = json['plug'];
    probe = json['probe'];
    sendTime = json['sendTime'];
    serial = json['serial'];
    temp = json['temp'];
    tempDisplay = json['tempDisplay'];
    tempInternal = json['tempInternal'];
    updateAt = json['updateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['battery'] = battery;
    data['createAt'] = createAt;
    data['door1'] = door1;
    data['door2'] = door2;
    data['door3'] = door3;
    data['extMemory'] = extMemory;
    data['humidity'] = humidity;
    data['humidityDisplay'] = humidityDisplay;
    data['id'] = id;
    data['internet'] = internet;
    data['plug'] = plug;
    data['probe'] = probe;
    data['sendTime'] = sendTime;
    data['serial'] = serial;
    data['temp'] = temp;
    data['tempDisplay'] = tempDisplay;
    data['tempInternal'] = tempInternal;
    data['updateAt'] = updateAt;
    return data;
  }
}

class NotificationInfo {
  String? createAt;
  String? detail;
  String? id;
  String? message;
  String? serial;
  bool? status;
  String? updateAt;

  NotificationInfo({this.createAt, this.detail, this.id, this.message, this.serial, this.status, this.updateAt});

  NotificationInfo.fromJson(Map<String, dynamic> json) {
    createAt = json['createAt'];
    detail = json['detail'];
    id = json['id'];
    message = json['message'];
    serial = json['serial'];
    status = json['status'];
    updateAt = json['updateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createAt'] = createAt;
    data['detail'] = detail;
    data['id'] = id;
    data['message'] = message;
    data['serial'] = serial;
    data['status'] = status;
    data['updateAt'] = updateAt;
    return data;
  }
}

class Notification {
  String? createAt;
  String? detail;
  String? id;
  String? message;
  String? serial;
  bool? status;
  String? updateAt;

  Notification({this.createAt, this.detail, this.id, this.message, this.serial, this.status, this.updateAt});

  Notification.fromJson(Map<String, dynamic> json) {
    createAt = json['createAt'];
    detail = json['detail'];
    id = json['id'];
    message = json['message'];
    serial = json['serial'];
    status = json['status'];
    updateAt = json['updateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createAt'] = createAt;
    data['detail'] = detail;
    data['id'] = id;
    data['message'] = message;
    data['serial'] = serial;
    data['status'] = status;
    data['updateAt'] = updateAt;
    return data;
  }
}
