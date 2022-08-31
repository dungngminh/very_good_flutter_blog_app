import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/authentication/authentication.dart';
import 'package:very_good_blog_app/l10n/l10n.dart';
import 'package:very_good_blog_app/register/bloc/register_bloc.dart';
import 'package:very_good_blog_app/register/view/register_form.dart';
import 'package:very_good_blog_app/widgets/dismiss_focus_keyboard.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.status == AuthenticationStatus.successfullyRegistered) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(l10n.registerSuccessfully)),
            );
          context.pop();
        } else if (state.status ==
            AuthenticationStatus.unsuccessfullyRegistered) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(l10n.registerFailed)),
            );
        } else if (state.status == AuthenticationStatus.existed) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(l10n.duplicateUser)),
            );
        }
      },
      child: DismissFocusKeyboard(
        child: Scaffold(
          backgroundColor: AppPalette.whiteBackgroundColor,
          body: Padding(
            padding: EdgeInsets.only(top: context.padding.top + 16),
            child: Column(
              children: [
                Flexible(
                  flex: 2,
                  child: Center(
                    child: SizedBox(
                      height: 120,
                      child: FittedBox(
                        child: Assets.images.logo.image(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Expanded(
                  flex: 10,
                  child: BlocProvider<RegisterBloc>(
                    create: (_) => RegisterBloc(
                      authenticationRepository:
                          context.read<AuthenticationRepository>(),
                    ),
                    child: const RegisterForm(),
                  ),
                ),
                SizedBox(
                  height: context.screenHeight * 0.02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
