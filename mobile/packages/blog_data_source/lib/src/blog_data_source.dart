// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:models/models.dart';

/// {@template blog_data_source}
/// A blog data source package
/// {@endtemplate}
abstract class BlogDataSource {
  Future<List<BlogModel>> getBlogs({required int page, int limit = 10});

  Future<List<BlogModel>> getBlogsByCategory(
    String category, {
    required int page,
    int limit = 10,
  });
  Future<List<BlogModel>> searchBlogs(
    String search, {
    required int page,
    int limit = 10,
  });

  Future<BlogModel> getBlogById(String blogId);

  Future<void> addBlog({
    required String title,
    required String content,
    required String category,
    required String imageUrl,
    required String token,
  });

  Future<void> deleteBlog(String blogId, {required String token});

  Future<void> likeBlog(String blogId, {required String token});

  Future<void> updateBlog(BlogModel blog, {required String token});

  Future<void> unlikeBlog(String blogId, {required String token});

  Future<List<BlogModel>> getBlogsByUserId(String userId);

  Future<List<String>> getLikedBlog({required String token});

  Future<void> addBlogToBookmark(String blogId, {required String token});
}
