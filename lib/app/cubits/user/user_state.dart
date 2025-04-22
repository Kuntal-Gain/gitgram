part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {
  final bool isCurrentUser;
  final bool isFollowingList;
  final bool isSingleFollowing;

  const UserLoading({
    this.isCurrentUser = false,
    this.isFollowingList = false,
    this.isSingleFollowing = false,
  });

  @override
  List<Object> get props => [isCurrentUser, isFollowingList, isSingleFollowing];
}

class UserLoaded extends UserState {
  final UserEntity user;
  const UserLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class UserFollowingLoaded extends UserState {
  final List<UserEntity> users;
  const UserFollowingLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class UserSingleFollowingLoaded extends UserState {
  final UserEntity user;
  const UserSingleFollowingLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  final String message;
  const UserError(this.message);

  @override
  List<Object> get props => [message];
}
