import 'package:smmonitoring/src/bloc/device/devices_bloc.dart';
import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/models/log.dart';
import 'package:smmonitoring/src/widgets/notification_widget.dart';
import 'package:smmonitoring/src/widgets/utils/convert.dart';
import 'package:smmonitoring/src/widgets/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Noti extends StatelessWidget {
  final String devSerial;
  const Noti({super.key, required this.devSerial});

  @override
  Widget build(BuildContext context) {
    NotificationWidget notificationWidget = NotificationWidget();
    return BlocBuilder<DevicesBloc, DevicesState>(
      builder: (context, state) {
        DeviceInfo devices =
            state.devices.where((i) => i.serial == devSerial).toList().first;
        if (devices.notification!.isEmpty) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return Center(child: Text("ไม่มีข้อมูลการแจ้งเตือน", style: Responsive.isTablet ? Theme.of(context).textTheme.titleLarge!.copyWith(color: themeState.themeApp ? Colors.white70 : Colors.black) : Theme.of(context).textTheme.bodyMedium));
            },
          );
        }
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, theme) {
            return Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var device in devices.notification!)
                      notificationWidget.buildNotificationWidget(
                        context,
                        device.detail ?? "-/-",
                        device.detail!,
                        device.createAt.toString().substring(0, 10),
                        device.createAt.toString().substring(11, 16),
                        ConvertMessage.showIcon(
                          device.message ?? "-/-",
                          Responsive.isTablet ? 40 : 30,
                          theme.themeApp,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
