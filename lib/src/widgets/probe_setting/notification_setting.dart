import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:smmonitoring/src/bloc/probe/probe_setting_bloc.dart';
import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/constants/contants.dart';
import 'package:smmonitoring/src/models/devices.dart';
import 'package:smmonitoring/src/services/services.dart';
import 'package:smmonitoring/src/widgets/probe_setting/setting_sub_widget.dart';
import 'package:smmonitoring/src/widgets/system_widget_custom.dart';
import 'package:smmonitoring/src/widgets/utils/responsive.dart';
import 'package:smmonitoring/src/widgets/utils/snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationSetting extends StatefulWidget {
  final Probe probe;
  const NotificationSetting({super.key, required this.probe});

  @override
  State<NotificationSetting> createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  Api api = Api();

  void setValue() {
    context.read<ProbeSettingBloc>().add(
      SetValues(
        temEntryNoti: widget.probe.notiToNormal, 
        isNotification: widget.probe.notiMobile, 
        delayfirstNoti: int.parse(widget.probe.notiDelay.toString()), 
        repeatNoti: widget.probe.notiRepeat
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
    List<int> mins = [0, 5, 10, 15, 20, 25, 30];
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<ProbeSettingBloc, ProbeSettingState>(
          builder: (context, state) {
            return settingSubWidget.buildSettingCard([
              // ปุ่มเซฟการตั้งค่า Probe
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('🔔 ตั้งค่าการแจ้งเตือน',style: TextStyle(fontSize: Responsive.isTablet ? 24 : 20,fontWeight: FontWeight.bold,color: themeState.themeApp? secColorDarkSub : secColor)),
                  ElevatedButton.icon(
                    onPressed: () async {
                      // print('🔘 เปิดแจ้งเตือน: ${state.isNotification}');
                      // print('🌡 แจ้งอุณหภูมิช่วงเข้า: ${state.temEntryNoti}');
                      // print('🔁 แจ้งเตือนทุกวัน: ${state.isDairyNoti}');
                      // print('🕒 หน่วงการแจ้งครั้งแรก: ${state.delayfirstNoti}');
                      // print('🔄 แจ้งเตือนซ้ำทุก: ${state.repeatNoti}');
                      // print('1️⃣ วัน: ${state.firstDayNoti} ${state.secondDayNoti} ${state.thirdDayNoti}');
                      // print('${state.firstTime.hour.toString().padLeft(2, '0')}${state.firstTime.minute.toString().padLeft(2, '0')} \n${state.secondTime.hour.toString().padLeft(2, '0')}${state.secondTime.minute.toString().padLeft(2, '0')} \n${state.thirdTime.hour.toString().padLeft(2, '0')}${state.thirdTime.minute.toString().padLeft(2, '0')}');
                      
                      final payload = Probe(
                        notiToNormal: state.temEntryNoti,
                        notiMobile: state.isNotification,
                        notiDelay: state.delayfirstNoti,
                        notiRepeat: state.repeatNoti,
                        firstDay: state.firstDayNoti,
                        secondDay: state.secondDayNoti,
                        thirdDay: state.thirdDayNoti,
                        firstTime: "${state.firstTime.hour.toString().padLeft(2,'0')}${state.firstTime.minute.toString().padLeft(2,'0')}",
                        secondTime: "${state.secondTime.hour.toString().padLeft(2,'0')}${state.secondTime.minute.toString().padLeft(2,'0')}",
                        thirdTime: "${state.thirdTime.hour.toString().padLeft(2,'0')}${state.thirdTime.minute.toString().padLeft(2,'0')}",
                      );
                      try {
                        final result = await api.updateProbe(widget.probe.id!, payload);
                        if (result) {
                          if (context.mounted) ShowSnackbar.snackbar(ContentType.success, "บันทึกข้อมูลสำเร็จ", "บันทึกข้อมูลสำเร็จ");
                        }
                      } on Exception catch (e) {
                        if (kDebugMode) print(e);
                        if (context.mounted) ShowSnackbar.snackbar(ContentType.failure, "เกิดข้อผิดพลาด", "ไม่สามารถบันทึกข้อมูลได้");
                      }
                    },
                    icon: const Icon(Icons.save, color: Colors.white, size: 30),
                    label: Text('บันทึก',style: TextStyle(color: Colors.white,fontSize: Responsive.isTablet ? 20 : 16,fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: threeColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      elevation: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              settingSubWidget.buildRowSetting(
                icon: Icons.thermostat,
                title: 'แจ้งอุณหภูมิกลับเข้าช่วง',
                trailing: CustomSwitch(
                  value: state.temEntryNoti,
                  onChanged: (value) => context.read<ProbeSettingBloc>().add(SetValues(temEntryNoti: !state.temEntryNoti)),
                  inactiveColor: Colors.grey.shade400,
                  thumbColor: Colors.white,
                  activeColor: threeColor,
                ),
              ),
              const SizedBox(height: 10),
              settingSubWidget.buildRowSetting(
                icon: Icons.thermostat,
                title: 'การแจ้งเตือน',
                trailing: CustomSwitch(
                  value: state.isNotification,
                  onChanged: (value) => context.read<ProbeSettingBloc>().add(SetValues(isNotification: !state.isNotification)),
                  inactiveColor: Colors.grey.shade400,
                  thumbColor: Colors.white,
                  activeColor: threeColor,
                ),
              ),
              settingSubWidget.buildRowSetting(
                icon: Icons.thermostat,
                title: 'หน่วงการแจ้งเตือนครั้งแรก',
                trailing: dropDownWidget(context, state.delayfirstNoti, mins, (value) => context.read<ProbeSettingBloc>().add(SetValues(delayfirstNoti: value)), themeState)
              ),
              settingSubWidget.buildRowSetting(
                icon: Icons.thermostat,
                title: 'แจ้งเตือนซ้ำ',
                trailing: dropDownWidget(context, state.repeatNoti, mins, (value) => context.read<ProbeSettingBloc>().add(SetValues(repeatNoti: value)), themeState)
              ),
            ]);
          },
        );
      },
    );
  }

  // Dropdown Widget
  Widget dropDownWidget(BuildContext context, int value, List values, ValueChanged<int?>? function, ThemeState themeState) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<int>(
        value: value,
        items: values.map((v) {
          return DropdownMenuItem<int>(
            value: v,
            child: Text(v.toString(), style: TextStyle(color: themeState.themeApp? Colors.white : secColor,fontWeight: FontWeight.w500)),
          );
        }).toList(),
        onChanged: function,
        dropdownColor: themeState.themeApp? boxColorDark : Colors.white,
        icon: Icon(Icons.arrow_drop_down_outlined,color: themeState.themeApp? Colors.white : secColor, size: Responsive.isTablet ? 30 : 25),
        style: TextStyle(fontSize: Responsive.isTablet ? 20 : 16),
      ),
    );
  }
}
