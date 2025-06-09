part of 'users_bloc.dart';

sealed class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object> get props => [];
}

class SetUser extends UsersEvent {}

class SetError extends UsersEvent {
  final bool error;
  const SetError(this.error);

  @override
  List<Object> get props => [error];
}

class RemoveUser extends UsersEvent {}

class SetHospital extends UsersEvent {}
