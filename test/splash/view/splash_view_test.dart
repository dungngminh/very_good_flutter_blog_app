import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_blog_app/features/splash/view/splash_view.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SplashView', () {
    testWidgets('renders CircularProgressIndicator', (tester) async {
      await tester.pumpApp(const SplashView());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
