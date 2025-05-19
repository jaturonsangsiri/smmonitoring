import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:smmonitoring/src/bloc/notification/notification_bloc.dart';
import 'package:smmonitoring/src/bloc/theme/theme_bloc.dart';
import 'package:smmonitoring/src/widgets/notification/legacy_subtitle.dart';
import 'package:smmonitoring/src/widgets/notification_widget.dart';
import 'package:smmonitoring/src/widgets/utils/responsive.dart';
import 'package:smmonitoring/src/widgets/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationLegacy extends StatefulWidget {
  const NotificationLegacy({super.key});

  @override
  State<NotificationLegacy> createState() => _NotificationLegacyState();
}

class _NotificationLegacyState extends State<NotificationLegacy> {
  NotificationWidget notificationWidget = NotificationWidget();

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(GetLegacyNotifications());
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (context.mounted) context.read<NotificationBloc>().add(GetLegacyNotifications());
    });

    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, notiState) {
        if(notiState.isError) {
          ShowSnackbar.snackbar(ContentType.failure, "ผิดพลาด", "ไม่สามารถโหลดข้อมูลได้");
          context.read<NotificationBloc>().add(const NotificationError(false));
        }

        if(notiState.legacyNotifications.isEmpty) return Center(child: Text('data', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.black.withValues(alpha: 0.7)),),);
        return RefreshIndicator(
          onRefresh: () async {
            context.read<NotificationBloc>().add(GetLegacyNotifications());
            await Future.delayed(const Duration(seconds: 1));
          },
          child: ListView.separated(
            itemCount: notiState.legacyNotifications.length,
            separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.grey[300], thickness: 0),
            itemBuilder: (context, index) {
              return BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, themeState) {
                  return ListTile(
                    leading: Icon(Icons.notifications, color: themeState.themeApp? const Color.fromARGB(255, 162, 196, 255) : Colors.green.shade400,),
                    title: Text(notiState.legacyNotifications[index].message!, style: Responsive.isTablet? Theme.of(context).textTheme.titleSmall : Theme.of(context).textTheme.bodyMedium),
                    subtitle: LegacySubtitle(notification: notiState.legacyNotifications[index], isTablet: Responsive.isTablet),
                  );
                },
              );
            }, 
          ),
        );
      },
    );
  }
}
