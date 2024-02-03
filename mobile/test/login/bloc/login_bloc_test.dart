import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_blog_app/domain/repositories/auth_repository.dart';
import 'package:very_good_blog_app/login/login.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository authenticationRepository;

  setUp(() {
    authenticationRepository = MockAuthRepository();
  });

  group('LoginBloc', () {
    test('initial state is LoginState', () {
      final loginBloc = LoginBloc(
        authRepository: authenticationRepository,
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
              email: 'username',
              password: 'password',
            ),
            // ignore: void_checks
          ).thenAnswer((_) => Future.value('user'));
        },
        build: () => LoginBloc(
          authRepository: authenticationRepository,
        ),
        act: (bloc) {
          bloc
            ..add(const LoginEmailChanged('username'))
            ..add(const LoginPasswordChanged('password'))
            ..add(const LoginSubmitted());
        },
        expect: () => const <LoginState>[
          LoginState(
            email: Email.dirty('username'),
          ),
          LoginState(
            email: Email.dirty('username'),
            password: Password.dirty('password'),
            isValid: true,
          ),
          LoginState(
            email: Email.dirty('username'),
            password: Password.dirty('password'),
            isValid: true,
            status: FormzSubmissionStatus.inProgress,
          ),
          LoginState(
            email: Email.dirty('username'),
            password: Password.dirty('password'),
            status: FormzSubmissionStatus.inProgress,
          ),
          LoginState(
            email: Email.dirty('username'),
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
              email: 'username',
              password: 'password',
            ),
          ).thenThrow(Exception('oops'));
        },
        build: () => LoginBloc(
          authRepository: authenticationRepository,
        ),
        act: (bloc) {
          bloc
            ..add(const LoginEmailChanged('username'))
            ..add(const LoginPasswordChanged('password'))
            ..add(const LoginSubmitted());
        },
        expect: () => const <LoginState>[
          LoginState(
            email: Email.dirty('username'),
          ),
          LoginState(
            email: Email.dirty('username'),
            password: Password.dirty('password'),
            isValid: true,
          ),
          LoginState(
            email: Email.dirty('username'),
            password: Password.dirty('password'),
            isValid: true,
            status: FormzSubmissionStatus.inProgress,
          ),
          LoginState(
            email: Email.dirty('username'),
            password: Password.dirty('password'),
            isValid: true,
            status: FormzSubmissionStatus.failure,
          ),
        ],
      );
    });
  });
}
