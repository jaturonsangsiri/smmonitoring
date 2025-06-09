import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/constants/contants.dart';
import 'package:smmonitoring/src/services/preference.dart';
import 'package:smmonitoring/src/widgets/appbar.dart';
import 'package:smmonitoring/src/widgets/system_widget_custom.dart';
import 'package:flutter/material.dart';
import 'package:smmonitoring/src/widgets/utils/responsive.dart';

class NotificationSettingsPage extends StatefulWidget {
  final int newWard;
  final int legacyWard;
  const NotificationSettingsPage({super.key, required this.newWard, required this.legacyWard});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  // ลิสต์การตั้งค่าการแจ้งเตือน
  List<Map> settings = [];
  BarCustom barCustom = BarCustom();
  final configStorage = ConfigStorage();
  bool notification = false, door = false, legacy = false;
  String role = "";

  void checlkRole() {
    if (widget.newWard > 0 && widget.legacyWard > 0) {
      settings = [{"title": "การแจ้งเตือนอุณหภูมิ","value": notification},{"title": "การแจ้งเตือนประตู","value": door},{"title": "การแจ้งเตือนระบบ Line","value": legacy}];
    } else {
      if (widget.newWard > 0) {
        settings = [{"title": "การแจ้งเตือนอุณหภูมิ","value": notification},{"title": "การแจ้งเตือนประตู","value": door}];
      } else {
        settings = [{"title": "การแจ้งเตือนระบบ Line","value": legacy}];
      }
    }
  }

  // ดึงค่าการตั้งค่าการแจ้งเตือน
  Future<void> loadingNotificationSettings() async {
    setState(() => settings = []);
    notification = await configStorage.getNotificationStatus() ?? false;
    door = await configStorage.getDoorStatus() ?? false;
    legacy = await configStorage.getLegacyStatus() ?? false;
    role = await configStorage.getRole() ?? "";

    switch (role) {
      case "SERVICE":
        settings = [{"title": "การแจ้งเตือนอุณหภูมิ","value": notification},{"title": "การแจ้งเตือนประตู","value": door},{"title": "การแจ้งเตือนระบบ Line","value": legacy}];
        break;
      case "ADMIN":
        checlkRole();
        break;
      case "LEGACY_ADMIN":
        checlkRole();
        break;
      case "USER":
        settings = [{"title": "การแจ้งเตือนอุณหภูมิ","value": notification},{"title": "การแจ้งเตือนประตู","value": door}];
        break;
      case "LEGACY_USER":
        settings = [{"title": "การแจ้งเตือนระบบ Line","value": legacy}];
        break;
      default:
        settings = [{"title": "การแจ้งเตือนอุณหภูมิ","value": notification},{"title": "การแจ้งเตือนประตู","value": door},{"title": "การแจ้งเตือนระบบ Line","value": legacy}];
        break;
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadingNotificationSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: barCustom.appBarCustomNoTabs(context, 'ตั้งค่าการแจ้งเตือน', null),
      body: settings.isEmpty? Center(child: Text('ไม่มีข้อมูล'),) : ListView.separated(
        itemCount: settings.length,
        itemBuilder: (context, index) => buildNotificationSetting(settings[index]),
        separatorBuilder: (context, index) => Divider(color: Colors.grey[300], thickness: 0),
      ),
    );
  }

  // widget สำหรับการสร้างการตั้งค่าการแจ้งเตือน
  Widget buildNotificationSetting(Map setting) {
    return ListTile(
      title: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return Text(setting['title'], style: Responsive.isTablet ? Theme.of(context).textTheme.titleLarge!.copyWith(color: themeState.themeApp ? Colors.white70 : Colors.black) : Theme.of(context).textTheme.bodyLarge);
        },
      ),
      trailing: CustomSwitch(
        value: setting['value'],
        onChanged: (val) async {
          if(setting['title'] == "การแจ้งเตือนอุณหภูมิ") {
            await configStorage.setNotification(val);
          } else if(setting['title'] == "การแจ้งเตือนประตู") {
            await configStorage.setDoorNotification(val);
          } else {
            await configStorage.setLegacyNotification(val);
          }

          await loadingNotificationSettings(); // โหลดค่าล่าสุด
        },
        inactiveColor: Colors.grey.shade400,  
        thumbColor: Colors.white,
        activeColor: threeColor,
      ),
    );
  }
}