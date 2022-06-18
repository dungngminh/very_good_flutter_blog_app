// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/features/add_blog/add_blog.dart';
import 'package:very_good_blog_app/features/authentication/authentication.dart';
import 'package:very_good_blog_app/features/profile/bloc/profile_bloc.dart';
import 'package:very_good_blog_app/repository/repository.dart';

class VeryGoodBlogApp extends StatelessWidget {
  const VeryGoodBlogApp({super.key});

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

class VeryGoodBlogAppView extends StatelessWidget {
  const VeryGoodBlogAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(
            authenticationRepository: context.read<AuthenticationRepository>(),
          ),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(
            authenticationRepository: context.read<AuthenticationRepository>(),
            userRepository: context.read<UserRepository>(),
          ),
        ),
        BlocProvider<AddBlogBloc>(
          create: (context) => AddBlogBloc(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Very Good Blog App',
        debugShowCheckedModeBanner: false,
        routeInformationProvider: AppRoute.route.routeInformationProvider,
        routeInformationParser: AppRoute.route.routeInformationParser,
        routerDelegate: AppRoute.route.routerDelegate,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: FontFamily.nunito,
          inputDecorationTheme: const InputDecorationTheme(
            border: InputBorder.none,
          ),
          primaryColorDark: AppPalette.primaryColor,
          primaryColor: AppPalette.primaryColor,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: AppPalette.primaryColor,
          ),
        ),
      ),
    );
  }
}
