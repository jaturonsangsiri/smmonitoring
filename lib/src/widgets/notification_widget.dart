import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationWidget {
  // ฟังก์ชั่น Widget ของการแจ้งเตือน
  Widget buildNotificationWidget(BuildContext context, String title, String subtitle, String time, String date, Widget? icon) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return ListTile(
          leading: icon,
          title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
          subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          trailing: Column(children: [Text(time, style: Theme.of(context).textTheme.bodyMedium), Text(date, style: Theme.of(context).textTheme.bodyMedium)])
        );
      },
    );
  }
}