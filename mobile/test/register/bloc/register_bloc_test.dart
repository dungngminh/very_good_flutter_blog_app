import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_blog_app/register/register.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  late AuthenticationRepository authenticationRepository;

  setUp(
    () {
      authenticationRepository = MockAuthenticationRepository();
    },
  );

  group('Register Bloc', () {
    test('initial state is RegisterState', () {
      final registerBloc = RegisterBloc(
        authenticationRepository: authenticationRepository,
      );
      expect(registerBloc.state, const RegisterState());
    });
  });

  group('RegisterSubmitted', () {
    const firstname = 'Nguyen';
    const lastname = 'Minh Dung';
    const username = 'dungngminh';
    const password = 'kminhdung123';
    const repasswordError = 'kminhdung';
    const repasswordCorrect = 'kminhdung123';
    const password2 = 'hehehe';
    const repasswordCorrect2 = 'hehehe';
    blocTest<RegisterBloc, RegisterState>(
      'emits [inProgress, success] '
      'when register SUCCEEDS',
      setUp: () {
        when(
          () => authenticationRepository.register(
            username: username,
            password: password2,
            lastname: lastname,
            firstname: firstname,
            confirmationPassword: repasswordCorrect2,
          ),
          // ignore: void_checks
        ).thenAnswer((_) => Future.value());
      },
      build: () => RegisterBloc(
        authenticationRepository: authenticationRepository,
      ),
      act: (bloc) {
        bloc
          ..add(
            const RegisterEvent(
              RegisterEventType.firstNameChanged,
              input: firstname,
            ),
          )
          ..add(
            const RegisterEvent(
              RegisterEventType.lastNameChanged,
              input: lastname,
            ),
          )
          ..add(
            const RegisterEvent(
              RegisterEventType.userNameChanged,
              input: username,
            ),
          )
          ..add(
            const RegisterEvent(
              RegisterEventType.passwordChanged,
              input: password,
            ),
          )
          ..add(
            const RegisterEvent(
              RegisterEventType.confirmedPasswordChanged,
              input: repasswordError,
            ),
          )
          ..add(
            const RegisterEvent(
              RegisterEventType.confirmedPasswordChanged,
              input: repasswordCorrect,
            ),
          )
          ..add(
            const RegisterEvent(
              RegisterEventType.passwordChanged,
              input: password2,
            ),
          )
          ..add(
            const RegisterEvent(
              RegisterEventType.confirmedPasswordChanged,
              input: repasswordCorrect2,
            ),
          )
          ..add(
            const RegisterEvent(
              RegisterEventType.submitted,
            ),
          );
      },
      expect: () => <RegisterState>[
        const RegisterState(
          firstname: Firstname.dirty(firstname),
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
          username: Username.dirty(username),
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
          username: Username.dirty(username),
          password: Password.dirty(password),
          confirmedPassword: ConfirmedPassword.dirty(password: password),
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
          username: Username.dirty(username),
          password: Password.dirty(password),
          confirmedPassword: ConfirmedPassword.dirty(
            password: password,
            value: repasswordError,
          ),
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
          username: Username.dirty(username),
          password: Password.dirty(password),
          confirmedPassword: ConfirmedPassword.dirty(
            password: password,
            value: repasswordCorrect,
          ),
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
          username: Username.dirty(username),
          password: Password.dirty(password2),
          confirmedPassword: ConfirmedPassword.dirty(
            password: password2,
            value: repasswordCorrect,
          ),
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
          username: Username.dirty(username),
          password: Password.dirty(password2),
          confirmedPassword: ConfirmedPassword.dirty(
            password: password2,
            value: repasswordCorrect2,
          ),
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
          username: Username.dirty(username),
          password: Password.dirty(password2),
          confirmedPassword: ConfirmedPassword.dirty(
            password: password2,
            value: repasswordCorrect2,
          ),
          status: FormzSubmissionStatus.inProgress,
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
          username: Username.dirty(username),
          password: Password.dirty(password2),
          confirmedPassword: ConfirmedPassword.dirty(
            password: password2,
            value: repasswordCorrect2,
          ),
          status: FormzSubmissionStatus.success,
        ),
      ],
    );
    blocTest<RegisterBloc, RegisterState>(
      'emits [inProgress, .failure] '
      'when register UNSUCCEEDS',
      setUp: () {
        when(
          () => authenticationRepository.register(
            username: username,
            password: password2,
            lastname: lastname,
            firstname: firstname,
            confirmationPassword: repasswordCorrect2,
          ),
          // ignore: void_checks
        ).thenThrow(Exception('register failed'));
      },
      build: () => RegisterBloc(
        authenticationRepository: authenticationRepository,
      ),
      act: (bloc) {
        bloc
          ..add(
            const RegisterEvent(
              RegisterEventType.firstNameChanged,
              input: firstname,
            ),
          )
          ..add(
            const RegisterEvent(
              RegisterEventType.lastNameChanged,
              input: lastname,
            ),
          )
          ..add(
            const RegisterEvent(
              RegisterEventType.userNameChanged,
              input: username,
            ),
          )
          ..add(
            const RegisterEvent(
              RegisterEventType.passwordChanged,
              input: password,
            ),
          )
          ..add(
            const RegisterEvent(
              RegisterEventType.confirmedPasswordChanged,
              input: repasswordError,
            ),
          )
          ..add(
            const RegisterEvent(
              RegisterEventType.confirmedPasswordChanged,
              input: repasswordCorrect,
            ),
          )
          ..add(
            const RegisterEvent(
              RegisterEventType.passwordChanged,
              input: password2,
            ),
          )
          ..add(
            const RegisterEvent(
              RegisterEventType.confirmedPasswordChanged,
              input: repasswordCorrect2,
            ),
          )
          ..add(
            const RegisterEvent(
              RegisterEventType.submitted,
            ),
          );
      },
      expect: () => <RegisterState>[
        const RegisterState(
          firstname: Firstname.dirty(firstname),
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
          username: Username.dirty(username),
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
          username: Username.dirty(username),
          password: Password.dirty(password),
          confirmedPassword: ConfirmedPassword.dirty(password: password),
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
          username: Username.dirty(username),
          password: Password.dirty(password),
          confirmedPassword: ConfirmedPassword.dirty(
            password: password,
            value: repasswordError,
          ),
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
          username: Username.dirty(username),
          password: Password.dirty(password),
          confirmedPassword: ConfirmedPassword.dirty(
            password: password,
            value: repasswordCorrect,
          ),
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
          username: Username.dirty(username),
          password: Password.dirty(password2),
          confirmedPassword: ConfirmedPassword.dirty(
            password: password2,
            value: repasswordCorrect,
          ),
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
          username: Username.dirty(username),
          password: Password.dirty(password2),
          confirmedPassword: ConfirmedPassword.dirty(
            password: password2,
            value: repasswordCorrect2,
          ),
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
          username: Username.dirty(username),
          password: Password.dirty(password2),
          confirmedPassword: ConfirmedPassword.dirty(
            password: password2,
            value: repasswordCorrect2,
          ),
          status: FormzSubmissionStatus.inProgress,
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
          username: Username.dirty(username),
          password: Password.dirty(password2),
          confirmedPassword: ConfirmedPassword.dirty(
            password: password2,
            value: repasswordCorrect2,
          ),
          status: FormzSubmissionStatus.failure,
        ),
      ],
    );
  });
}
