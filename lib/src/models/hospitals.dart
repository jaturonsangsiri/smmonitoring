class Hospital {
  String? message;
  bool? success;
  List<HospitalData>? data;

  Hospital({this.message, this.success, this.data});

  Hospital.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    if (json['data'] != null) {
      data = <HospitalData>[];
      json['data'].forEach((v) {
        data!.add(HospitalData.fromJson(v));
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

class HospitalData {
  String? id;
  String? hosName;
  String? hosAddress;
  String? hosTel;
  String? userContact;
  String? userTel;
  String? hosLatitude;
  String? hosLongitude;
  String? hosPic;
  String? createAt;
  String? updateAt;
  List<Ward>? ward;

  HospitalData(
      {this.id,
      this.hosName,
      this.hosAddress,
      this.hosTel,
      this.userContact,
      this.userTel,
      this.hosLatitude,
      this.hosLongitude,
      this.hosPic,
      this.createAt,
      this.updateAt,
      this.ward});

  HospitalData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hosName = json['hosName'];
    hosAddress = json['hosAddress'];
    hosTel = json['hosTel'];
    userContact = json['userContact'];
    userTel = json['userTel'];
    hosLatitude = json['hosLatitude'];
    hosLongitude = json['hosLongitude'];
    hosPic = json['hosPic'];
    createAt = json['createAt'];
    updateAt = json['updateAt'];
    if (json['ward'] != null) {
      ward = <Ward>[];
      json['ward'].forEach((v) {
        ward!.add(Ward.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['hosName'] = hosName;
    data['hosAddress'] = hosAddress;
    data['hosTel'] = hosTel;
    data['userContact'] = userContact;
    data['userTel'] = userTel;
    data['hosLatitude'] = hosLatitude;
    data['hosLongitude'] = hosLongitude;
    data['hosPic'] = hosPic;
    data['createAt'] = createAt;
    data['updateAt'] = updateAt;
    if (ward != null) {
      data['ward'] = ward!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ward {
  String? id;
  String? wardName;
  int? wardSeq;
  String? hosId;
  String? type;
  String? createAt;
  String? updateAt;

  Ward({this.id, this.wardName, this.wardSeq, this.hosId, this.type, this.createAt, this.updateAt});

  Ward.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wardName = json['wardName'];
    wardSeq = json['wardSeq'];
    hosId = json['hosId'];
    type = json['type'];
    createAt = json['createAt'];
    updateAt = json['updateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['wardName'] = wardName;
    data['wardSeq'] = wardSeq;
    data['hosId'] = hosId;
    data['type'] = type;
    data['createAt'] = createAt;
    data['updateAt'] = updateAt;
    return data;
  }
}
