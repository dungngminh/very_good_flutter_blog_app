import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gap/gap.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/authentication/authentication.dart';
import 'package:very_good_blog_app/l10n/l10n.dart';
import 'package:very_good_blog_app/login/login.dart';
import 'package:very_good_blog_app/widgets/widgets.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    void showSnackbarError(String message) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          final message = context.watch<AuthenticationBloc>().state.status;
          showSnackbarError(message.toString());
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TitleOfTextField(l10n.username),
            _EmailInput(),
            const Gap(24),
            TitleOfTextField(l10n.password),
            _PasswordInput(),
            const Gap(24),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                l10n.forgotPassword,
                style: const TextStyle(
                  color: AppPalette.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Gap(24),
            Center(child: _LoginButton()),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final email = context.select((LoginBloc bloc) => bloc.state.email);
    return TextFieldDecoration(
      child: TextField(
        key: const Key('loginForm_usernameInput_textField'),
        onChanged: (value) {
          if (value.trim().isEmpty) return;
          context.read<LoginBloc>().add(LoginEmailChanged(value));
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16, right: 16),
          border: InputBorder.none,
          hintText: l10n.usernameHint,
          errorText: email.displayError != null ? l10n.usernameEmpty : null,
        ),
        textInputAction: TextInputAction.next,
      ),
    );
  }
}

class _PasswordInput extends StatefulWidget {
  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  bool _isHidePassword = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final password = context.select((LoginBloc bloc) => bloc.state.password);
    final showOrHideIcon =
        _isHidePassword ? Assets.icons.show.svg() : Assets.icons.hide.svg();
    return TextFieldDecoration(
      child: TextField(
        key: const Key('loginForm_passwordInput_textField'),
        onChanged: (password) =>
            context.read<LoginBloc>().add(LoginPasswordChanged(password)),
        obscureText: _isHidePassword,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16, right: 16),
          border: InputBorder.none,
          hintText: l10n.passwordHint,
          errorText: getErrorMessage(password.displayError, l10n),
          suffixIcon: IconButton(
            icon: showOrHideIcon,
            onPressed: () {
              setState(() {
                _isHidePassword = !_isHidePassword;
              });
            },
            splashRadius: 24,
          ),
        ),
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }

  String? getErrorMessage(
    PasswordValidationError? error,
    AppLocalizations l10n,
  ) {
    return switch (error) {
      PasswordValidationError.empty => l10n.passwordEmpty,
      PasswordValidationError.tooShort => l10n.passwordLength,
      null => null,
    };
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final formStatus = context.select((LoginBloc bloc) => bloc.state.status);
    if (formStatus.isInProgress) {
      return const CircularProgressIndicator(
        color: AppPalette.primaryColor,
      );
    }
    void onLoginPressed() {
      context.read<LoginBloc>().add(const LoginSubmitted());
    }

    return ElevatedButton(
      key: const Key('loginForm_continue_raisedButton'),
      onPressed: onLoginPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: context.theme.primaryColor,
      ),
      child: Text(
        l10n.login,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: AppPalette.whiteBackgroundColor,
        ),
      ),
    );
  }
}
