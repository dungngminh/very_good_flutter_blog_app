import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/features/authentication/authentication.dart';
import 'package:very_good_blog_app/features/login/login.dart';
import 'package:very_good_blog_app/l10n/l10n.dart';
import 'package:very_good_blog_app/repository/repository.dart';
import 'package:very_good_blog_app/widgets/dismiss_focus_keyboard.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          context.go(AppRoutes.home);
        }
      },
      child: DismissFocusKeyboard(
        child: Scaffold(
          backgroundColor: AppPalette.whiteBackgroundColor,
          body: SingleChildScrollView(
            padding: EdgeInsets.only(top: context.padding.top + 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: FittedBox(
                      child: Assets.images.logo.image(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  height: context.screenHeight * 0.65,
                  child: BlocProvider<LoginBloc>(
                    create: (context) => LoginBloc(
                      authenticationRepository:
                          context.read<AuthenticationRepository>(),
                    ),
                    child: const LoginForm(),
                  ),
                ),
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: l10n.notHaveAccountYet,
                      children: [
                        TextSpan(
                          text: l10n.register,
                          style: const TextStyle(
                            color: AppPalette.primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.push(AppRoutes.register),
                        )
                      ],
                    ),
                    style: const TextStyle(
                      color: AppPalette.descriptionTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: context.screenHeight * 0.06,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
