class Device {
  DeviceId? data;
  String? message;
  bool? success;

  Device({this.data, this.message, this.success});

  Device.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? DeviceId.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    data['success'] = success;
    return data;
  }
}

class DeviceId {
  String? hospital;
  String? hospitalName;
  String? id;
  String? name;
  bool? online;
  String? position;
  String? staticName;
  bool? status;
  String? ward;
  String? wardName;
  List<Probe>? probe;

  DeviceId({
    this.hospital = "",
    this.hospitalName = "",
    this.id = "",
    this.name = "",
    this.online = false,
    this.position = "",
    this.staticName = "",
    this.status = false,
    this.ward = "",
    this.wardName = "",
    this.probe = const [],
  });

  DeviceId.fromJson(Map<String, dynamic> json) {
    hospital = json['hospital'];
    hospitalName = json['hospitalName'];
    id = json['id'];
    name = json['name'];
    online = json['online'];
    position = json['position'];
    staticName = json['staticName'];
    status = json['status'];
    ward = json['ward'];
    wardName = json['wardName'];
    if (json['probe'] != null) {
      probe = <Probe>[];
      json['probe'].forEach((v) {
        probe!.add(Probe.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hospital'] = hospital;
    data['hospitalName'] = hospitalName;
    data['id'] = id;
    data['name'] = name;
    data['online'] = online;
    data['position'] = position;
    data['staticName'] = staticName;
    data['status'] = status;
    data['ward'] = ward;
    data['wardName'] = wardName;
    if (probe != null) {
      data['probe'] = probe!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Probe {
  String? channel;
  String? doorAlarmTime;
  num? doorQty;
  bool? doorSound;
  String? firstDay;
  String? firstTime;
  num? humiAdj;
  num? humiMax;
  num? humiMin;
  String? id;
  String? muteAlarmDuration;
  String? muteDoorAlarmDuration;
  String? name;
  num? notiDelay;
  bool? notiMobile;
  int? notiRepeat;
  bool? notiToNormal;
  String? position;
  String? secondDay;
  String? secondTime;
  String? sn;
  String? stampTime;
  num? tempAdj;
  num? tempMax;
  num? tempMin;
  String? thirdDay;
  String? thirdTime;
  String? type;

  Probe(
      {this.channel,
      this.doorAlarmTime,
      this.doorQty,
      this.doorSound,
      this.firstDay,
      this.firstTime,
      this.humiAdj,
      this.humiMax,
      this.humiMin,
      this.id,
      this.muteAlarmDuration,
      this.muteDoorAlarmDuration,
      this.name,
      this.notiDelay,
      this.notiMobile,
      this.notiRepeat,
      this.notiToNormal,
      this.position,
      this.secondDay,
      this.secondTime,
      this.sn,
      this.stampTime,
      this.tempAdj,
      this.tempMax,
      this.tempMin,
      this.thirdDay,
      this.thirdTime,
      this.type});

  Probe.fromJson(Map<String, dynamic> json) {
    channel = json['channel'];
    doorAlarmTime = json['doorAlarmTime'];
    doorQty = json['doorQty'];
    doorSound = json['doorSound'];
    firstDay = json['firstDay'];
    firstTime = json['firstTime'];
    humiAdj = json['humiAdj'];
    humiMax = json['humiMax'];
    humiMin = json['humiMin'];
    id = json['id'];
    muteAlarmDuration = json['muteAlarmDuration'];
    muteDoorAlarmDuration = json['muteDoorAlarmDuration'];
    name = json['name'];
    notiDelay = json['notiDelay'];
    notiMobile = json['notiMobile'];
    notiRepeat = json['notiRepeat'];
    notiToNormal = json['notiToNormal'];
    position = json['position'];
    secondDay = json['secondDay'];
    secondTime = json['secondTime'];
    sn = json['sn'];
    stampTime = json['stampTime'];
    tempAdj = json['tempAdj'];
    tempMax = json['tempMax'];
    tempMin = json['tempMin'];
    thirdDay = json['thirdDay'];
    thirdTime = json['thirdTime'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['channel'] = channel;
    data['doorAlarmTime'] = doorAlarmTime;
    data['doorQty'] = doorQty;
    data['doorSound'] = doorSound;
    data['firstDay'] = firstDay;
    data['firstTime'] = firstTime;
    data['humiAdj'] = humiAdj;
    data['humiMax'] = humiMax;
    data['humiMin'] = humiMin;
    data['id'] = id;
    data['muteAlarmDuration'] = muteAlarmDuration;
    data['muteDoorAlarmDuration'] = muteDoorAlarmDuration;
    data['name'] = name;
    data['notiDelay'] = notiDelay;
    data['notiMobile'] = notiMobile;
    data['notiRepeat'] = notiRepeat;
    data['notiToNormal'] = notiToNormal;
    data['position'] = position;
    data['secondDay'] = secondDay;
    data['secondTime'] = secondTime;
    data['sn'] = sn;
    data['stampTime'] = stampTime;
    data['tempAdj'] = tempAdj;
    data['tempMax'] = tempMax;
    data['tempMin'] = tempMin;
    data['thirdDay'] = thirdDay;
    data['thirdTime'] = thirdTime;
    data['type'] = type;
    return data;
  }

  Map<String, dynamic> toPayloadJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstDay'] = firstDay;
    data['firstTime'] = firstTime;
    data['secondDay'] = secondDay;
    data['secondTime'] = secondTime;
    data['thirdDay'] = thirdDay;
    data['thirdTime'] = thirdTime;
    data['notiDelay'] = notiDelay;
    data['notiMobile'] = notiMobile;
    data['notiRepeat'] = notiRepeat;
    data['notiToNormal'] = notiToNormal;
    return data;
  }
}
