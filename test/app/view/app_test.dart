// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/features/authentication/authentication.dart';
import 'package:very_good_blog_app/features/home/home.dart';
import 'package:very_good_blog_app/features/login/login.dart';
import 'package:very_good_blog_app/features/splash/splash.dart';
import 'package:very_good_blog_app/repository/authentication_repository.dart';
import 'package:very_good_blog_app/repository/user_repository.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

void main() {
  group('VeryGoodBlogApp', () {
    testWidgets('renders VeryGoodBlogAppView', (tester) async {
      await tester.pumpWidget(const VeryGoodBlogApp());
      await tester.pumpAndSettle();
      expect(find.byType(VeryGoodBlogAppView), findsOneWidget);
    });
  });

  group('VeryGoodBlogAppView', () {
    late AuthenticationRepository authenticationRepository;
    late UserRepository userRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      when(() => authenticationRepository.status)
          .thenAnswer((_) => const Stream.empty());
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
    late AuthenticationBloc authenticationBloc;
    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      when(() => authenticationRepository.status).thenAnswer(
        (_) => Stream.value(AuthenticationStatus.unauthenticated),
      );
      userRepository = MockUserRepository();
      authenticationBloc = MockAuthenticationBloc();
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
            child: BlocProvider<AuthenticationBloc>.value(
              value: authenticationBloc,
              child: const VeryGoodBlogAppView(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(LoginView), findsOneWidget);
      },
    );
  });

  group('VeryGoodBlogAppView', () {
    late AuthenticationRepository authenticationRepository;
    late UserRepository userRepository;
    late AuthenticationBloc authenticationBloc;
    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      when(() => authenticationRepository.status).thenAnswer(
        (_) => Stream.value(AuthenticationStatus.authenticated),
      );
      userRepository = MockUserRepository();
      authenticationBloc = MockAuthenticationBloc();
    });

    testWidgets(
      'renders HomeView when found authenticated',
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
            child: BlocProvider<AuthenticationBloc>.value(
              value: authenticationBloc,
              child: const VeryGoodBlogAppView(),
            ),
          ),
        );
        // await tester.pumpAndSettle(const Duration(seconds: 20));
        expect(find.byType(HomeView), findsOneWidget);
      },
    );
  });
}
