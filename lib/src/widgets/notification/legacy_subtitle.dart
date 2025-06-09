import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/bloc/user/users_bloc.dart';
import 'package:smmonitoring/src/models/legacy_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LegacySubtitle extends StatelessWidget {
  final LegacyNotificationList notification;
  final bool isTablet;
  const LegacySubtitle({super.key, required this.notification, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            TextStyle fontStyle = isTablet? Theme.of(context).textTheme.titleMedium!.copyWith(color: themeState.themeApp ? Colors.white70 : Colors.black) : Theme.of(context).textTheme.bodySmall!.copyWith(color: themeState.themeApp ? Colors.white70 : Colors.black);
            if (state.role == "LEGACY_USER" || state.role == "LEGACY_ADMIN" || state.role == "ADMIN") {
              return Text(notification.probe ?? "-", style: fontStyle);
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.probe ?? "-", style: fontStyle),
                const SizedBox(height: 5),
                Text(notification.device!.name ?? "-", style: fontStyle),
                const SizedBox(height: 5),
                Text(notification.device!.hospitalName ?? "-", style: fontStyle),
              ],
            );
          },
        );
      },
    );
    
  }
}
