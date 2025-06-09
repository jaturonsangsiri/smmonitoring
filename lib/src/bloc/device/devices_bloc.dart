import 'package:smmonitoring/src/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smmonitoring/src/models/devices.dart';
import 'package:smmonitoring/src/models/legacy_device.dart';
import 'package:smmonitoring/src/models/log.dart';
import 'package:smmonitoring/src/services/services.dart';

part 'devices_event.dart';
part 'devices_state.dart';

class DevicesBloc extends Bloc<DevicesEvent, DevicesState> {
  final api = Api();
  DevicesBloc() : super(const DevicesState()) {
    on<GetDevices>(_getDevices);
    on<GetLegacyDevices>(_getLegacyDevices);
    on<GetDeviceById>(_getDeviceById);
    on<SetHospitalData>(_onSetHospitalData);
    on<ClearDevices>(_clearDevices);
    on<ClearDevice>(_clearDevice);
    on<DeviceError>((event, emit) {
      emit(state.copyWith(isError: event.error));
    });
  }

  void _onSetHospitalData(SetHospitalData event, Emitter<DevicesState> emit) {
    emit(state.copyWith(hospitalId: event.hospitalId, wardId: event.wardId, wardType: event.wardType));
  }

  Future<void> _getDevices(event, emit) async {
    try {
      final response = await api.getDevice(event.ward);
      emit(state.copyWith(devices: response));
    } on Exception catch (e) {
      emit(state.copyWith(isError: true));
      if (kDebugMode) print(e);
    }
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _getDeviceById(event, emit) async {
    try {
      final response = await api.getDeviceById(event.id);
      emit(state.copyWith(device: response));
    } on Exception catch (e) {
      emit(state.copyWith(isError: true));
      if (kDebugMode) print(e);
    }
  }

  Future<void> _getLegacyDevices(event, emit) async {
    try {
      final response = await api.getLegacyDevice(event.ward);
      emit(state.copyWith(legacyDevice: response));
    } on Exception catch (e) {
      emit(state.copyWith(isError: true));
      if (kDebugMode) print(e);
    }
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _clearDevices(event, emit) async {
    emit(state.copyWith(devices: [], legacyDevice: []));
  }

  Future<void> _clearDevice(event, emit) async {
    DeviceId? device = DeviceId(
      hospital: "",
      hospitalName: "",
      id: "",
      name: "",
      online: false,
      position: "",
      staticName: "",
      status: false,
      ward: "",
      wardName: "",
      probe: const [],
    );
    emit(state.copyWith(device: device));
  }
}
