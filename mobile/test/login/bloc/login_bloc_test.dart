import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_blog_app/login/login.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  late AuthenticationRepository authenticationRepository;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
  });

  group('LoginBloc', () {
    test('initial state is LoginState', () {
      final loginBloc = LoginBloc(
        authenticationRepository: authenticationRepository,
      );
      expect(loginBloc.state, const LoginState());
    });

    group('LoginSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        'emits [inProgress, success] '
        'when login succeeds',
        setUp: () {
          when(
            () => authenticationRepository.login(
              username: 'username',
              password: 'password',
            ),
            // ignore: void_checks
          ).thenAnswer((_) => Future.value('user'));
        },
        build: () => LoginBloc(
          authenticationRepository: authenticationRepository,
        ),
        act: (bloc) {
          bloc
            ..add(const LoginUsernameChanged('username'))
            ..add(const LoginPasswordChanged('password'))
            ..add(const LoginSubmitted());
        },
        expect: () => const <LoginState>[
          LoginState(
            username: Username.dirty('username'),
          ),
          LoginState(
            username: Username.dirty('username'),
            password: Password.dirty('password'),
            isValid: true,
          ),
          LoginState(
            username: Username.dirty('username'),
            password: Password.dirty('password'),
            isValid: true,
            status: FormzSubmissionStatus.inProgress,
          ),
          LoginState(
            username: Username.dirty('username'),
            password: Password.dirty('password'),
            status: FormzSubmissionStatus.inProgress,
          ),
          LoginState(
            username: Username.dirty('username'),
            password: Password.dirty('password'),
            status: FormzSubmissionStatus.success,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoginInProgress, LoginFailure] when logIn fails',
        setUp: () {
          when(
            () => authenticationRepository.login(
              username: 'username',
              password: 'password',
            ),
          ).thenThrow(Exception('oops'));
        },
        build: () => LoginBloc(
          authenticationRepository: authenticationRepository,
        ),
        act: (bloc) {
          bloc
            ..add(const LoginUsernameChanged('username'))
            ..add(const LoginPasswordChanged('password'))
            ..add(const LoginSubmitted());
        },
        expect: () => const <LoginState>[
          LoginState(
            username: Username.dirty('username'),
          ),
          LoginState(
            username: Username.dirty('username'),
            password: Password.dirty('password'),
            isValid: true,
          ),
          LoginState(
            username: Username.dirty('username'),
            password: Password.dirty('password'),
            isValid: true,
            status: FormzSubmissionStatus.inProgress,
          ),
          LoginState(
            username: Username.dirty('username'),
            password: Password.dirty('password'),
            isValid: true,
            status: FormzSubmissionStatus.failure,
          ),
        ],
      );
    });
  });
}
