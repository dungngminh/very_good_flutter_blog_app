import 'dart:async';
import 'dart:convert';

import 'package:bookmark_data_source/bookmark_data_source.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BookmarkLocalDataSource implements BookmarkDataSource {
  BookmarkLocalDataSource({required Box<String> localBox})
      : _localBox = localBox;

  final Box<String> _localBox;
  @override
  Future<void> addBookmark(BlogModel blog) {
    return _localBox.put(blog.id, jsonEncode(blog.toJson()));
  }

  @override
  FutureOr<List<BlogModel>> getBookmarks({String token = ''}) {
    final data = _localBox.values;
    return data
        .map(
          (e) => BlogModel.fromJson(
            jsonDecode(e) as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  @override
  Future<void> removeBookmark(String blogId) => _localBox.delete(blogId);

  @override
  Future<void> removeAllBookmarks() => _localBox.deleteAll(_localBox.keys);
}
