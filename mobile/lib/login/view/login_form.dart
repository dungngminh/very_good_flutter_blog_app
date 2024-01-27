import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
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

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Builder(
                  builder: (context) {
                    final message =
                        context.watch<AuthenticationBloc>().state.status;
                    return Text(message.toString());
                  },
                ),
              ),
            );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TitleOfTextField(l10n.username),
            _UsernameInput(),
            const Padding(padding: EdgeInsets.all(12)),
            TitleOfTextField(l10n.password),
            _PasswordInput(),
            const SizedBox(
              height: 24,
            ),
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
            const Padding(padding: EdgeInsets.all(12)),
            Center(
              child: _LoginButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextFieldDecoration(
          child: TextField(
            key: const Key('loginForm_usernameInput_textField'),
            onChanged: (username) =>
                context.read<LoginBloc>().add(LoginUsernameChanged(username)),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 16, right: 16),
              border: InputBorder.none,
              hintText: l10n.usernameHint,
              errorText: state.username.isNotValid ? l10n.usernameEmpty : null,
            ),
            textInputAction: TextInputAction.next,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatefulWidget {
  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  late bool _isHidePassword;

  @override
  void initState() {
    _isHidePassword = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
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
              errorText: state.password.isNotValid
                  ? getErrorMessage(state.password.error!, l10n)
                  : null,
              suffixIcon: IconButton(
                icon: _isHidePassword
                    ? Assets.icons.show.svg(color: AppPalette.primaryColor)
                    : Assets.icons.hide.svg(color: AppPalette.primaryColor),
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
      },
    );
  }

  String getErrorMessage(PasswordValidationError error, AppLocalizations l10n) {
    switch (error) {
      case PasswordValidationError.empty:
        return l10n.passwordEmpty;
      case PasswordValidationError.tooShort:
        return l10n.passwordLength;
    }
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator(
                color: AppPalette.primaryColor,
              )
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                onPressed: state.status.isInitial
                    ? () {
                        context.read<LoginBloc>().add(const LoginSubmitted());
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(130, 50),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
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
      },
    );
  }
}
