part of 'devices_bloc.dart';

class DevicesState extends Equatable {
  final List<DeviceInfo> devices;
  final List<DeviceLegacyList> legacyDevice;
  final DeviceId? device;
  final String hospitalId;
  final String wardId;
  final String wardType;
  final bool isError;
  final bool isLoading;
  const DevicesState({
    this.devices = const [],
    this.legacyDevice = const [],
    this.device,
    this.hospitalId = '',
    this.wardId = '',
    this.wardType = '',
    this.isError = false,
    this.isLoading = true,
  });

  DevicesState copyWith({
    List<DeviceInfo>? devices,
    List<DeviceLegacyList>? legacyDevice,
    DeviceId? device,
    String? hospitalId,
    String? wardId,
    String? wardType,
    bool? isError,
    bool? isLoading
  }) {
    return DevicesState(
      devices: devices ?? this.devices,
      legacyDevice: legacyDevice ?? this.legacyDevice,
      device: device ?? this.device,
      hospitalId: hospitalId ?? this.hospitalId,
      wardId: wardId ?? this.wardId,
      wardType: wardType ?? this.wardType,
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading
    );
  }

  @override
  List<Object> get props => [devices, legacyDevice, device ?? DeviceId(), isError, hospitalId, wardId, wardType, isLoading];
}
