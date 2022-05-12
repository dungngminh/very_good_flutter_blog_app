import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_blog_app/features/authentication/authentication.dart';
import 'package:very_good_blog_app/repository/authentication_repository.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          context.go('/');
        } else if (state.status == AuthenticationStatus.unauthenticated ||
            state.status == AuthenticationStatus.unknown) {
          context.go('/login');
        }
      },
      child: Scaffold(
        body: Center(
          child: SvgPicture.asset(
            'assets/images/very_good.svg',
          ),
        ),
      ),
    );
  }
}
