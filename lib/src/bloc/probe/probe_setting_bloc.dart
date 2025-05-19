import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'probe_setting_event.dart';
part 'probe_setting_state.dart';

class ProbeSettingBloc extends Bloc<ProbeSettingEvent, ProbeSettingState> {
  ProbeSettingBloc() : super(ProbeSettingState()) {
    on<SetValues>((event, emit) {
      emit(state.copyWith(
          temEntryNoti: event.temEntryNoti ?? state.temEntryNoti,
          isNotification: event.isNotification ?? state.isNotification,
          delayfirstNoti: event.delayfirstNoti ?? state.delayfirstNoti,
          repeatNoti: event.repeatNoti ?? state.repeatNoti,
          isDairyNoti: event.isDairyNoti ?? state.isDairyNoti,
          firstDayNoti: event.firstDayNoti ?? state.firstDayNoti,
          firstTime: event.firstTime ?? state.firstTime,
          secondDayNoti: event.secondDayNoti ?? state.secondDayNoti,
          secondTime: event.secondTime ?? state.secondTime,
          thirdDayNoti: event.thirdDayNoti ?? state.thirdDayNoti,
          thirdTime: event.thirdTime ?? state.thirdTime,
        )
      );
    });
  }
}
