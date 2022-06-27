import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:very_good_blog_app/models/models.dart';

class BookmarkLocalBox {
  BookmarkLocalBox({required Box bookmarkBox}) : _bookmarkBox = bookmarkBox;
  final Box _bookmarkBox;

  Future<void> add({required BlogModel blog}) async {
    if (!_bookmarkBox.containsKey(blog.id)) {
      await _bookmarkBox.put(blog.id, jsonEncode(blog.toJson()));
    }
  }

  Iterable get rawBookmarkData => _bookmarkBox.values;

  Future<void> delete({required String blogId}) => _bookmarkBox.delete(blogId);

  Future<void> deleteAll() => _bookmarkBox.deleteAll(_bookmarkBox.keys);
}
