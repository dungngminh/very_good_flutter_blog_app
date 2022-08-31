// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:io';

import 'package:blog_data_source/blog_data_source.dart';
import 'package:firebase_storage_service/firebase_storage_service.dart';
import 'package:models/models.dart';
import 'package:secure_storage_helper/secure_storage_helper.dart';


/// {@template blog_repository}
/// A blog repository package
/// {@endtemplate}
class BlogRepository {
  /// {@macro blog_repository}
  BlogRepository({
    required BlogDataSource remoteDataSource,
    required FirebaseStorageService firebaseStorageSerivce,
  })  : _remoteDataSource = remoteDataSource,
        _firebaseStorageSerivce = firebaseStorageSerivce;

  final BlogDataSource _remoteDataSource;
  final FirebaseStorageService _firebaseStorageSerivce;

  Future<List<BlogModel>> getBlogs({
    required int page,
    int limit = 10,
  }) async {
    try {
      return _remoteDataSource.getBlogs(page: page, limit: limit);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteBlog(String blogId) async {
    try {
      final token =
          await SecureStorageHelper.readValueByKey(SecureStorageKey.jwt);
      return _remoteDataSource.deleteBlog(blogId, token: token!);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BlogModel>> getBlogsByCategory(
    String category, {
    required int page,
    int limit = 10,
  }) {
    try {
      return _remoteDataSource.getBlogsByCategory(
        category,
        page: page,
        limit: limit,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BlogModel>> searchBlogs(
    String search, {
    required int page,
    int limit = 10,
  }) {
    try {
      return _remoteDataSource.searchBlogs(
        search,
        page: page,
        limit: limit,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<BlogModel> getBlogById(String blogId) async {
    try {
      return _remoteDataSource.getBlogById(blogId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addBlog({
    required String title,
    required String content,
    required String category,
    required String imagePath,
  }) async {
    try {
      final uploadedImageUrl = await _uploadImageToFirebaseStorage(imagePath);
      final token =
          await SecureStorageHelper.readValueByKey(SecureStorageKey.jwt);
      await _remoteDataSource.addBlog(
        title: title,
        content: content,
        category: category,
        imageUrl: uploadedImageUrl!,
        token: token!,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateBlog({
    required BlogModel blog,
    required String imagePath,
  }) async {
    try {
      String? finalImage;
      final token =
          await SecureStorageHelper.readValueByKey(SecureStorageKey.jwt);
      if (imagePath != blog.imageUrl) {
        finalImage = await _uploadImageToFirebaseStorage(imagePath);
      } else {
        finalImage = blog.imageUrl;
      }
      return _remoteDataSource.updateBlog(
        blog.copyWith(imageUrl: finalImage),
        token: token!,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> likeBlog(String blogId) async {
    try {
      final token =
          await SecureStorageHelper.readValueByKey(SecureStorageKey.jwt);
      return _remoteDataSource.likeBlog(blogId, token: token!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unlikeBlog(String blogId) async {
    try {
      final token =
          await SecureStorageHelper.readValueByKey(SecureStorageKey.jwt);
      return _remoteDataSource.unlikeBlog(blogId, token: token!);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BlogModel>> getBlogsByUserId(String userId) async {
    try {
      return _remoteDataSource.getBlogsByUserId(userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getLikedBlog() async {
    try {
      final token =
          await SecureStorageHelper.readValueByKey(SecureStorageKey.jwt);
      return _remoteDataSource.getLikedBlog(token: token!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addBlogToBookmark(String blogId) async {
    try {
      final token =
          await SecureStorageHelper.readValueByKey(SecureStorageKey.jwt);
      return _remoteDataSource.addBlogToBookmark(blogId, token: token!);
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> _uploadImageToFirebaseStorage(String imagePath) async {
    try {
      final now = DateTime.now();
      final formatedDate = '${now.millisecondsSinceEpoch}';
      final imageUrl = await _firebaseStorageSerivce.saveImageToStorage(
        folder: 'blogs',
        name: formatedDate,
        file: File(imagePath),
      );
      return imageUrl;
    } catch (e) {
      rethrow;
    }
  }
}
