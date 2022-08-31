import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_blog_app/register/register.dart';

void main() {
  const lastNameLong = 'mock-lastName';
  const lastNameShort = 'cac';
  group('Register Lastname', () {
    group('constructors', () {
      test('pure creates correct instance', () {
        const lastName = Lastname.pure();
        expect(lastName.value, '');
        expect(lastName.pure, true);
      });

      test('dirty creates correct instance', () {
        const lastName = Lastname.dirty(lastNameLong);
        expect(lastName.value, lastNameLong);
        expect(lastName.pure, false);
      });
    });

    group('validator', () {
      test('returns empty error when lastName is empty', () {
        expect(
          const Lastname.dirty().error,
          LastnameValidationError.empty,
        );
      });

      test('is valid when lastName is not empty and long >3', () {
        expect(
          const Lastname.dirty(lastNameLong).error,
          isNull,
        );
      });

      test('return tooShort error when lastName is not empty and short <=3',
          () {
        expect(
          const Lastname.dirty(lastNameShort).error,
          LastnameValidationError.empty,
        );
      });
    });
  });
}
