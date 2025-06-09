import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smmonitoring/src/configs/url.dart';
import 'package:smmonitoring/src/models/hospitals.dart';
import 'package:smmonitoring/src/services/api.dart';
import 'package:smmonitoring/src/configs/route.dart' as custom_route;

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final api = Api();
  UsersBloc() : super(const UsersState()) {
    on<SetUser>(_onSetUser);
    on<RemoveUser>(_onRemoveUser);
    on<SetError>(_onSetError);
    on<SetHospital>(_onSetHospital);
  }

  void _onSetUser(SetUser event, Emitter<UsersState> emit) async {
    try {
      final user = await api.getUser();
      emit(state.copyWith(
        display: user!.display,
        pic: user.pic,
        role: user.role,
        id: user.id,
        username: user.username,
        ward: user.wardId,
        hospitalId: user.ward!.hosId,
        type: user.ward!.type,
      ));
    } on Exception {
      custom_route.Route.navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  void _onRemoveUser(RemoveUser event, Emitter<UsersState> emit) {
    emit(state.copyWith(
      display: '',
      pic: URL.DEFAULT_PIC,
      role: 'GUEST',
      id: '',
      username: '',
      ward: '',
      hospitalId: '',
      type: '',
      error: false,
      isLoading: false,
      hospital: [],
    ));
  }

  void _onSetError(SetError event, Emitter<UsersState> emit) {
    emit(state.copyWith(error: event.error));
  }

  void _onSetHospital(SetHospital event, Emitter<UsersState> emit) async {
    final hospital = await api.getHospital();
    emit(state.copyWith(hospital: hospital));
    emit(state.copyWith(isLoading: false));
  }
}
