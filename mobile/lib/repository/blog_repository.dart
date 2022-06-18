import 'dart:developer';
import 'dart:io';

import 'package:very_good_blog_app/app/config/helpers/secure_storage_helper.dart';
import 'package:very_good_blog_app/data/firebase/storage_firebase.dart';
import 'package:very_good_blog_app/data/remote/good_blog_client.dart';

class BlogRepository {
  BlogRepository({
    GoodBlogClient? blogClient,
    StorageFirebase? storageFirebase,
  })  : _blogClient = blogClient ?? GoodBlogClient(),
        _storageFirebase = storageFirebase ?? StorageFirebase();

  final GoodBlogClient _blogClient;
  final StorageFirebase _storageFirebase;

  Future<void> addBlog({
    required String title,
    required String imagePath,
    required String category,
    required String content,
  }) async {
    try {
      final token = await SecureStorageHelper.getValueByKey('jwt');
      final uploadedImageUrl = await _uploadImageToFirebaseStorage(imagePath);

      await _blogClient.post(
        '/blogs',
        body: <String, dynamic>{
          'content': {'data': content},
          'image_url': uploadedImageUrl,
          'title': title,
          'category': [category],
        },
        headers: <String, String>{
          'Authorization': token!,
          'Content-Type': 'application/json'
        },
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<String?> _uploadImageToFirebaseStorage(String imagePath) async {
    try {
      final now = DateTime.now();
      final formatedDate = '${now.day}-${now.month}-${now.year}';
      final imageUrl = await _storageFirebase.saveImageToStorage(
        folder: 'blogs',
        name: formatedDate,
        file: File(imagePath),
      );
      log(imageUrl!);
      return imageUrl;
    } catch (e) {
      rethrow;
    }
  }
}
