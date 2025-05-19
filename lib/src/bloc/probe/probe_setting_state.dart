part of 'probe_setting_bloc.dart';

class ProbeSettingState extends Equatable {
  // แจ้งอุณหภูมิกลับช่วงเข้า
  final bool temEntryNoti;
  // การแจ้งเตือน
  final bool isNotification;
  // หน่วงการแจ้งเตือนครั้งแรก
  final int delayfirstNoti;
  // แจ้งเตือนซ้ำ (ทุกกี่นาที)
  final int repeatNoti;
  // แจ้งเตือนทุกวัน หรือไม่?
  bool isDairyNoti;
  // แจ้งเตือนที่วันที่ 1
  String firstDayNoti; 
  // เวลาเริ่มต้นช่วงที่ 1
  TimeOfDay firstTime;
  // แจ้งเตือนที่วันที่ 2
  String secondDayNoti;
  // เวลาเริ่มต้นช่วงที่ 2
  TimeOfDay secondTime;
  // แจ้งเตือนที่วันที่ 3
  String thirdDayNoti;
  // เวลาเริ่มต้นช่วงที่ 3
  TimeOfDay thirdTime;

  ProbeSettingState({
    this.temEntryNoti = true, 
    this.isNotification = true,
    this.delayfirstNoti = 0,
    this.repeatNoti = 0,
    this.isDairyNoti = true,
    this.firstDayNoti = 'MON',
    this.firstTime = const TimeOfDay(hour: 8, minute: 0),
    this.secondDayNoti = 'TUE',
    this.secondTime = const TimeOfDay(hour: 12, minute: 0),
    this.thirdDayNoti = 'FRI',
    this.thirdTime = const TimeOfDay(hour: 17, minute: 0)
  });

  ProbeSettingState copyWith({bool? temEntryNoti, bool? isNotification, int? delayfirstNoti, int? repeatNoti,bool? isDairyNoti,String? firstDayNoti,TimeOfDay? firstTime,String? secondDayNoti,TimeOfDay? secondTime,String? thirdDayNoti,TimeOfDay? thirdTime}) {
    return ProbeSettingState(
      temEntryNoti: temEntryNoti ?? true, 
      isNotification: isNotification ?? true,
      delayfirstNoti: delayfirstNoti ?? 0,  
      repeatNoti: repeatNoti ?? 0,
      isDairyNoti: isDairyNoti ?? true,
      firstDayNoti: firstDayNoti ?? 'MON',
      firstTime: firstTime ?? const TimeOfDay(hour: 8, minute: 0),
      secondDayNoti: secondDayNoti ?? 'TUE',
      secondTime: secondTime ?? TimeOfDay(hour: 12, minute: 0),
      thirdDayNoti: thirdDayNoti ?? 'FRI',
      thirdTime: thirdTime ?? const TimeOfDay(hour: 17, minute: 0)
    );
  }

  @override
  List<Object> get props => [temEntryNoti, isNotification, delayfirstNoti, repeatNoti, isDairyNoti, firstDayNoti, firstTime, secondDayNoti, secondTime, thirdDayNoti, thirdTime];
}
