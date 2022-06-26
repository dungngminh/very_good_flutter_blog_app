import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_blog_app/features/authentication/authentication.dart';
import 'package:very_good_blog_app/features/splash/splash.dart';
import 'package:very_good_blog_app/repository/repository.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

void main() {
  group('SplashView', () {
    late AuthenticationRepository authenticationRepository;
    late AuthenticationBloc authenticationBloc;
    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      authenticationBloc = MockAuthenticationBloc();
    });

    testWidgets('renders Very Good Ventures Logo', (tester) async {
      when(() => authenticationBloc.state).thenReturn(
        const AuthenticationState(),
      );
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authenticationRepository,
          child: BlocProvider<AuthenticationBloc>.value(
            value: authenticationBloc,
            child: const MaterialApp(
              home: SplashView(),
            ),
          ),
        ),
      );
      expect(find.byType(SvgPicture), findsOneWidget);
    });
  });
}
