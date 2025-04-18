part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoaded extends UserState {
  final UserEntity user;
  const UserLoaded(this.user);
  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  final String message;
  const UserError(this.message);
  @override
  List<Object> get props => [message];
}
