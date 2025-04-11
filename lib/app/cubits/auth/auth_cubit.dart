import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:gitgram/domain/usecases/signin_with_github_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInWithGitHubUseCase signInWithGitHubUseCase;

  AuthCubit({required this.signInWithGitHubUseCase}) : super(AuthInitial());

  Future<void> signInWithGitHub(BuildContext ctx) async {
    emit(AuthInitial());

    try {
      final res = await signInWithGitHubUseCase.call(ctx);
      emit(Authenticated(res.token!));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
