import 'dart:developer';
import 'dart:io';

import 'package:very_good_blog_app/app/config/helpers/secure_storage_helper.dart';
import 'package:very_good_blog_app/app/config/helpers/storage_firebase_helper.dart';
import 'package:very_good_blog_app/data/remote/good_blog_client.dart';
import 'package:very_good_blog_app/models/models.dart';

class UserRepository {
  UserRepository({GoodBlogClient? blogClient})
      : _blogClient = blogClient ?? GoodBlogClient();

  late final GoodBlogClient _blogClient;

  Future<UserModel?> getUserInformationByUserId(String userId) async {
    try {
      final jsonBody = await _blogClient.get('/users/$userId');
      log(jsonBody.toString());
      return UserModel.fromJson(jsonBody as Map<String, dynamic>);
    } catch (e) {
      // throw Exception('can not get user information');
      rethrow;
    }
  }

  Future<void> updateUserInformation({
    required String userId,
    required String firstName,
    required String lastName,
    required String imagePath,
    required String username,
  }) async {
    try {
      String? uploadedImageUrl = imagePath;
      log(uploadedImageUrl);
      if (!imagePath.contains('firebasestorage')) {
        uploadedImageUrl = await StorageFirebaseHelper.saveImageToStorage(
          folder: 'users',
          name: userId,
          file: File(imagePath),
        );
      }
      final token = await SecureStorageHelper.getValueByKey('jwt');
      final body = <String, String>{
        'first_name': firstName,
        'last_name': lastName,
        'avatar': uploadedImageUrl!,
        '_id': userId,
        'username': username,
      };
      await _blogClient.put(
        '/users/$userId',
        body: body,
        headers: <String, String>{
          'Authorization': token!,
          'Content-Type': 'application/json'
        },
      );
    } catch (e) {
      throw Exception('Lỗi cập nhật thông tin, vui lòng thử lại');
    }
  }
}
