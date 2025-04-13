import 'package:flutter/material.dart';
import 'package:github_oauth/github_oauth.dart';

import '../../domain/entities/user_entity.dart';

abstract class RemoteDatasource {
  /// Trigger GitHub OAuth sign-in flow
  Future<GitHubSignInResult> signInWithGitHub(BuildContext context);

  /// Check if user is already authenticated
  Future<bool> isSignedIn();

  /// Logout / reset auth session
  Future<void> signOut();

  Future<UserEntity> getCurrentUser(String token);
}
