import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_blog_app/login/login.dart';

void main() {
  const passwordLong = 'mock-password';
  const passwordShort = 'mock';
  group('Login Password', () {
    group('constructors', () {
      test('pure creates correct instance', () {
        const password = Password.pure();
        expect(password.value, '');
        expect(password.pure, true);
      });

      test('dirty creates correct instance', () {
        const password = Password.dirty(passwordLong);
        expect(password.value, passwordLong);
        expect(password.pure, false);
      });
    });

    group('validator', () {
      test('returns empty error when password is empty', () {
        expect(
          const Password.dirty().error,
          PasswordValidationError.empty,
        );
      });

      test('is valid when password is not empty and short < 8', () {
        expect(
          const Password.dirty(passwordShort).error,
          PasswordValidationError.tooShort,
        );
      });

      test('is valid when password is not empty and long >= 8', () {
        expect(
          const Password.dirty(passwordLong).error,
          isNull,
        );
      });
    });
  });
}
