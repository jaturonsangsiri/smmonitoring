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
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state.role == "LEGACY_USER" || state.role == "LEGACY_ADMIN" || state.role == "ADMIN") {
          return Text(notification.probe ?? "-", style: isTablet? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.bodySmall);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.probe ?? "-", style: isTablet? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 5),
            Text(notification.device!.name ?? "-", style: isTablet? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 5),
            Text(notification.device!.hospitalName ?? "-", style: isTablet? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.bodySmall),
          ],
        );
      },
    );
  }
}
