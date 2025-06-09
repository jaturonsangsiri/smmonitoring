import 'package:smmonitoring/src/bloc/device/devices_bloc.dart';
import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/bloc/user/users_bloc.dart';
import 'package:smmonitoring/src/constants/contants.dart';
import 'package:smmonitoring/src/pages/notification_page.dart';
import 'package:smmonitoring/src/pages/profile_page.dart';
import 'package:smmonitoring/src/services/api.dart';
import 'package:smmonitoring/src/services/preference.dart';
import 'package:smmonitoring/src/widgets/icons_style.dart';
import 'package:smmonitoring/src/widgets/system_widget_custom.dart';
import 'package:smmonitoring/src/widgets/utils/responsive.dart';
import 'package:smmonitoring/src/widgets/webview_widget.dart';
import 'package:flutter/material.dart';
import 'package:smmonitoring/src/configs/route.dart' as custom_route;
import 'package:flutter_bloc/flutter_bloc.dart';

// เมนตัวเลือกด้านบนของแอป
// แสดงเมนูต่างๆ ฟันเฟืองการต้งค่า ปุ่มแจ้งเตือน
class OptionsMenubar extends StatefulWidget {
  const OptionsMenubar({super.key, this.selectedItem});
  final CustomPopupMenuItem? selectedItem;

  @override
  State<OptionsMenubar> createState() => _OptionsMenubarState();
}

class _OptionsMenubarState extends State<OptionsMenubar> {
  late CustomPopupMenuItem? _selectedItem;
  Systemwidgetcustom systemwidgetcustom = Systemwidgetcustom();
  final configStorage = ConfigStorage();
  final Api api = Api();

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Row(
          children: [
            CircleIcon(
              icon: Icon(Icons.notifications, color: Colors.white, size: Responsive.isTablet? 35 : 30),
              colorbg: themeState.themeApp? secColor : primaryColor,
              padding: Responsive.isTablet? 15 : 10,
              function: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage(),)),
            ),
            SizedBox(width: Responsive.isTablet ? 20 : 10),
            PopupMenuButton<CustomPopupMenuItem>(
              initialValue: _selectedItem,
              color: themeState.themeApp? const Color.fromARGB(255, 115, 115, 119) : Colors.white,
              constraints: BoxConstraints.tightFor(width: Responsive.isTablet ? 400 : 220, height: Responsive.isTablet ? 220 : 200),
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<CustomPopupMenuItem>>[
                  CustomCustomPopupMenuItem(
                    value: CustomPopupMenuItem(
                      title: 'บัญชีผู้ใช้',
                      icon: Icons.person,
                      // ไปหน้าโปรไฟล์
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                      },
                    ),
                  ),
                  CustomCustomPopupMenuItem(
                    value: CustomPopupMenuItem( 
                      title: 'นโยบายความเป็นส่วนตัว',
                      icon: Icons.privacy_tip,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => WebviewWidget(url: 'https://siamatic.co.th/privacy-policy', title: 'นโยบายความเป็นส่วนตัว'),));
                      },
                    ),
                  ),
                  CustomCustomPopupMenuItem(
                    value: CustomPopupMenuItem(
                      title: 'ข้อกำหนดและเงื่อนไข',
                      icon: Icons.info,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => WebviewWidget(url: 'https://siamatic.co.th/terms-conditions', title: 'ข้อกำหนดและเงื่อนไข'),));
                      },
                    ),
                  ),
                  CustomCustomPopupMenuItem(
                    value: CustomPopupMenuItem(
                      title: 'ออกจากระบบ',
                      icon: Icons.logout,
                      onTap: () {
                        Navigator.pop(context);
                        systemwidgetcustom.showDialogConfirm(context, 'ออกจากระบบ', 'ท่านต้องการออกจากระบบหรือไม่?', () async {
                          Navigator.pop(context);
                          systemwidgetcustom.loadingWidget(context);
    
                          // ออกจากระบบไปหน้าเข้าสู่ระบบ
                          await configStorage.clearTokens();
                          if (context.mounted) {
                            context.read<UsersBloc>().add(RemoveUser());
                            context.read<DevicesBloc>().add(ClearDevices());
                            Navigator.of(context).pop();
                            Navigator.pushNamedAndRemoveUntil(context, custom_route.Route.login, (route) => false);
                          }
                        }, primaryColor, redColor);
                      },
                    ),
                  ),
                ];
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.settings, color: Colors.white, size: Responsive.isTablet? 35 : 30),
              ),
            ),
            SizedBox(width: 10),
          ],
        );
      },
    );
  }
}

// คลาส CustomPopupMenuItem สำหรับสร้างเมนูแบบป็อปอัพ
class CustomPopupMenuItem {
  final String title;
  final IconData icon;
  final Function() onTap;

  CustomPopupMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

// คลาส CustomCustomPopupMenuItem สำหรับแปลง CustomPopupMenuItem ให้เป็น PopupMenuEntry
class CustomCustomPopupMenuItem extends PopupMenuEntry<CustomPopupMenuItem> {
  final CustomPopupMenuItem value;

  const CustomCustomPopupMenuItem({super.key, required this.value});

  @override
  double get height => kMinInteractiveDimension;

  @override
  bool represents(CustomPopupMenuItem? value) => this.value == value;

  @override
  State createState() => _CustomCustomPopupMenuItemState();
}

class _CustomCustomPopupMenuItemState extends State<CustomCustomPopupMenuItem> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return TextButton.icon(onPressed: widget.value.onTap, style: TextButton.styleFrom(alignment: Alignment.centerLeft,padding: EdgeInsets.symmetric(horizontal: Responsive.isTablet ? 20.0 : 16.0, vertical: 10)), icon: Icon(widget.value.icon, size: Responsive.isTablet ? 30 : 20, color: themeState.themeApp? Colors.white70 : primaryColor), label: Text(widget.value.title, style: TextStyle(color: themeState.themeApp? Colors.white70 : primaryColor, fontSize: Responsive.isTablet ? 20 : 16)));
      },
    );
  }
}
