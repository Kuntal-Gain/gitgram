import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:gitgram/data/data_sources/remote_datasource.dart';
import 'package:gitgram/data/models/user_model.dart';
import 'package:gitgram/domain/entities/user_entity.dart';
import 'package:github_oauth/github_oauth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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

      print("token saved");

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

  @override
  Future<UserEntity> getCurrentUser(String token) async {
    final url = Uri.parse("https://api.github.com/user");

    final res = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/vnd.github+json',
      },
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch user info');
    }
  }
}
