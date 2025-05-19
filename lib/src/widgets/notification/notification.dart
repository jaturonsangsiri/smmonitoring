import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:smmonitoring/src/bloc/notification/notification_bloc.dart';
import 'package:smmonitoring/src/widgets/notification_widget.dart';
import 'package:smmonitoring/src/widgets/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  NotificationWidget notificationWidget = NotificationWidget();

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(GetAllNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, notiState) {
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          if (context.mounted) context.read<NotificationBloc>().add(GetAllNotifications());
        });

        if(notiState.isError) {
          ShowSnackbar.snackbar(ContentType.failure, "ผิดพลาด", "ไม่สามารถโหลดข้อมูลได้");
          context.read<NotificationBloc>().add(const NotificationError(false));
        }

        if(notiState.notifications.isEmpty) return Center(child: Text('data', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.black.withValues(alpha: 0.7)),),);

        return RefreshIndicator(
          onRefresh: () async {
            context.read<NotificationBloc>().add(GetAllNotifications());
            await Future.delayed(const Duration(seconds: 1));
          },
          child: ListView.separated(
            itemCount: notiState.notifications.length,
            separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.grey[300], thickness: 0),
            itemBuilder: (BuildContext context, int index) {
              return notificationWidget.buildNotificationWidget(
                context,
                notiState.notifications[index].device!.name!,
                notiState.notifications[index].detail!,
                notiState.notifications[index].createAt.toString().substring(11, 16),
                notiState.notifications[index].createAt.toString().substring(0, 10),
                null
              );
            },
          ),
        );
      },
    );
  }
}
