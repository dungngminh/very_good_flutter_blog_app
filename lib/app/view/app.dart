// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_blog_app/features/authentication/authentication.dart';
import 'package:very_good_blog_app/features/home/view/home_view.dart';
import 'package:very_good_blog_app/features/login/login.dart';
import 'package:very_good_blog_app/features/splash/splash.dart';
import 'package:very_good_blog_app/repository/authentication_repository.dart';
import 'package:very_good_blog_app/repository/user_repository.dart';

class VeryGoodBlogApp extends StatelessWidget {
  const VeryGoodBlogApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
          create: (_) => AuthenticationRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (_) => UserRepository(),
        ),
      ],
      child: const VeryGoodBlogAppView(),
    );
  }
}

class VeryGoodBlogAppView extends StatefulWidget {
  const VeryGoodBlogAppView({Key? key}) : super(key: key);

  @override
  State<VeryGoodBlogAppView> createState() => _VeryGoodBlogAppViewState();
}

class _VeryGoodBlogAppViewState extends State<VeryGoodBlogAppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(
            authenticationRepository: context.read<AuthenticationRepository>(),
            userRepository: context.read<UserRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
          colorScheme: ColorScheme.fromSwatch(
            accentColor: const Color(0xFF13B9FF),
          ),
        ),
        builder: (context, child) {
          return BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              switch (state.status) {
                case AuthenticationStatus.authenticated:
                  _navigator.pushAndRemoveUntil<void>(
                    MaterialPageRoute(
                      builder: (_) => const HomeView(),
                    ),
                    (route) => false,
                  );
                  break;
                case AuthenticationStatus.unknown:
                case AuthenticationStatus.unauthenticated:
                  _navigator.pushAndRemoveUntil<void>(
                    MaterialPageRoute(
                      builder: (_) => const LoginView(),
                    ),
                    (route) => false,
                  );
                  break;
              }
            },
            child: child,
          );
        },
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          builder: (_) => const SplashView(),
        ),
      ),
    );
  }
}
