// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:authentication_data_source/authentication_data_source.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:secure_storage_helper/secure_storage_helper.dart';

/// {@template authentication_repository}
/// A Authentication Repository
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository({required AuthenticationDataSource dataSource})
      : _dataSource = dataSource;

  final AuthenticationDataSource _dataSource;

  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    final token =
        await SecureStorageHelper.readValueByKey(SecureStorageKey.jwt);
    if (token == null) {
      yield AuthenticationStatus.unauthenticated;
      // } else {
      //   final isHasInternet = await ConnectivityHelper.isInternetOnline();
      //   if (isHasInternet) {
      //     yield AuthenticationStatus.authenticated;
      //   } else {
      //     yield AuthenticationStatus.authenticatedOffline;
      //   }
    } else {
      yield AuthenticationStatus.authenticated;
    }

    yield* _controller.stream;
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    try {
      final data = await _dataSource.login(
        username: username,
        password: password,
      ) as Map<String, dynamic>;
      final token = data['jwt'] as String;
      final userId = data['id'] as String;
      await SecureStorageHelper.writeValueToKey(
        key: SecureStorageKey.jwt,
        value: token,
      );
      await SecureStorageHelper.writeValueToKey(
        key: SecureStorageKey.userId,
        value: userId,
      );
      _controller.add(AuthenticationStatus.authenticated);
    } catch (error, stackTrace) {
      throw LoginException(error, stackTrace);
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
      return _dataSource
          .register(
            lastname: lastname,
            firstname: firstname,
            username: username,
            password: password,
            confirmationPassword: confirmationPassword,
          )
          .then(
            (_) => _controller.add(AuthenticationStatus.successfullyRegistered),
          );
    } catch (err, stackTrace) {
      _controller.add(AuthenticationStatus.unsuccessfullyRegistered);
      throw RegisterException(err, stackTrace);
    }
  }

  Future<void> logout() async {
    try {
      return SecureStorageHelper.deleteAllKeys()
          .then((_) => _controller.add(AuthenticationStatus.unauthenticated));
    } catch (e, stackTrace) {
      throw LogoutException(e, stackTrace);
    }
  }

  void dispose() {
    _controller.close();
  }
}
