import 'package:flutter/material.dart';
import 'package:gitgram/domain/entities/post_entity.dart';
import 'package:gitgram/domain/entities/user_entity.dart';
import 'package:github_oauth/github_oauth.dart';

abstract class LocalRepository {
  /// Trigger GitHub OAuth sign-in flow
  Future<GitHubSignInResult> signInWithGitHub(BuildContext context);

  /// Check if user is already authenticated
  Future<bool> isSignedIn();

  /// Logout / reset auth session
  Future<void> signOut();

  Future<UserEntity> getCurrentUser(String token);

  Future<List<UserEntity>> getFollowings(String username);

  Future<UserEntity> getSingleFollowing(String username);

  // repos

  Future<List<PostEntity>> getRepositories(String username);

  Future<PostEntity> getSingleRepository(String username, String repoId);

  Future<List<PostEntity>> getFeedPosts(String username);
}
