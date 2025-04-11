import 'package:flutter/material.dart';
import 'package:gitgram/data/data_sources/remote_datasource.dart';
import 'package:gitgram/domain/repos/local_repository.dart';
import 'package:github_oauth/github_oauth.dart';

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
}
