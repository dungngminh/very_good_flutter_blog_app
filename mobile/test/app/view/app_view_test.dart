import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/features/authentication/authentication.dart';
import 'package:very_good_blog_app/features/login/login.dart';
import 'package:very_good_blog_app/features/splash/splash.dart';
import 'package:very_good_blog_app/repository/repository.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

void main() {
  group('VeryGoodBlogAppView', () {
    late AuthenticationRepository authenticationRepository;
    late UserRepository userRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      when(() => authenticationRepository.status)
          .thenAnswer((_) => Stream.value(AuthenticationStatus.unknown));
      userRepository = MockUserRepository();
    });

    testWidgets(
      'renders Splash when init',
      (tester) async {
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider<AuthenticationRepository>.value(
                value: authenticationRepository,
              ),
              RepositoryProvider<UserRepository>.value(
                value: userRepository,
              ),
            ],
            child: const VeryGoodBlogAppView(),
          ),
        );
        expect(find.byType(SplashView), findsOneWidget);
      },
    );
  });

  group('VeryGoodBlogAppView', () {
    late AuthenticationRepository authenticationRepository;
    late UserRepository userRepository;
    // late AuthenticationBloc authenticationBloc;
    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      when(() => authenticationRepository.status).thenAnswer(
        (_) => Stream.value(AuthenticationStatus.unauthenticated),
      );
      userRepository = MockUserRepository();
      // authenticationBloc = MockAuthenticationBloc();
    });

    testWidgets(
      'renders LoginView when found unauthenticated',
      (tester) async {
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider<AuthenticationRepository>.value(
                value: authenticationRepository,
              ),
              RepositoryProvider<UserRepository>.value(
                value: userRepository,
              ),
            ],
            child: const VeryGoodBlogAppView(),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(LoginView), findsOneWidget);
      },
    );
  });
}
