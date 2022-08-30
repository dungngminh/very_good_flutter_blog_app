// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

/// {@template authentication_data_source}
/// An Authentication Data source
/// {@endtemplate}
abstract class AuthenticationDataSource {
  Future<dynamic> login({
    required String username,
    required String password,
  });

  Future<void> register({
    required String lastname,
    required String firstname,
    required String username,
    required String password,
    required String confirmationPassword,
  });

  // Future<void> logout();
}
