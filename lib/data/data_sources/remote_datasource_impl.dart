import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:gitgram/data/data_sources/remote_datasource.dart';
import 'package:gitgram/data/models/user_model.dart';
import 'package:gitgram/domain/entities/post_entity.dart';
import 'package:gitgram/domain/entities/user_entity.dart';
import 'package:github_oauth/github_oauth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/post_model.dart';

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

  @override
  Future<List<PostEntity>> getRepositories(String username) async {
    final token = prefs.getString(_tokenKey);
    final url = Uri.parse("https://api.github.com/users/$username/repos");

    final res = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/vnd.github+json',
    });

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      if (data is List) {
        return data.map((e) => PostModel.fromJson(e)).toList();
      } else {
        // Handle GitHub error body (most likely a Map)
        final message =
            data['message'] ?? 'Unexpected response from GitHub API';
        throw Exception(message);
      }
    } else {
      // Fallback in case even the status is wrong
      final errorData = jsonDecode(res.body);
      final message = errorData['message'] ?? 'Failed to fetch repositories';
      throw Exception(message);
    }
  }

  @override
  Future<PostEntity> getSingleRepository(String username, String repoId) async {
    final token = prefs.getString(_tokenKey);
    final url = Uri.parse("https://api.github.com/repos/$username/$repoId");

    final res = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/vnd.github+json',
    });

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return PostModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch repository');
    }
  }

  @override
  Future<List<PostEntity>> getFeedPosts(String username) async {
    final followings = await getFollowings(username);

    // fetch posts for all followings in parallel
    final allPostsLists = await Future.wait(
      followings.map((flw) => getRepositories(flw.login)),
    );

    // flatten the list of lists
    final feedPosts = allPostsLists.expand((list) => list).toList();

    // sort by created date
    feedPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return feedPosts;
  }

  @override
  Future<List<UserEntity>> getFollowings(String username) async {
    // get list of users
    final token = prefs.getString(_tokenKey);
    final url = Uri.parse("https://api.github.com/users/$username/following");
    final res = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/vnd.github+json',
    });
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data is List) {
        return data.map((e) => UserModel.fromJson(e)).toList();
      } else {
        final message =
            data['message'] ?? 'Unexpected response from GitHub API';
        throw Exception(message);
      }
    } else {
      final errorData = jsonDecode(res.body);
      final message = errorData['message'] ?? 'Failed to fetch followings';
      throw Exception(message);
    }
  }

  @override
  Future<UserEntity> getSingleFollowing(String username) async {
    // get user data
    final token = prefs.getString(_tokenKey);
    final url = Uri.parse("https://api.github.com/users/$username");
    final res = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/vnd.github+json',
    });
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch user data');
    }
  }
}
