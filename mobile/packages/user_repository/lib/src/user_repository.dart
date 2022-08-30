// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:io';

import 'package:firebase_storage_service/firebase_storage_service.dart';
import 'package:secure_storage_helper/secure_storage_helper.dart';
import 'package:user_data_source/user_data_source.dart';

/// {@template user_repository}
/// A User Repository package
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  UserRepository({
    required FirebaseStorageService firebaseStorageService,
    required UserDataSource userDataSource,
  })  : _firebaseStorageService = firebaseStorageService,
        _userDataSource = userDataSource;

  final FirebaseStorageService _firebaseStorageService;
  final UserDataSource _userDataSource;

  Future<UserModel?> getUserInformationByUserId(String userId) async {
    try {
      return _userDataSource.getUserInformationByUserId(userId);
    } catch (e) {
      rethrow;
      //TODO(dungngminh): Throw specific exception
    }
  }

  Future<void> updateUserInformation({
    required String userId,
    required String firstname,
    required String lastname,
    required String imagePath,
    required String username,
  }) async {
    try {
      String? uploadedImageUrl = imagePath;
      if (!imagePath.contains('firebasestorage')) {
        uploadedImageUrl = await _firebaseStorageService.saveImageToStorage(
          folder: 'users',
          name: userId,
          file: File(imagePath),
        );
      }
      final token =
          await SecureStorageHelper.readValueByKey(SecureStorageKey.jwt);
      await _userDataSource.updateUserInformation(
        userId: userId,
        username: username,
        firstname: firstname,
        lastname: lastname,
        imagePath: uploadedImageUrl!,
        token: token!,
      );
    } catch (e) {
      rethrow;
      //TODO(dungngminh): Throw specific exception
    }
  }
}
