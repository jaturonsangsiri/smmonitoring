import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smmonitoring/src/widgets/utils/responsive.dart';

class NotificationWidget {
  // ฟังก์ชั่น Widget ของการแจ้งเตือน
  Widget buildNotificationWidget(BuildContext context, String title, String subtitle, String time, String date, Widget? icon) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        Color textColor = themeState.themeApp ? Colors.white : Colors.black87;
        return SizedBox(
          height: Responsive.isTablet ? 80 : 60,
          child: ListTile(
            leading: icon,
            title: Text(title, style: Responsive.isTablet ? Theme.of(context).textTheme.titleLarge!.copyWith(color: textColor) : Theme.of(context).textTheme.bodyMedium!.copyWith(color: textColor)),
            subtitle: Text(subtitle, style: Responsive.isTablet ? Theme.of(context).textTheme.titleMedium!.copyWith(color: textColor) : Theme.of(context).textTheme.bodySmall!.copyWith(color: textColor)),
            trailing: Column(children: [Text(time, style: Responsive.isTablet ? Theme.of(context).textTheme.titleMedium!.copyWith(color: textColor) : Theme.of(context).textTheme.bodySmall!.copyWith(color: textColor)), Text(date, style: Responsive.isTablet ? Theme.of(context).textTheme.titleMedium!.copyWith(color: textColor) : Theme.of(context).textTheme.bodySmall!.copyWith(color: textColor))])
          ),
        );
      },
    );
  }
}