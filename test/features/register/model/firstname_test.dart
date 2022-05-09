import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_blog_app/features/register/register.dart';

void main() {
  const firstNameLong = 'mock-firstName';
  const firstNameShort = 'cac';
  group('Register Firstname', () {
    group('constructors', () {
      test('pure creates correct instance', () {
        const firstName = Firstname.pure();
        expect(firstName.value, '');
        expect(firstName.pure, true);
      });

      test('dirty creates correct instance', () {
        const firstName = Firstname.dirty(firstNameLong);
        expect(firstName.value, firstNameLong);
        expect(firstName.pure, false);
      });
    });

    group('validator', () {
      test('returns empty error when firstName is empty', () {
        expect(
          const Firstname.dirty().error,
          FirstnameValidationError.empty,
        );
      });

      test('is valid when firstName is not empty and long >3', () {
        expect(
          const Firstname.dirty(firstNameLong).error,
          isNull,
        );
      });

      test('return tooShort error when firstName is not empty and short <=3',
          () {
        expect(
          const Firstname.dirty(firstNameShort).error,
          FirstnameValidationError.tooShort,
        );
      });
    });
  });
}
