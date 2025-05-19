import 'package:smmonitoring/src/bloc/probe/probe_setting_bloc.dart';
import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/constants/contants.dart';
import 'package:smmonitoring/src/models/devices.dart';
import 'package:smmonitoring/src/widgets/probe_setting/setting_sub_widget.dart';
import 'package:smmonitoring/src/widgets/system_widget_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportSetting extends StatefulWidget {
  final Probe probe;
  const ReportSetting({super.key, required this.probe});

  @override
  State<ReportSetting> createState() => _ReportSettingState();
}

class _ReportSettingState extends State<ReportSetting> {
  // เลือกตัวเวลา
  Future<TimeOfDay?> _selectTime(BuildContext context, TimeOfDay time) async {
    DateTime now = DateTime.now();
    DateTime selectedDateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);

    return await showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) => Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: themeState.themeApp? boxColorDark : Colors.white,
            child: SizedBox(
              height: 300,
              child: Column(
                children: [
                  Padding(padding: const EdgeInsets.all(16), child: Text("เลือกเวลา", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: themeState.themeApp? Colors.white : Colors.black87))),
                  Expanded(
                    child: CupertinoTheme(
                      data: CupertinoThemeData(brightness: themeState.themeApp ? Brightness.dark : Brightness.light),
                      child: DefaultTextStyle(
                        style: TextStyle(color: themeState.themeApp ? Colors.white : Colors.black87, fontSize: 22),
                        child: CupertinoTimerPicker(
                          mode: CupertinoTimerPickerMode.hm,
                          initialTimerDuration: Duration(hours: selectedDateTime.hour, minutes: selectedDateTime.minute),
                          minuteInterval: 10,
                          onTimerDurationChanged: (Duration newDuration) => selectedDateTime = DateTime(now.year, now.month, now.day, newDuration.inHours, newDuration.inMinutes % 60),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(child: Text("ยกเลิก", style: TextStyle(color: themeState.themeApp? Colors.white : Colors.black87)), onPressed: () => Navigator.of(context).pop(null)),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: secColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        child: const Text("ตกลง", style: TextStyle(color: Colors.white)),
                        onPressed: () => Navigator.of(context).pop(TimeOfDay(hour: selectedDateTime.hour, minute: selectedDateTime.minute)),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void setValue() {
    context.read<ProbeSettingBloc>().add(
      SetValues(
        isDairyNoti: widget.probe.firstDay == 'ALL'? true : false, 
        firstDayNoti: widget.probe.firstDay, 
        secondDayNoti: widget.probe.secondDay, 
        thirdDayNoti: widget.probe.thirdDay, 
        firstTime: TimeOfDay(hour: int.parse(widget.probe.firstTime!.substring(0, 2)), minute: int.parse(widget.probe.firstTime!.substring(2))), 
        secondTime: TimeOfDay(hour: int.parse(widget.probe.secondTime!.substring(0, 2)), minute: int.parse(widget.probe.secondTime!.substring(2))), 
        thirdTime: TimeOfDay(hour: int.parse(widget.probe.thirdTime!.substring(0, 2)), minute: int.parse(widget.probe.thirdTime!.substring(2)))
      )
    );
  }

  @override
  void initState() {
    setValue();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    SettingSubWidget settingSubWidget = SettingSubWidget();
    // วันที่เลือกแจ้งเตือนได้
    List<String> days = ['MON','TUE','WED','THU','FRI','SAT','SUN','OFF'];
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<ProbeSettingBloc, ProbeSettingState>(
          builder: (context, state) {
            return settingSubWidget.buildSettingCard([
              // ตั้งค่ารีพอร์ตอัตโนมัติ
              settingSubWidget.buildMainTitle('📄 ตั้งค่ารีพอร์ตอัตโนมัติ'),
              settingSubWidget.buildRowSetting(
                icon: Icons.thermostat, 
                title: 'แจ้งเตือนทุกวันหรือไม่', 
                trailing: CustomSwitch(
                  value: state.isDairyNoti, 
                  onChanged: (value) {
                    context.read<ProbeSettingBloc>().add(SetValues(isDairyNoti: value));
                    if(value) {
                      state.firstDayNoti = 'ALL';
                      state.secondDayNoti = 'ALL';
                      state.thirdDayNoti = 'ALL';
                    } else {
                      state.firstDayNoti = 'MON';
                      state.secondDayNoti = 'TUE';
                      state.thirdDayNoti = 'FRI';
                    }
                  },
                  inactiveColor: Colors.grey.shade400,
                  thumbColor: Colors.white,
                  activeColor: threeColor,
                )
              ),
              settingSubWidget.buildRowSetting(
                icon: Icons.thermostat, 
                title: 'วันแรกที่แจ้งเตือน', 
                trailing: state.firstDayNoti == 'ALL'? Padding(padding: const EdgeInsets.only(top: 12.5,bottom: 12.5,right: 15), child: Text('ALL', style: TextStyle(fontSize: 16, color: themeState.themeApp? Colors.white : secColor,fontWeight: FontWeight.w500))) : dropDownWidget(context, state.firstDayNoti, days, (String? newValue) => context.read<ProbeSettingBloc>().add(SetValues(firstDayNoti: newValue)), themeState)
              ),
              settingSubWidget.buildRowSetting(
                icon: Icons.thermostat, 
                title: 'วันที่สองที่แจ้งเตือน', 
                trailing: state.secondDayNoti == 'ALL'? Padding(padding: const EdgeInsets.only(top: 12.5,bottom: 12.5,right: 15), child: Text('ALL', style: TextStyle(fontSize: 16, color: themeState.themeApp? Colors.white : secColor,fontWeight: FontWeight.w500))) : dropDownWidget(context, state.secondDayNoti, days, (String? newValue) => context.read<ProbeSettingBloc>().add(SetValues(secondDayNoti: newValue)), themeState)
              ),
              settingSubWidget.buildRowSetting(
                icon: Icons.thermostat, 
                title: 'วันที่สามที่แจ้งเตือน', 
                trailing: state.thirdDayNoti == 'ALL'? Padding(padding: const EdgeInsets.only(top: 12.5,bottom: 12.5,right: 15), child: Text('ALL', style: TextStyle(fontSize: 16, color: themeState.themeApp? Colors.white : secColor,fontWeight: FontWeight.w500))) : dropDownWidget(context, state.thirdDayNoti, days, (String? newValue) => context.read<ProbeSettingBloc>().add(SetValues(thirdDayNoti: newValue)), themeState)
              ),

              // ตัวตั้งค่าเวลา
              settingSubWidget.buildSubTitle('ตั้งค่าเวลา'),
              settingSubWidget.buildRowSetting(
                icon: Icons.timer, 
                title: 'แจ้งเวลาที่หนึ่ง', 
                trailing: GestureDetector(
                  onTap: () async {
                    // ตัวเลือกเวลาเก็บในตัวแปร
                    final TimeOfDay? picked = await _selectTime(context, state.firstTime);

                    // เปลี่ยนแปลงเวลา
                    context.read<ProbeSettingBloc>().add(SetValues(firstTime: picked));
                  },
                  child: Row(
                    children: [
                      Text('${state.firstTime.hour.toString().padLeft(2, '0')}.${state.firstTime.minute.toString().padLeft(2, '0')} น.', style: TextStyle(color: themeState.themeApp? Colors.white : secColor, fontWeight: FontWeight.w500)),
                      Icon(Icons.arrow_drop_down, color: themeState.themeApp? Colors.white : secColor),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              settingSubWidget.buildRowSetting(
                icon: Icons.timer, 
                title: 'แจ้งเวลาที่สอง', 
                trailing: GestureDetector(
                  onTap: () async {
                    // ตัวเลือกเวลาเก็บในตัวแปร
                    final TimeOfDay? picked = await _selectTime(context, state.secondTime);

                    // เปลี่ยนแปลงเวลา
                    context.read<ProbeSettingBloc>().add(SetValues(secondTime: picked));
                  },
                  child: Row(
                    children: [
                      Text('${state.secondTime.hour.toString().padLeft(2, '0')}.${state.secondTime.minute.toString().padLeft(2, '0')} น.', style: TextStyle(color: themeState.themeApp? Colors.white : secColor, fontWeight: FontWeight.w500)),
                      Icon(Icons.arrow_drop_down, color: themeState.themeApp? Colors.white : secColor),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              settingSubWidget.buildRowSetting(
                icon: Icons.timer, 
                title: 'แจ้งเวลาที่สาม', 
                trailing: GestureDetector(
                  onTap: () async {
                    // ตัวเลือกเวลาเก็บในตัวแปร
                    final TimeOfDay? picked = await _selectTime(context, state.thirdTime);

                    // เปลี่ยนแปลงเวลา
                    context.read<ProbeSettingBloc>().add(SetValues(thirdTime: picked));
                  },
                  child: Row(
                    children: [
                      Text('${state.thirdTime.hour.toString().padLeft(2, '0')}.${state.thirdTime.minute.toString().padLeft(2, '0')} น.', style: TextStyle(color: themeState.themeApp? Colors.white : secColor, fontWeight: FontWeight.w500)),
                      Icon(Icons.arrow_drop_down, color: themeState.themeApp? Colors.white : secColor),
                    ],
                  ),
                ),
              ),
            ]);
          },
        );
      },
    );
  }

  // Dropdown Widget
  Widget dropDownWidget(BuildContext context, String value, List values, ValueChanged<String?>? function, ThemeState themeState) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        items: values.map((v) {
          return DropdownMenuItem<String>(
            value: v,
            child: Text(v.toString(), style: TextStyle(color: themeState.themeApp? Colors.white : secColor,fontWeight: FontWeight.w500)),
          );
        }).toList(),
        onChanged: function,
        dropdownColor: themeState.themeApp? boxColorDark : Colors.white,
        icon: Icon(Icons.arrow_drop_down_outlined,color: themeState.themeApp? Colors.white : secColor),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}