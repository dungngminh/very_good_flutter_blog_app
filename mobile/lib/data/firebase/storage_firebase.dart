import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageFirebase {
  StorageFirebase({FirebaseStorage? firebaseStorage})
      : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

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
