part of 'probe_setting_bloc.dart';

sealed class ProbeSettingEvent extends Equatable {
  const ProbeSettingEvent();

  @override
  List<Object> get props => [];
}

class SetValues extends ProbeSettingEvent {
  final bool? temEntryNoti;
  final bool? isNotification;
  final int? delayfirstNoti;
  final int? repeatNoti;
  final bool? isDairyNoti;
  final String? firstDayNoti;
  final TimeOfDay? firstTime;
  final String? secondDayNoti;
  final TimeOfDay?  secondTime;
  final String?  thirdDayNoti;
  final TimeOfDay?  thirdTime;
  
  const SetValues({this.temEntryNoti,this.isNotification,this.delayfirstNoti,this.repeatNoti,this.isDairyNoti,this.firstDayNoti,this.firstTime,this.secondDayNoti,this.secondTime,this.thirdDayNoti,this.thirdTime});

  @override
  List<Object> get props => [temEntryNoti!,isNotification!,delayfirstNoti!,repeatNoti!,isDairyNoti!,firstDayNoti!,firstTime!,secondDayNoti!,secondTime!,thirdDayNoti!,thirdTime!];
}