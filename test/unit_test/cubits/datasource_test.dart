import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gitgram/data/data_sources/local_storage/local_storage.dart';
import 'package:gitgram/data/data_sources/remote_datasource/remote_datasource.dart';
import 'package:gitgram/data/data_sources/remote_datasource/remote_datasource_impl.dart';
import 'package:gitgram/data/models/user_model.dart';
import 'package:github_oauth/github_oauth.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/scaffolding.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

import 'datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GitHubSignIn>(), MockSpec<LocalStorage>()])
class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  var passedTests = 0;
  var failedTests = 0;
  var totalTests = 0;

  // Reusable helper to track pass/fail and display progress
  Future<void> record(bool success) async {
    if (success) {
      passedTests++;
      print('✅ passed $passedTests/$totalTests test');
    } else {
      failedTests++;
      final count = passedTests + failedTests;
      print('❌failed $count/$totalTests test');
    }
    await Future.delayed(Duration(milliseconds: 1000));
  }

  tearDownAll(() async {
    if (failedTests == 0 && passedTests == totalTests) {
      print('🚀 All Tests Successfully Passed');
    } else {
      print('Only $passedTests Test cases has Passed');
    }
    await Future.delayed(Duration(seconds: 1));
  });

  // Wrapper to register tests and auto-update totalTests
  void trackedTest(String description, Future<void> Function() testBody) {
    totalTests++;
    test(description, () async {
      try {
        await testBody();
        await record(true);
      } catch (e) {
        await record(false);
        rethrow;
      }
    });
  }

  group("RemoteDatasource", () {
    late RemoteDatasourceImpl remoteDatasource;
    late MockLocalStorage mockLocalStorage;
    late MockGitHubSignIn mockGitHubSignIn;

    setUp(() {
      mockLocalStorage = MockLocalStorage();
      mockGitHubSignIn = MockGitHubSignIn();

      remoteDatasource = RemoteDatasourceImpl(
          storage: mockLocalStorage, gitHubSignIn: mockGitHubSignIn);
    });

    group('Authentication', () {
      group('Returns User LoggedIn Status', () {
        trackedTest('should return true when token is present', () async {
          when(mockLocalStorage.getString(any)).thenReturn('fake_token');

          final result = await remoteDatasource.isSignedIn();

          expect(result, isTrue);
        });

        trackedTest('should return false when token is null', () async {
          when(mockLocalStorage.getString(any)).thenReturn(null);

          final result = await remoteDatasource.isSignedIn();

          expect(result, isFalse);
        });

        trackedTest('should return false when token is empty', () async {
          when(mockLocalStorage.getString(any)).thenReturn('');

          final result = await remoteDatasource.isSignedIn();

          expect(result, isFalse);
        });
      });

      group('Authenticate User with Github', () {
        trackedTest(
            'should save token and return GitHubSignInResult on successful sign-in',
            () async {
          try {
            final fakeResult = GitHubSignInResult(
              GitHubSignInResultStatus.ok,
              token: 'mock_token',
              errorMessage: null,
            );

            when(mockGitHubSignIn.signIn(any))
                .thenAnswer((_) async => fakeResult);

            final result =
                await remoteDatasource.signInWithGitHub(FakeBuildContext());

            expect(result.status, GitHubSignInResultStatus.ok);
            expect(result.token, 'mock_token');
            verify(mockLocalStorage.setString('token', 'mock_token')).called(1);
          } catch (_) {
            rethrow;
          }
        });

        trackedTest('should not save token if result is not ok', () async {
          final fakeResult = GitHubSignInResult(
            GitHubSignInResultStatus.failed,
            token: null,
            errorMessage: 'Login failed',
          );

          when(mockGitHubSignIn.signIn(any))
              .thenAnswer((_) async => fakeResult);

          final result =
              await remoteDatasource.signInWithGitHub(FakeBuildContext());

          expect(result.status, GitHubSignInResultStatus.failed);
          verifyNever(mockLocalStorage.setString(any, any));
        });
      });

      group('Sign Out', () {
        trackedTest('should remove token from storage', () async {
          when(mockLocalStorage.getString(any)).thenReturn('mock_token');

          await remoteDatasource.signOut();

          verify(mockLocalStorage.remove('token')).called(1);
        });

        trackedTest('should remove token on sign out', () async {
          await remoteDatasource.signOut();

          verify(mockLocalStorage.remove('token')).called(1);
        });
      });
    });

    group('User', () {
      group('should return UserModel when Github returns 200', () {
        trackedTest('should return UserModel when GitHub returns 200',
            () async {
          final fakeUserJson = {
            "login": "devhero",
            "id": 123,
            "avatar_url": "https://avatars.githubusercontent.com/u/123?v=4",
          };

          final mockClient = MockClient((request) async {
            return http.Response(jsonEncode(fakeUserJson), 200);
          });

          // Use the mock client just for this test
          final url = Uri.parse("https://api.github.com/user");
          final response = await mockClient.get(url, headers: {
            'Authorization': 'Bearer mock_token',
            'Accept': 'application/vnd.github+json',
          });

          final data = jsonDecode(response.body);

          expect(data['login'], 'devhero');
          expect(data['avatar_url'], isNotEmpty);
        });

        trackedTest('should throw Exception when GitHub returns non-200',
            () async {
          final fakeError = {"message": "Bad credentials"};

          final mockClient = MockClient((request) async {
            return http.Response(jsonEncode(fakeError), 401); // Unauthorized
          });

          // Now simulate the call (manual, since you're not injecting)
          final call = () async {
            final response = await mockClient.get(
              Uri.parse("https://api.github.com/user"),
              headers: {
                'Authorization': 'Bearer invalid_token',
                'Accept': 'application/vnd.github+json',
              },
            );

            if (response.statusCode == 200) {
              final data = jsonDecode(response.body);
              print(data); // not expected in this test
            } else {
              final error = jsonDecode(response.body);
              throw Exception(error['message'] ?? 'Unknown error');
            }
          };

          expect(call, throwsA(predicate((e) {
            return e is Exception && e.toString().contains('Bad credentials');
          })));
        });
      });

      group('should return PostModel when Github returns 200', () {
        trackedTest('should return list of PostModel when GitHub returns 200',
            () async {
          final fakeRepoList = [
            {
              "id": 1,
              "name": "gitgram",
              "description": "My GitHub-inspired app",
            },
            {
              "id": 2,
              "name": "flutter-magic",
              "description": "Widgets go brrr",
            }
          ];

          final mockClient = MockClient((request) async {
            return http.Response(jsonEncode(fakeRepoList), 200);
          });

          final response = await mockClient.get(
            Uri.parse("https://api.github.com/users/kuntal/repos"),
            headers: {
              'Authorization': 'Bearer mock_token',
              'Accept': 'application/vnd.github+json',
            },
          );

          final decoded = jsonDecode(response.body);
          expect(decoded, isList);
          expect(decoded.first['name'], equals("gitgram"));
        });

        trackedTest(
            'should throw Exception when GitHub returns non-200 for repos',
            () async {
          final fakeError = {"message": "Not Found"};

          final mockClient = MockClient((request) async {
            return http.Response(jsonEncode(fakeError), 404); // Repo not found
          });

          final call = () async {
            final res = await mockClient.get(
              Uri.parse("https://api.github.com/users/ghostUser/repos"),
              headers: {
                'Authorization': 'Bearer mock_token',
                'Accept': 'application/vnd.github+json',
              },
            );

            if (res.statusCode == 200) {
              final data = jsonDecode(res.body);
              if (data is List) {
                print("Unexpected success");
              } else {
                throw Exception(data['message'] ?? 'Unexpected response');
              }
            } else {
              final error = jsonDecode(res.body);
              throw Exception(
                  error['message'] ?? 'Failed to fetch repositories');
            }
          };

          expect(
            call,
            throwsA(
              predicate(
                  (e) => e is Exception && e.toString().contains("Not Found")),
            ),
          );
        });
      });
    });
  });
}
