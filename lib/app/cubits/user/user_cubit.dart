import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/user/get_curr_user_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetCurrentUserUsecase getCurrentUserUsecase;
  UserCubit({required this.getCurrentUserUsecase}) : super(UserInitial());

  Future<void> getUser({required String token}) async {
    emit(UserLoading());
    try {
      final user = await getCurrentUserUsecase.call(token);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
