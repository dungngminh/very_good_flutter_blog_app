import 'dart:convert';

import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/data/data.dart';
import 'package:very_good_blog_app/models/models.dart';

class BookmarkRepository {
  const BookmarkRepository({
    required GoodBlogClient blogClient,
    required BookmarkLocalBox bookmarkLocalBox,
  })  : _blogClient = blogClient,
        _bookmarkLocalBox = bookmarkLocalBox;

  final GoodBlogClient _blogClient;
  final BookmarkLocalBox _bookmarkLocalBox;

  Future<List<BlogModel>> getBookmarks() async {
    try {
      final token =
          await SecureStorageHelper.getValueByKey(SecureStorageHelper.jwt);

      final jsonBody = await _blogClient.get(
        '/bookmarks',
        headers: <String, String>{
          'Authorization': token!,
        },
      ) as List;
      if (jsonBody.isEmpty) return [];
      return jsonBody
          .map(
            (e) => BlogModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addBookmark({
    required BlogModel blog,
  }) async {
    try {
      final token =
          await SecureStorageHelper.getValueByKey(SecureStorageHelper.jwt);

      await _blogClient.post(
        '/bookmarks',
        body: {'blog_id': blog.id},
        headers: <String, String>{
          'Authorization': token!,
          'Content-Type': 'application/json',
        },
      );
      await _bookmarkLocalBox.add(blog: blog);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addBookmarkToLocal({
    required BlogModel blog,
  }) =>
      _bookmarkLocalBox.add(blog: blog);

  Future<void> removeBookmark({
    required BlogModel blog,
  }) async {
    try {
      final token =
          await SecureStorageHelper.getValueByKey(SecureStorageHelper.jwt);
      await _bookmarkLocalBox.delete(blogId: blog.id);
      await _blogClient.delete(
        '/bookmarks',
        body: {'blog_id': blog.id},
        headers: <String, String>{
          'Authorization': token!,
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  List<BlogModel> getBookmarksInLocalBox() {
    final dataInBox = _bookmarkLocalBox.rawBookmarkData;
    final bookmarks = dataInBox
        .map(
          (e) => BlogModel.fromJson(
            jsonDecode(e as String) as Map<String, dynamic>,
          ),
        )
        .toList();
    return bookmarks;
  }
}
