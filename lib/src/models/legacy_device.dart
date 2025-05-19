class DeviceLegacy {
  List<DeviceLegacyList>? data;
  String? message;
  bool? success;

  DeviceLegacy({this.data, this.message, this.success});

  DeviceLegacy.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DeviceLegacyList>[];
      json['data'].forEach((v) {
        data!.add(DeviceLegacyList.fromJson(v));
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

class DeviceLegacyList {
  String? hospital;
  String? id;
  List<Log>? log;
  String? name;
  String? sn;
  String? ward;

  DeviceLegacyList({
    this.hospital,
    this.id,
    this.log,
    this.name,
    this.sn,
    this.ward,
  });

  DeviceLegacyList.fromJson(Map<String, dynamic> json) {
    hospital = json['hospital'];
    id = json['id'];
    if (json['log'] != null) {
      log = <Log>[];
      json['log'].forEach((v) {
        log!.add(Log.fromJson(v));
      });
    }
    name = json['name'];
    sn = json['sn'];
    ward = json['ward'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hospital'] = hospital;
    data['id'] = id;
    if (log != null) {
      data['log'] = log!.map((v) => v.toJson()).toList();
    }
    data['name'] = name;
    data['sn'] = sn;
    data['ward'] = ward;
    return data;
  }
}

class Log {
  String? createdAt;
  String? date;
  bool? door;
  String? id;
  bool? internet;
  bool? isAlert;
  String? mcuId;
  String? message;
  bool? plugin;
  String? probe;
  num? realValue;
  num? tempValue;
  String? time;
  String? updatedAt;

  Log({
    this.createdAt,
    this.date,
    this.door,
    this.id,
    this.internet,
    this.isAlert,
    this.mcuId,
    this.message,
    this.plugin,
    this.probe,
    this.realValue,
    this.tempValue,
    this.time,
    this.updatedAt,
  });

  Log.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    date = json['date'];
    door = json['door'];
    id = json['id'];
    internet = json['internet'];
    isAlert = json['isAlert'];
    mcuId = json['mcuId'];
    message = json['message'];
    plugin = json['plugin'];
    probe = json['probe'];
    realValue = json['realValue'];
    tempValue = json['tempValue'];
    time = json['time'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['date'] = date;
    data['door'] = door;
    data['id'] = id;
    data['internet'] = internet;
    data['isAlert'] = isAlert;
    data['mcuId'] = mcuId;
    data['message'] = message;
    data['plugin'] = plugin;
    data['probe'] = probe;
    data['realValue'] = realValue;
    data['tempValue'] = tempValue;
    data['time'] = time;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
