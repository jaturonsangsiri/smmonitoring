part of 'devices_bloc.dart';

sealed class DevicesEvent extends Equatable {
  const DevicesEvent();

  @override
  List<Object> get props => [];
}

class GetDevices extends DevicesEvent {
  final String ward;
  const GetDevices(this.ward);

  @override
  List<Object> get props => [ward];
}

class SetHospitalData extends DevicesEvent {
  final String hospitalId;
  final String wardId;
  final String wardType;
  const SetHospitalData(this.hospitalId, this.wardId, this.wardType);

  @override
  List<Object> get props => [hospitalId, wardId, wardType];
}

class GetLegacyDevices extends DevicesEvent {
  final String ward;
  const GetLegacyDevices(this.ward);

  @override
  List<Object> get props => [ward];
}

class GetDeviceById extends DevicesEvent {
  final String id;
  const GetDeviceById(this.id);

  @override
  List<Object> get props => [id];
}

class ClearDevice extends DevicesEvent {}

class ClearDevices extends DevicesEvent {}

class DeviceError extends DevicesEvent {
  final bool error;
  const DeviceError(this.error);

  @override
  List<Object> get props => [error];
}
