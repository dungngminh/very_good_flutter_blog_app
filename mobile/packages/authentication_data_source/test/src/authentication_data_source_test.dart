// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';

import 'authentication_data_source_mock.dart';

void main() {
  group('AuthenticationDataSource', () {
    test('can be implemented', () {
      expect(MockAuthenticationDataSource(), isNotNull);
    });
  });
}
