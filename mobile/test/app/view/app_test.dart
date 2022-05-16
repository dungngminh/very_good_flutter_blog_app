// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_blog_app/app/app.dart';

void main() {
  group('VeryGoodBlogApp', () {
    testWidgets('renders VeryGoodBlogAppView', (tester) async {
      await tester.pumpWidget(const VeryGoodBlogApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.byType(VeryGoodBlogAppView), findsOneWidget);
    });
  });
}
