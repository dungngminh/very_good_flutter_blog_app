import 'dart:io';

import 'package:blog_data_source/blog_data_source.dart';
import 'package:http_client_handler/http_client_handler.dart';
import 'package:models/models.dart';

class BlogRemoteDataSource implements BlogDataSource {
  BlogRemoteDataSource({HttpClientHandler? httpClientHandler})
      : _httpClientHandler = httpClientHandler ?? HttpClientHandler();

  final HttpClientHandler _httpClientHandler;

  @override
  Future<BlogModel> getBlogById(String blogId) async {
    try {
      final jsonBody = await _httpClientHandler.get(
        '/blogs/$blogId',
      );
      return BlogModel.fromJson(jsonBody as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<BlogModel>> getBlogs({required int page, int limit = 10}) async {
    try {
      final jsonBody = await _httpClientHandler.get(
        '/blogs',
        queryParameter: <String, dynamic>{
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

  /// This function will return a list of blog model by category
  ///
  /// Args:
  ///   category (String): The category of the blog.
  ///   page (int): The page number of the blog list.
  ///   limit (int): The number of blogs to return. Defaults to 10
  ///
  /// Returns:
  ///   A list of BlogModel
  @override
  Future<List<BlogModel>> getBlogsByCategory(
    String category, {
    required int page,
    int limit = 10,
  }) async {
    try {
      final jsonBody = await _httpClientHandler.get(
        '/blogs',
        queryParameter: <String, dynamic>{
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

  /// It searches for blogs with the given search string.
  ///
  /// Args:
  ///   search (String): The search query
  ///   page (int): The page number of the search results.
  ///   limit (int): The number of blogs to return. Defaults to 10
  ///
  /// Returns:
  ///   A list of BlogModel
  @override
  Future<List<BlogModel>> searchBlogs(
    String search, {
    required int page,
    int limit = 10,
  }) async {
    try {
      final jsonBody = await _httpClientHandler.get(
        '/blogs',
        queryParameter: <String, String>{
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

  @override
  Future<void> deleteBlog(String blogId, {required String token}) async {
    try {
      await _httpClientHandler.delete(
        '/blogs/$blogId',
        headers: <String, String>{
          HttpHeaders.authorizationHeader: token,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> likeBlog(String blogId, {required String token}) async {
    try {
      await _httpClientHandler.post(
        '/likes',
        body: <String, dynamic>{
          'blog_id': blogId,
        },
        headers: <String, String>{
          HttpHeaders.authorizationHeader: token,
          HttpHeaders.contentTypeHeader: 'application/json'
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addBlogToBookmark(
    String blogId, {
    required String token,
  }) async {
    try {
      await _httpClientHandler.post(
        '/bookmarks',
        body: <String, dynamic>{
          'blog_id': blogId,
        },
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: token,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<BlogModel>> getBlogsByUserId(String userId) async {
    try {
      final jsonBody = await _httpClientHandler.get(
        '/blogs',
        queryParameter: <String, dynamic>{
          'author_id': userId,
        },
      ) as List;
      final blogs = jsonBody
          .map(
            (e) => BlogModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      return blogs;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getLikedBlog({required String token}) async {
    try {
      final jsonBody = await _httpClientHandler.get(
        '/likes',
        headers: <String, String>{
          HttpHeaders.authorizationHeader: token,
        },
      ) as List;
      final blogs = jsonBody
          .map(
            (e) => (e as Map<String, dynamic>)['blog_id'] as String,
          )
          .toList();
      return blogs;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> unlikeBlog(String blogId, {required String token}) async {
    try {
      await _httpClientHandler.delete(
        '/likes',
        body: <String, dynamic>{
          'blog_id': blogId,
        },
        headers: <String, String>{
          HttpHeaders.authorizationHeader: token,
          HttpHeaders.contentTypeHeader: 'application/json'
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateBlog(BlogModel blog, {required String token}) async {
    try {
      await _httpClientHandler.put(
        '/blogs/${blog.id}',
        body: blog.toJson(),
        headers: <String, String>{
          HttpHeaders.authorizationHeader: token,
          HttpHeaders.contentTypeHeader: 'application/json'
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addBlog({
    required String title,
    required String content,
    required String category,
    required String imageUrl,
    required String token,
  }) async {
    try {
      await _httpClientHandler.post(
        '/blogs',
        body: <String, dynamic>{
          'content': content,
          'image_url': imageUrl,
          'title': title,
          'category': [category],
        },
        headers: <String, String>{
          HttpHeaders.authorizationHeader: token,
          HttpHeaders.contentTypeHeader: 'application/json'
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
