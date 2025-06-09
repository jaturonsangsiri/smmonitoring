import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smmonitoring/src/models/legacy_notification.dart';
import 'package:smmonitoring/src/models/models.dart';
import 'package:smmonitoring/src/services/api.dart';
import 'package:flutter/foundation.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final Api api = Api();
  NotificationBloc() : super(const NotificationState()) {
    on<GetAllNotifications>(_onLoadNotifications);
    on<GetLegacyNotifications>(_onLoadLegacyNotification);
    on<NotificationError>(_onError);
  }

  void _onLoadNotifications(GetAllNotifications event, Emitter<NotificationState> emit) async {
     emit(state.copyWith(isLoading: true));
    try {
      List<NotiList> notifications = await api.getNotification();
      emit(state.copyWith(notifications: notifications, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isError: true, isLoading: false));
      if (kDebugMode) print(e);
    }
  }

  void _onLoadLegacyNotification(GetLegacyNotifications event, Emitter<NotificationState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      List<LegacyNotificationList> legacyNotification = await api.getLegacyNotification();
      emit(state.copyWith(legacyNotifications: legacyNotification, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isError: true, isLoading: false));
      if(kDebugMode) print(e);
    }
  }

  void _onError(NotificationError event, Emitter<NotificationState> emit) {
    emit(state.copyWith(isError: event.error));
  }
}
