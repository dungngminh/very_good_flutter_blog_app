import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_blog_app/register/bloc/register_bloc.dart';

void main() {
  const username = 'mock-username';
  const password = 'mock-password';

  const firstname = 'mock-firstname';

  const lastname = 'mock-lastname';

  const confirmedPass = 'mock-confirmedPass';

  group('RegisterEvent', () {
    group('RegisterEventType.usernameChanged', () {
      test('supports value comparisions', () {
        expect(
          const RegisterEvent(
            RegisterEventType.userNameChanged,
            input: username,
          ),
          const RegisterEvent(
            RegisterEventType.userNameChanged,
            input: username,
          ),
        );
      });
    });
    group('RegisterEventType.passwordChanged', () {
      test('supports value comparisions', () {
        expect(
          const RegisterEvent(
            RegisterEventType.passwordChanged,
            input: password,
          ),
          const RegisterEvent(
            RegisterEventType.passwordChanged,
            input: password,
          ),
        );
      });
    });
    group('RegisterEventType.firstNameChanged', () {
      test('supports value comparisions', () {
        expect(
          const RegisterEvent(
            RegisterEventType.firstNameChanged,
            input: firstname,
          ),
          const RegisterEvent(
            RegisterEventType.firstNameChanged,
            input: firstname,
          ),
        );
      });
    });
    group('RegisterEventType.lastNameChanged', () {
      test('supports value comparisions', () {
        expect(
          const RegisterEvent(
            RegisterEventType.lastNameChanged,
            input: lastname,
          ),
          const RegisterEvent(
            RegisterEventType.lastNameChanged,
            input: lastname,
          ),
        );
      });
    });
    group('RegisterEventType.passwordChanged', () {
      test('supports value comparisions', () {
        expect(
          const RegisterEvent(
            RegisterEventType.passwordChanged,
            input: password,
          ),
          const RegisterEvent(
            RegisterEventType.passwordChanged,
            input: password,
          ),
        );
      });
    });
    group('RegisterEventType.confirmedPasswordChanged', () {
      test('supports value comparisions', () {
        expect(
          const RegisterEvent(
            RegisterEventType.confirmedPasswordChanged,
            input: confirmedPass,
          ),
          const RegisterEvent(
            RegisterEventType.confirmedPasswordChanged,
            input: confirmedPass,
          ),
        );
      });
    });
    test('support value comparisions', () {
      expect(const RegisterEvent(null), const RegisterEvent(null));
    });
  });
}
