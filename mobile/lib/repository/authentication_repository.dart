import 'dart:async';
import 'dart:developer';

import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/app/config/helpers/secure_storage_helper.dart';
import 'package:very_good_blog_app/data/remote/good_blog_client.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
  successfullyRegistered,
  existed,
  unsuccessfullyRegistered,
}

class AuthenticationRepository {
  AuthenticationRepository({
    GoodBlogClient? blogClient,
  }) : _blogClient = blogClient ?? GoodBlogClient();

  final GoodBlogClient _blogClient;
  final _controller = StreamController<AuthenticationStatus>();

  //action
  Stream<AuthenticationStatus> get status async* {
    final token = await SecureStorageHelper.getValueByKey('jwt');
    log('token $token');
    await Future<void>.delayed(const Duration(seconds: 1));
    if (token == null) {
      yield AuthenticationStatus.unauthenticated;
    } else {
      yield AuthenticationStatus.authenticated;
    }

    yield* _controller.stream;
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    try {
      final body = <String, dynamic>{
        'username': username,
        'password': password,
      };
      final jsonBody = await _blogClient.post(
        '/auth/login',
        body: body,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      ) as Map<String, dynamic>;
      final token = jsonBody['jwt'] as String;
      log('token $token');

      await SecureStorageHelper.writeValueToKey(key: 'jwt', value: token);
      _controller.add(AuthenticationStatus.authenticated);
    } on ConnectionExpcetion catch (e1) {
      log(e1.toString());
    } on UnauthorizedException catch (e2) {
      log(e2.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register({
    required String lastname,
    required String firstname,
    required String username,
    required String password,
    required String confirmationPassword,
  }) async {
    try {
      final body = <String, dynamic>{
        'username': username,
        'first_name': firstname,
        'last_name': lastname,
        'password': password,
        'confirmation_password': confirmationPassword,
      };

      await _blogClient.post(
        '/auth/register',
        body: body,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      _controller.add(AuthenticationStatus.successfullyRegistered);
    } on ConnectionExpcetion catch (e1) {
      log(e1.toString());
      _controller.add(AuthenticationStatus.unsuccessfullyRegistered);
    } on BadRequestedExpcetion catch (e2) {
      log(e2.toString());
      _controller.add(AuthenticationStatus.existed);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logOut() async {
    await SecureStorageHelper.deleteValueFromKey('jwt');
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
