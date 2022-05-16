import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_blog_app/features/login/login.dart';

void main() {
  const username = 'mock-username';
  const password = 'mock-password';
  group('LoginEvent', () {
    group('LoginUsernameChanged', () {
      test('supports value comparisons', () {
        expect(
          const LoginUsernameChanged(username),
          const LoginUsernameChanged(username),
        );
      });
    });

    group('LoginPasswordChanged', () {
      test('supports value comparisons', () {
        expect(
          const LoginPasswordChanged(password),
          const LoginPasswordChanged(password),
        );
      });
    });

    group('LoginSubmitted', () {
      test('supports value comparisons', () {
        expect(const LoginSubmitted(), const LoginSubmitted());
      });
    });
  });
}
