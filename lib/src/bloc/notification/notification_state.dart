part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  final List<NotiList> notifications;
  final List<LegacyNotificationList> legacyNotifications;
  final bool isError;
  const NotificationState({this.notifications = const [],this.legacyNotifications = const [], this.isError = false});
  
  NotificationState copyWith({List<NotiList>? notifications, List<LegacyNotificationList>? legacyNotifications, bool? isError}) {
    return NotificationState(
      notifications: notifications ?? this.notifications, 
      legacyNotifications: legacyNotifications ?? this.legacyNotifications, 
      isError: isError ?? this.isError
    );
  }

  @override
  List<Object> get props => [notifications, legacyNotifications, isError];
}
