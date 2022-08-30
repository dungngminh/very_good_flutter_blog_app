// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

/// {@template firebase_storage_service}
/// A Firebase storage service
/// {@endtemplate}
class FirebaseStorageService {
  /// {@macro firebase_storage_service}
  FirebaseStorageService({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  final FirebaseStorage _firebaseStorage;

  Future<String?> saveImageToStorage({
    required String folder,
    required String name,
    required File file,
  }) async {
    try {
      final ref = _firebaseStorage.ref().child(folder).child('$name.jpg');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }
}
