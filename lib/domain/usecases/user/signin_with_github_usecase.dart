import 'package:flutter/material.dart';
import 'package:github_oauth/github_oauth.dart';

import '../../repos/local_repository.dart';

class SignInWithGitHubUseCase {
  final LocalRepository localRepository;

  SignInWithGitHubUseCase(this.localRepository);

  Future<GitHubSignInResult> call(BuildContext context) {
    return localRepository.signInWithGitHub(context);
  }
}
