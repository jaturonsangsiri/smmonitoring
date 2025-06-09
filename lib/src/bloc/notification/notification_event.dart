part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class GetAllNotifications extends NotificationEvent {}

class GetLegacyNotifications extends NotificationEvent {}

class NotificationError extends NotificationEvent {
  final bool error;

  const NotificationError(this.error);

  @override
  List<Object> get props => [error];
}