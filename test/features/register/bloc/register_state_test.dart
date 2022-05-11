import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:very_good_blog_app/features/register/register.dart';

void main() {
  const lastname = Lastname.dirty('Minh Dung');
  const firstname = Firstname.dirty('Nguyen');
  const username = Username.dirty('dungngminh');
  const password = Password.dirty('password');
  final confirmedPassword = ConfirmedPassword.dirty(
    password: password.value,
    value: 'dungngminh',
  );

  group('RegisterState', () {
    test('supports value comparitions', () {
      expect(const RegisterState(), const RegisterState());
    });

    test('return same object when no prop is passed', () {
      expect(const RegisterState().copyWith(), const RegisterState());
    });

    test('return object when pass 1 or some props', () {
      expect(
        const RegisterState().copyWith(status: FormzStatus.pure),
        const RegisterState(),
      );
    });
    test('return object with updated username when pass username', () {
      expect(
        const RegisterState().copyWith(username: username),
        const RegisterState(username: username),
      );
    });
    test('return object with updated password when pass password', () {
      expect(
        const RegisterState().copyWith(password: password),
        const RegisterState(password: password),
      );
    });
    test('return object with updated firstname when pass firstname', () {
      expect(
        const RegisterState().copyWith(firstname: firstname),
        const RegisterState(firstname: firstname),
      );
    });
    test('return object with updated lastname when pass lastname', () {
      expect(
        const RegisterState().copyWith(lastname: lastname),
        const RegisterState(lastname: lastname),
      );
    });
    test('return object with updated confirmPassword when pass confirmPassword',
        () {
      expect(
        const RegisterState().copyWith(confirmedPassword: confirmedPassword),
        RegisterState(confirmedPassword: confirmedPassword),
      );
    });
  });
}
