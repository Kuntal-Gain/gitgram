import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gitgram/domain/usecases/user/get_following_usecase.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/user/get_curr_user_usecase.dart';
import '../../../domain/usecases/user/get_single_following_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetCurrentUserUsecase getCurrentUserUsecase;
  final GetFollowingUsecase getFollowingUsecase;
  final GetSingleFollowingUsecase getSingleFollowingUsecase;
  UserCubit({
    required this.getCurrentUserUsecase,
    required this.getFollowingUsecase,
    required this.getSingleFollowingUsecase,
  }) : super(UserInitial());

  Future<void> getUser({required String token}) async {
    emit(const UserLoading(isCurrentUser: true));
    try {
      final user = await getCurrentUserUsecase.call(token);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> getFollowing({required String username}) async {
    emit(const UserLoading(isFollowingList: true));
    try {
      final users = await getFollowingUsecase.call(username);
      emit(UserFollowingLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> getSingleFollowing({required String username}) async {
    emit(const UserLoading(isSingleFollowing: true));
    try {
      final user = await getSingleFollowingUsecase.call(username);
      emit(UserSingleFollowingLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
