import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/constants/contants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smmonitoring/src/widgets/utils/responsive.dart';

class SettingSubWidget {
  // สร้าง Widget หัวข้อใหญ่
  Widget buildMainTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 8),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) => Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: themeState.themeApp ? secColorDarkSub : secColor)),
      ),
    );
  }

  // สร้าง Widget หัวข้อย่อย
  Widget buildSubTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 8),
      child: BlocBuilder<ThemeBloc, ThemeState>(builder: (context, themeState) => Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: themeState.themeApp ? secColorDarkSub : secColor)))
    );
  }

  // กล่องพื้นหลังแยก
  Widget buildSettingCard(List<Widget> widgets) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Card(
          elevation: 3,
          color: themeState.themeApp ? boxColorDark : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: widgets)),
        );
      },
    );
  }

  // การตั้งค่าเป็นแถว
  Widget buildRowSetting({ required IconData icon, required String title, required Widget trailing,}) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Row(
          children: [
            Icon(icon, color: themeState.themeApp ? secColorDarkSub : secColor, size:  Responsive.isTablet ? 26 : 24),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: TextStyle(color: themeState.themeApp? Colors.white : Color.fromARGB(255, 70, 70, 70), fontSize:  Responsive.isTablet ? 20 : 16, fontWeight: FontWeight.w500))),
            trailing,
          ],
        );
      },
    );
  }
}
