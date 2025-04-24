import 'package:flutter/material.dart';
import 'package:gitgram/data/data_sources/local_storage/local_storage.dart';
import 'package:gitgram/data/data_sources/remote_datasource/remote_datasource.dart';
import 'package:gitgram/data/data_sources/remote_datasource/remote_datasource_impl.dart';
import 'package:github_oauth/github_oauth.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/scaffolding.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

import 'auth_datasource_test.mocks.dart';

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

        when(mockGitHubSignIn.signIn(any)).thenAnswer((_) async => fakeResult);

        final result =
            await remoteDatasource.signInWithGitHub(FakeBuildContext());

        expect(result.status, GitHubSignInResultStatus.failed);
        verifyNever(mockLocalStorage.setString(any, any));
      });
    });
  });
}
