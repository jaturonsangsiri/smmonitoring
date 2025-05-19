class Temp {
  double? temp;
  double? humi;

  Temp({this.temp, this.humi});

  Temp.fromJson(Map<String, dynamic> json) {
    temp = json['temp'];
    humi = json['humi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['temp'] = temp;
    data['humi'] = humi;
    return data;
  }
}
