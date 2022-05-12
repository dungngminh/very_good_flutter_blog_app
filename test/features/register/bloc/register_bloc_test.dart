import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_blog_app/features/register/register.dart';
import 'package:very_good_blog_app/repository/authentication_repository.dart';

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
    const repasswordCorret = 'kminhdung123';
    blocTest<RegisterBloc, RegisterState>(
      'emits [submissionInProgress, submissionSuccess] '
      'when register succeeds',
      setUp: () {
        when(
          () => authenticationRepository.logIn(
            username: 'username',
            password: 'password',
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
              input: repasswordCorret,
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
          status: FormzStatus.invalid,
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
          status: FormzStatus.invalid,
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
          username: Username.dirty(username),
          status: FormzStatus.invalid,
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
          username: Username.dirty(username),
          password: Password.dirty(password),
          status: FormzStatus.invalid,
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
          status: FormzStatus.invalid,
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
          username: Username.dirty(username),
          password: Password.dirty(password),
          confirmedPassword: ConfirmedPassword.dirty(
            password: password,
            value: repasswordCorret,
          ),
          status: FormzStatus.valid,
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
          username: Username.dirty(username),
          password: Password.dirty(password),
          confirmedPassword: ConfirmedPassword.dirty(
            password: password,
            value: repasswordCorret,
          ),
          status: FormzStatus.submissionInProgress,
        ),
        const RegisterState(
          firstname: Firstname.dirty(firstname),
          lastname: Lastname.dirty(lastname),
          username: Username.dirty(username),
          password: Password.dirty(password),
          confirmedPassword: ConfirmedPassword.dirty(
            password: password,
            value: repasswordCorret,
          ),
          status: FormzStatus.submissionSuccess,
        ),
      ],
    );
  });
}
