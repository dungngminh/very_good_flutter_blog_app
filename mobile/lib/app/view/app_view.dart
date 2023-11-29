// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:authentication_data_source/authentication_data_source.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:blog_data_source/blog_data_source.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:bookmark_data_source/bookmark_data_source.dart';
import 'package:bookmark_repository/bookmark_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/authentication/authentication.dart';
import 'package:very_good_blog_app/di/di.dart';
import 'package:very_good_blog_app/l10n/l10n.dart';

class VeryGoodBlogApp extends StatelessWidget {
  const VeryGoodBlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
          create: (_) => AuthenticationRepository(
            dataSource: injector<AuthenticationRemoteDataSource>(),
          ),
        ),
        RepositoryProvider<UserRepository>(
          create: (_) => UserRepository(
            userDataSource: injector<UserRemoteDataSource>(),
            firebaseStorageService: injector<FirebaseStorageService>(),
          ),
        ),
        RepositoryProvider<BlogRepository>(
          create: (_) => BlogRepository(
            remoteDataSource: injector<BlogRemoteDataSource>(),
            firebaseStorageSerivce: injector<FirebaseStorageService>(),
          ),
        ),
        RepositoryProvider<BookmarkRepository>(
          create: (_) => BookmarkRepository(
            localDataSource: injector<BookmarkLocalDataSource>(),
            remoteDataSource: injector<BookmarkRemoteDataSource>(),
          ),
        ),
      ],
      child: const VeryGoodBlogAppView(),
    );
  }
}

class VeryGoodBlogAppView extends StatefulWidget {
  const VeryGoodBlogAppView({super.key});

  @override
  State<VeryGoodBlogAppView> createState() => _VeryGoodBlogAppViewState();
}

class _VeryGoodBlogAppViewState extends State<VeryGoodBlogAppView> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(
            authenticationRepository: context.read<AuthenticationRepository>(),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'Very Good Blog App',
        debugShowCheckedModeBanner: false,
        routeInformationProvider: AppRoutes.route.routeInformationProvider,
        routeInformationParser: AppRoutes.route.routeInformationParser,
        routerDelegate: AppRoutes.route.routerDelegate,
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
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
