import 'package:flutter/material.dart';
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
}
