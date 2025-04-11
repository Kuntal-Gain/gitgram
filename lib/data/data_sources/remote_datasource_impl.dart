import 'package:flutter/widgets.dart';
import 'package:gitgram/data/data_sources/remote_datasource.dart';
import 'package:github_oauth/github_oauth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteDatasourceImpl implements RemoteDatasource {
  final GitHubSignIn gitHubSignIn;
  final SharedPreferences prefs;

  static const _tokenKey = 'token';

  RemoteDatasourceImpl({
    required this.gitHubSignIn,
    required this.prefs,
  });

  @override
  Future<GitHubSignInResult> signInWithGitHub(BuildContext context) async {
    try {
      final result = await gitHubSignIn.signIn(context);

      if (result.status == GitHubSignInResultStatus.ok &&
          result.token != null) {
        await prefs.setString(_tokenKey, result.token!);
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isSignedIn() async {
    final token = prefs.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> signOut() async {
    await prefs.remove(_tokenKey);
  }
}
