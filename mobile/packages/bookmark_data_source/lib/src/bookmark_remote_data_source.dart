import 'dart:async';
import 'dart:io';

import 'package:bookmark_data_source/bookmark_data_source.dart';
import 'package:http_client_handler/http_client_handler.dart';
import 'package:secure_storage_helper/secure_storage_helper.dart';

class BookmarkRemoteDataSource implements BookmarkDataSource {
  BookmarkRemoteDataSource({required HttpClientHandler httpClientHandler})
      : _httpClientHandler = httpClientHandler;

  final HttpClientHandler _httpClientHandler;

  @override
  Future<void> addBookmark(BlogModel blog) async {
    try {
      final token = await _getToken();
      return _httpClientHandler.post(
        '/bookmarks',
        body: {'blog_id': blog.id},
        headers: <String, String>{
          HttpHeaders.authorizationHeader: token!,
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  FutureOr<List<BlogModel>> getBookmarks() async {
    try {
      final token = await _getToken();
      final jsonData = await _httpClientHandler.get(
        '/bookmarks',
        headers: <String, String>{
          HttpHeaders.authorizationHeader: token!,
        },
      ) as List;
      if (jsonData.isEmpty) return [];
      return jsonData
          .map((e) => BlogModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeAllBookmarks() {
    throw UnimplementedError();
  }

  @override
  Future<void> removeBookmark(String blogId) async {
    try {
      final token = await _getToken();
      return _httpClientHandler.delete(
        '/bookmarks',
        body: {
          'blog_id': blogId,
        },
        headers: <String, String>{
          HttpHeaders.authorizationHeader: token!,
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> _getToken() async {
    final token =
        await SecureStorageHelper.readValueByKey(SecureStorageKey.jwt);
    return token;
  }
}
