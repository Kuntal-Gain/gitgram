import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:gitgram/app/cubits/auth/auth_cubit.dart';
import 'package:gitgram/app/cubits/user/user_cubit.dart';
import 'package:gitgram/data/data_sources/remote_datasource_impl.dart';
import 'package:gitgram/data/repos/local_repo_impl.dart';
import 'package:gitgram/domain/repos/local_repository.dart';
import 'package:gitgram/domain/usecases/user/is_signin_usecase.dart';
import 'package:gitgram/domain/usecases/user/signin_with_github_usecase.dart';
import 'package:github_oauth/github_oauth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/cubits/post/post_cubit.dart';
import 'data/data_sources/remote_datasource.dart';
import 'domain/usecases/post/get_repos_usecase.dart';
import 'domain/usecases/post/get_single_repo_usecase.dart';
import 'domain/usecases/user/get_curr_user_usecase.dart';
import 'domain/usecases/user/signout_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // cubits

  sl.registerFactory(
    () => AuthCubit(
      signInWithGitHubUseCase: sl.call(),
      isSignInUseCase: sl.call(),
      signOutUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => UserCubit(
      getCurrentUserUsecase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => PostCubit(
      getReposUseCase: sl.call(),
      getSingleRepoUseCase: sl.call(),
    ),
  );

  // usecases

  sl.registerLazySingleton(() => IsSignInUseCase(sl.call()));
  sl.registerLazySingleton(() => SignInWithGitHubUseCase(sl.call()));
  sl.registerLazySingleton(() => SignOutUseCase(sl.call()));
  sl.registerLazySingleton(() => GetCurrentUserUsecase(sl.call()));
  sl.registerLazySingleton(() => GetReposUseCase(sl.call()));
  sl.registerLazySingleton(() => GetSingleRepoUseCase(sl.call()));

  // repositories

  sl.registerLazySingleton<LocalRepository>(
      () => LocalRepoImpl(remoteDatasource: sl.call()));
  sl.registerLazySingleton<RemoteDatasource>(
      () => RemoteDatasourceImpl(gitHubSignIn: sl.call(), prefs: sl.call()));

  // externals

  await dotenv.load();

  final sharedPrefs = await SharedPreferences.getInstance();

  sl.registerLazySingleton(() => dotenv);
  sl.registerLazySingleton(() => sharedPrefs);
  sl.registerLazySingleton(() => GitHubSignIn(
        clientId: dotenv.env['GITHUB_CLIENT_ID']!,
        clientSecret: dotenv.env['GITHUB_CLIENT_SECRET']!,
        redirectUrl: dotenv.env['GITHUB_REDIRECT_URL']!,
      ));
}
