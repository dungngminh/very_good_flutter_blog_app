// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:models/models.dart';

/// {@template bookmark_data_source}
/// A bookmark data source
/// {@endtemplate}
abstract class BookmarkDataSource {
  /// It's a way to return a `Future<List<BlogModel>>` or a `List<BlogModel>`
  FutureOr<List<BlogModel>> getBookmarks();

  /// It's adding a bookmark to the database.
  Future<void> addBookmark(BlogModel blog);

  /// It's removing a bookmark from the database.
  Future<void> removeBookmark(String blogId);

  /// It's removing all the bookmarks from the database.
  Future<void> removeAllBookmarks();
}
