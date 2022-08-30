// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:models/models.dart';

/// {@template user_data_source}
/// An User data source
/// {@endtemplate}
abstract class UserDataSource {
  Future<UserModel?> getUserInformationByUserId(String userId);

  Future<void> updateUserInformation({
    required String userId,
    required String firstname,
    required String lastname,
    required String imagePath,
    required String username,
    required String token,
  });
}
