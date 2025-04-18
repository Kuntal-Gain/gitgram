part of 'post_cubit.dart';

abstract class PostState extends Equatable {
  const PostState();
}

class PostInitial extends PostState {
  @override
  List<Object> get props => [];
}

class PostLoading extends PostState {
  @override
  List<Object> get props => [];
}

class PostLoaded extends PostState {
  final List<PostEntity> posts;

  const PostLoaded({required this.posts});
  @override
  List<Object> get props => [posts];
}

class PostError extends PostState {
  final String message;
  const PostError({required this.message});
  @override
  List<Object> get props => [message];
}
