import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/authentication/authentication.dart';
import 'package:very_good_blog_app/repository/repository.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          context.go(AppRoutes.home);
        } else if (state.status == AuthenticationStatus.unauthenticated ||
            state.status == AuthenticationStatus.unknown) {
          context.go(AppRoutes.login);
        } else if (state.status == AuthenticationStatus.authenticatedOffline) {
          context.go(AppRoutes.bookmarkOffline);
        }
      },
      child: Scaffold(
        body: Center(
          child: Assets.images.logo.image(height: 250),
        ),
      ),
    );
  }
}
