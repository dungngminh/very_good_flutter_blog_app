import 'dart:developer';
import 'dart:io';

import 'package:very_good_blog_app/app/config/helpers/secure_storage_helper.dart';
import 'package:very_good_blog_app/app/config/helpers/storage_firebase_helper.dart';
import 'package:very_good_blog_app/data/remote/good_blog_client.dart';
import 'package:very_good_blog_app/models/models.dart' show BlogModel;

class BlogRepository {
  BlogRepository({
    GoodBlogClient? blogClient,
  }) : _blogClient = blogClient ?? GoodBlogClient();

  final GoodBlogClient _blogClient;

  Future<List<BlogModel>> getBlogs({
    required int page,
    int limit = 10,
  }) async {
    try {
      final jsonBody = await _blogClient.get(
        '/blogs',
        queryParams: <String, dynamic>{
          'page': page.toString(),
          'limit': limit.toString(),
        },
      ) as List;
      if (jsonBody.isEmpty) return [];

      final listBlog = jsonBody
          .map((e) => BlogModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return listBlog;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BlogModel>> getBlogsByCategory(
    String category, {
    required int page,
    int limit = 10,
  }) async {
    try {
      final jsonBody = await _blogClient.get(
        '/blogs',
        queryParams: <String, dynamic>{
          'category': category,
          'page': page.toString(),
          'limit': limit.toString(),
        },
      ) as List;
      if (jsonBody.isEmpty) return [];
      final listBlog = jsonBody
          .map((e) => BlogModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return listBlog;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BlogModel>> searchBlogs(
    String search, {
    required int page,
    int limit = 10,
  }) async {
    try {
      final jsonBody = await _blogClient.get(
        '/blogs',
        queryParams: <String, dynamic>{
          'search': search,
          'page': page.toString(),
          'limit': limit.toString(),
        },
      ) as List;
      if (jsonBody.isEmpty) return [];
      final listBlog = jsonBody
          .map((e) => BlogModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return listBlog;
    } catch (e) {
      rethrow;
    }
  }

  Future<BlogModel> getBlogById(String blogId) async {
    try {
      final jsonBody = await _blogClient.get(
        '/blogs/$blogId',
      );
      return BlogModel.fromJson(jsonBody as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

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
          'content': content,
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

  Future<void> likeBlog(String blogId) async {
    try {
      await _blogClient.post(
        '/blogs',
        body: <String, dynamic>{
          'blog_id': blogId,
        },
        headers: <String, String>{'Content-Type': 'application/json'},
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<BlogModel>> getBlogsByUserId(String userId) async {
    // try {
    final jsonBody = await _blogClient.get(
      '/blogs',
      queryParams: <String, dynamic>{
        'id': userId,
      },
    ) as List;
    final blogs = jsonBody
        .map(
          (e) => BlogModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
    return blogs;
    // } catch (e) {
    //   log(e.toString());
    //   rethrow;
    // }
  }

  Future<void> addBlogToBookmark(BlogModel blog) async {
    try {
      final token = await SecureStorageHelper.getValueByKey('jwt');
      await _blogClient.post(
        '/bookmarks',
        body: <String, dynamic>{
          'blog_id': blog.id,
        },
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': token!,
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
      final formatedDate = '${now.millisecondsSinceEpoch}';
      final imageUrl = await StorageFirebaseHelper.saveImageToStorage(
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
