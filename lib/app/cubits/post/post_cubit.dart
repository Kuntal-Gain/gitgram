import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gitgram/domain/entities/post_entity.dart';
import 'package:gitgram/domain/usecases/post/get_feed_posts_usecase.dart';
import 'package:gitgram/domain/usecases/post/get_repos_usecase.dart';
import 'package:gitgram/domain/usecases/post/get_single_repo_usecase.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final GetReposUseCase getReposUseCase;
  final GetSingleRepoUseCase getSingleRepoUseCase;
  final GetFeedPostsUsecase getFeedPostsUsecase;
  PostCubit(
      {required this.getReposUseCase,
      required this.getSingleRepoUseCase,
      required this.getFeedPostsUsecase})
      : super(PostInitial());

  Future<void> fetchPosts({required String username}) async {
    emit(PostLoading());
    try {
      final posts = await getReposUseCase.call(username);
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> fetchSinglePost(
      {required String username, required String repoName}) async {
    emit(PostLoading());
    try {
      final post = await getSingleRepoUseCase.call(username, repoName);
      emit(PostLoaded([post]));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> fetchFeedPosts({required String username}) async {
    emit(PostLoading());

    try {
      final posts = await getFeedPostsUsecase.call(username);
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }
}
