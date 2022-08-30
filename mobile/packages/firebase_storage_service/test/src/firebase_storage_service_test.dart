// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: prefer_const_constructors, join_return_with_assignment
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_service/src/firebase_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFirebaseStorage extends Mock implements FirebaseStorage {}

class _MockReference extends Mock implements Reference {}

class _MockUploadTask extends Mock implements UploadTask {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FirebaseStorage storage;
  late FirebaseStorageService firebaseStorageSerivce;
  late File fileTest;
  group('FirebaseStorageService', () {
    setUp(
      () {
        storage = _MockFirebaseStorage();
        firebaseStorageSerivce =
            FirebaseStorageService(firebaseStorage: storage);
        const imageTest = 'komkat.jpeg';
        final directory = '${Directory.current.path}/assets/$imageTest';
        fileTest = File(directory);
        final ref = _MockReference();
        final uploadTask = _MockUploadTask();

        when(
          () => storage.ref().child(any()).child('test.jpg'),
        ).thenAnswer((_) => ref);

        when(
          () => ref.putFile(fileTest),
        ).thenAnswer(
          (_) => uploadTask,
        );
      },
    );

    test(
      'should return a image url when sent a image from local to storage',
      () async {
        final result = await firebaseStorageSerivce.saveImageToStorage(
          file: fileTest,
          folder: 'test',
          name: 'test',
        );
        expect(result?.contains('firebasestorage.googleapis.com'), true);
      },
    );
  });
}
