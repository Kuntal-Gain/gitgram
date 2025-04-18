import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:gitgram/domain/usecases/user/is_signin_usecase.dart';
import 'package:gitgram/domain/usecases/user/signin_with_github_usecase.dart';
import 'package:gitgram/domain/usecases/user/signout_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInWithGitHubUseCase signInWithGitHubUseCase;
  final IsSignInUseCase isSignInUseCase;
  final SignOutUseCase signOutUseCase;

  AuthCubit(
      {required this.signInWithGitHubUseCase,
      required this.isSignInUseCase,
      required this.signOutUseCase})
      : super(AuthInitial());

  Future<void> signInWithGitHub(BuildContext ctx) async {
    emit(AuthInitial());

    try {
      final res = await signInWithGitHubUseCase.call(ctx);
      emit(Authenticated(res.token!));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> isSignin() async {
    emit(AuthInitial());

    try {
      final res = await isSignInUseCase.call();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null) {
        emit(Authenticated(token));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AuthInitial());

    try {
      await signOutUseCase.call();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
