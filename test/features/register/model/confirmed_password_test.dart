import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_blog_app/features/register/model/confirmed_password.dart';

void main() {
  const correctInput = 'dungngminh';
  const password = 'dungngminh';
  const wrongInput = 'dungngminh1';

  group('Confirmed Password', () {
    test('pure init create correct instance', () {
      const confirmedPassword = ConfirmedPassword.pure();
      expect(confirmedPassword.value, '');
      expect(confirmedPassword.pure, true);
    });

    test('dirty init create correct instance', () {
      const confirmedPassword = ConfirmedPassword.dirty();
      expect(confirmedPassword.value, '');
      expect(confirmedPassword.pure, false);
    });

    test('return empty error when no input', () {
      const password = ConfirmedPassword.dirty();
      expect(password.pure, false);
      expect(password.error, ConfirmedPasswordValidationError.empty);
    });

    test(
      'return not match error '
      'when input is not empty but no match with password',
      () {
        const confirmedPassword =
            ConfirmedPassword.dirty(password: password, value: wrongInput);
        expect(confirmedPassword.pure, false);
        expect(confirmedPassword.value, wrongInput);
        expect(
          confirmedPassword.error,
          ConfirmedPasswordValidationError.notMatch,
        );
      },
    );
    test('return no error when input is not empty but match with password', () {
      const confirmedPassword =
          ConfirmedPassword.dirty(password: password, value: correctInput);
      expect(confirmedPassword.pure, false);
      expect(confirmedPassword.value, correctInput);
      expect(confirmedPassword.error, isNull);
    });
  });
}
