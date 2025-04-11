part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final String token;
  const Authenticated(this.token);
  @override
  List<Object> get props => [token];
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
  @override
  List<Object> get props => [];
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
  @override
  List<Object> get props => [message];
}
