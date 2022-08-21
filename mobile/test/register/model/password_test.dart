import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_blog_app/register/register.dart';

void main() {
  const longPassword = 'thisislongpass';
  const shortPassword = 'short';

  group('Register password', () {
    group('constructors', () {
      test('pure creates correct instance', () {
        const password = Password.pure();
        expect(password.value, '');
        expect(password.pure, true);
      });

      test('dirty creates correct instance', () {
        const password = Password.dirty();
        expect(password.value, '');
        expect(password.pure, false);
      });
    });

    group('validates when dirty', () {
      test('return empty error when password is empty', () {
        expect(
          const Password.dirty().error,
          PasswordValidationError.empty,
        );
      });
      test('return too short error when password is not empty and, short < 8',
          () {
        expect(
          const Password.dirty(shortPassword).error,
          PasswordValidationError.tooShort,
        );
      });
      test('return NO error when password is not empty and long >= 8', () {
        expect(
          const Password.dirty(longPassword).error,
          isNull,
        );
      });
    });
  });
}
