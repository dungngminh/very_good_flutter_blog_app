import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

abstract class StorageFirebaseHelper {
  static final _firebaseStorage = FirebaseStorage.instance;

  static Future<String?> saveImageToStorage({
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
