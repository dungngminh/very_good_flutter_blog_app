// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:blog_data_source/blog_data_source.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

class MockBlogDataSource implements BlogDataSource {
  @override
  Future<BlogModel> getBlogById(String blogId) {
    throw UnimplementedError();
  }

  @override
  Future<List<BlogModel>> getBlogs({required int page, int limit = 10}) {
    throw UnimplementedError();
  }

  @override
  Future<List<BlogModel>> getBlogsByCategory(
    String category, {
    required int page,
    int limit = 10,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<BlogModel>> searchBlogs(
    String search, {
    required int page,
    int limit = 10,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<BlogModel>> getBlogsByUserId(String userId) {
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getLikedBlog({required String token}) {
    throw UnimplementedError();
  }

  @override
  Future<void> unlikeBlog(String blogId, {required String token}) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateBlog(BlogModel blog, {required String token}) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteBlog(String blogId, {required String token}) {
    throw UnimplementedError();
  }

  @override
  Future<void> likeBlog(String blogId, {required String token}) {
    throw UnimplementedError();
  }

  @override
  Future<void> addBlog({
    required String title,
    required String content,
    required String category,
    required String imageUrl,
    required String token,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> addBlogToBookmark(String blogId, {required String token}) {
    throw UnimplementedError();
  }
}

void main() {
  group('BlogDataSource', () {
    test('can be implemented', () {
      expect(MockBlogDataSource(), isNotNull);
    });
  });
}
