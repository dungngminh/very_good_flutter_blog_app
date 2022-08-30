// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:io';

import 'package:bookmark_data_source/bookmark_data_source.dart';

/// {@template bookmark_repository}
/// A very good bookmark repository
/// {@endtemplate}
class BookmarkRepository {
  /// {@macro bookmark_repository}
  const BookmarkRepository({
    required BookmarkDataSource remoteDataSource,
    required BookmarkDataSource localDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  final BookmarkDataSource _remoteDataSource;
  final BookmarkDataSource _localDataSource;

  FutureOr<List<BlogModel>> getBookmarks() async {
    try {
      final bookmarks = await _remoteDataSource.getBookmarks();
      for (final bookmark in bookmarks) {
        await _localDataSource.addBookmark(bookmark);
      }
      return bookmarks;
    } on SocketException {
      return _localDataSource.getBookmarks();
    }
  }

  Future<void> addBookmark(BlogModel blog) async {
    try {
      return _remoteDataSource
          .addBookmark(blog)
          .then((_) => _localDataSource.addBookmark(blog));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeBookmark(BlogModel blog) {
    try {
      return _remoteDataSource
          .removeBookmark(
            blog.id,
          )
          .then(
            (_) => _localDataSource.removeBookmark(blog.id),
          );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeAllBookmarks() => _localDataSource.removeAllBookmarks();
}
