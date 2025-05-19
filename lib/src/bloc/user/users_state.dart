part of 'users_bloc.dart';

class UsersState extends Equatable {
  final String display;
  final String pic;
  final String role;
  final String id;
  final String username;
  final bool error;
  final List<HospitalData> hospital;
  final String ward;
  final String hospitalId;
  final String type;
  final String hospitalSelected;
  final String departmentSelected;

  const UsersState({
    this.display = "",
    this.pic = URL.DEFAULT_PIC,
    this.role = "GUEST",
    this.id = "",
    this.username = "",
    this.error = false,
    this.hospital = const [],
    this.ward = "",
    this.hospitalId = "",
    this.type = "",
    this.hospitalSelected = "",
    this.departmentSelected = ""
  });

  UsersState copyWith({
    String? display,
    String? pic,
    String? role,
    String? id,
    String? username,
    bool? error,
    List<HospitalData>? hospital,
    String? ward,
    String? hospitalId,
    String? type,
    String? hospitalSelected,
    String? departmentSelected
  }) {
    return UsersState(
      display: display ?? this.display,
      pic: pic ?? this.pic,
      role: role ?? this.role,
      id: id ?? this.id,
      username: username ?? this.username,
      error: error ?? this.error,
      hospital: hospital ?? this.hospital,
      ward: ward ?? this.ward,
      hospitalId: hospitalId ?? this.hospitalId,
      type: type ?? this.type,
      hospitalSelected: hospitalSelected ?? this.hospitalSelected,
      departmentSelected: departmentSelected ?? this.departmentSelected
    );
  }

  @override
  List<Object> get props => [display, pic, role, id, username, error, hospital, ward, hospitalId, type, hospitalSelected, departmentSelected];
}
