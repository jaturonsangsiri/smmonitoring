part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  final List<NotiList> notifications;
  final List<LegacyNotificationList> legacyNotifications;
  final bool isError;
  final bool isLoading;
  const NotificationState({this.notifications = const [],this.legacyNotifications = const [], this.isError = false, this.isLoading = true});
  
  NotificationState copyWith({List<NotiList>? notifications, List<LegacyNotificationList>? legacyNotifications, bool? isError, bool? isLoading}) {
    return NotificationState(
      notifications: notifications ?? this.notifications, 
      legacyNotifications: legacyNotifications ?? this.legacyNotifications, 
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading
    );
  }

  @override
  List<Object> get props => [notifications, legacyNotifications, isError, isLoading];
}
