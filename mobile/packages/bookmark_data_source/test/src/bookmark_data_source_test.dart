// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:bookmark_data_source/bookmark_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

class MockBookmarkDataSource implements BookmarkDataSource {
  @override
  Future<void> addBookmark(BlogModel blog) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeBookmark(String blogId) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeAllBookmarks() {
    throw UnimplementedError();
  }

  @override
  FutureOr<List<BlogModel>> getBookmarks({String token = ''}) {
    throw UnimplementedError();
  }
}

void main() {
  group('BookmarkDataSource', () {
    test('can be instantiated', () {
      expect(MockBookmarkDataSource(), isNotNull);
    });
  });
}
