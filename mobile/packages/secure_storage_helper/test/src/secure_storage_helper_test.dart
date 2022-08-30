// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:secure_storage_helper/secure_storage_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('SecureStorageHelper', () {
    test('can be implemented', () {
      expect(SecureStorageHelper, isNotNull);
    });
  });
}
