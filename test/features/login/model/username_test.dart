import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_blog_app/features/login/login.dart';

void main() {
  const usernameString = 'mock-username';
  group('Login Username', () {
    group('constructors', () {
      test('pure creates correct instance', () {
        const username = Username.pure();
        expect(username.value, '');
        expect(username.pure, true);
      });

      test('dirty creates correct instance', () {
        const username = Username.dirty(usernameString);
        expect(username.value, usernameString);
        expect(username.pure, false);
      });
    });

    group('validator', () {
      test('returns empty error when username is empty', () {
        expect(
          const Username.dirty().error,
          UsernameValidationError.empty,
        );
      });

      test('is valid when username is not empty', () {
        expect(
          const Username.dirty(usernameString).error,
          isNull,
        );
      });
    });
  });
}
