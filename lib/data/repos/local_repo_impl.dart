import 'package:flutter/material.dart';
import 'package:gitgram/data/data_sources/remote_datasource.dart';
import 'package:gitgram/domain/repos/local_repository.dart';
import 'package:github_oauth/github_oauth.dart';

import '../../domain/entities/post_entity.dart';
import '../../domain/entities/user_entity.dart';

class LocalRepoImpl implements LocalRepository {
  final RemoteDatasource remoteDatasource;

  LocalRepoImpl({required this.remoteDatasource});

  @override
  Future<bool> isSignedIn() => remoteDatasource.isSignedIn();

  @override
  Future<GitHubSignInResult> signInWithGitHub(BuildContext context) =>
      remoteDatasource.signInWithGitHub(context);

  @override
  Future<void> signOut() => remoteDatasource.signOut();

  @override
  Future<UserEntity> getCurrentUser(String token) =>
      remoteDatasource.getCurrentUser(token);

  @override
  Future<List<PostEntity>> getRepositories(String username) =>
      remoteDatasource.getRepositories(username);

  @override
  Future<PostEntity> getSingleRepository(String username, String repoId) =>
      remoteDatasource.getSingleRepository(username, repoId);
}
