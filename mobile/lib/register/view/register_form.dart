import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/l10n/l10n.dart';
import 'package:very_good_blog_app/register/register.dart';
import 'package:very_good_blog_app/widgets/widgets.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleOfTextField(l10n.firstName),
          _FirstnameInput(),
          const SizedBox(
            height: 16,
          ),
          TitleOfTextField(l10n.lastName),
          _LastnameInput(),
          const SizedBox(
            height: 16,
          ),
          TitleOfTextField(l10n.username),
          _UsernameInput(),
          const SizedBox(
            height: 16,
          ),
          TitleOfTextField(l10n.password),
          _PasswordInput(),
          const SizedBox(
            height: 16,
          ),
          TitleOfTextField(l10n.confirmationPassword),
          _ConfirmedPasswordInput(),
          const Padding(padding: EdgeInsets.all(12)),
          Center(
            child: _RegisterButton(),
          ),
        ],
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final username = context.select(
      (RegisterBloc registerBloc) => registerBloc.state.username,
    );
    return TextFieldDecoration(
      child: TextField(
        key: const Key('registerForm_usernameInput_textField'),
        onChanged: (username) => context.read<RegisterBloc>().add(
              RegisterEvent(
                RegisterEventType.userNameChanged,
                input: username,
              ),
            ),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16, right: 16),
          border: InputBorder.none,
          hintText: l10n.usernameHint,
          errorText: username.displayError != null ? l10n.usernameEmpty : null,
        ),
      ),
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
    super.initState();
    _isHidePassword = true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final password = context.select(
      (RegisterBloc registerBloc) => registerBloc.state.password,
    );
    return TextFieldDecoration(
      child: TextField(
        key: const Key('registerForm_passwordInput_textField'),
        onChanged: (password) => context.read<RegisterBloc>()
          ..add(
            RegisterEvent(
              RegisterEventType.passwordChanged,
              input: password,
            ),
          ),
        textInputAction: TextInputAction.next,
        obscureText: _isHidePassword,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16, right: 16),
          border: InputBorder.none,
          hintText: l10n.passwordHint,
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
          errorText: getErrorMessage(password.displayError, l10n),
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

class _ConfirmedPasswordInput extends StatefulWidget {
  @override
  State<_ConfirmedPasswordInput> createState() =>
      _ConfirmedPasswordInputState();
}

class _ConfirmedPasswordInputState extends State<_ConfirmedPasswordInput> {
  late bool _isHideConfirmationPassword;

  @override
  void initState() {
    super.initState();
    _isHideConfirmationPassword = true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return TextFieldDecoration(
          child: TextField(
            key: const Key('registerForm_confirmedPass_textField'),
            onChanged: (confirmedPassword) => context.read<RegisterBloc>().add(
                  RegisterEvent(
                    RegisterEventType.confirmedPasswordChanged,
                    input: confirmedPassword,
                  ),
                ),
            obscureText: _isHideConfirmationPassword,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 16, right: 16),
              border: InputBorder.none,
              hintText: l10n.confirmationPasswordHint,
              suffixIcon: IconButton(
                icon: _isHideConfirmationPassword
                    ? Assets.icons.show.svg(color: AppPalette.primaryColor)
                    : Assets.icons.hide.svg(color: AppPalette.primaryColor),
                onPressed: () {
                  setState(() {
                    _isHideConfirmationPassword = !_isHideConfirmationPassword;
                  });
                },
                splashRadius: 24,
              ),
              errorText: state.confirmedPassword.displayError != null
                  ? l10n.unmatchedPassword
                  : null,
            ),
            textAlignVertical: TextAlignVertical.center,
          ),
        );
      },
    );
  }
}

class _FirstnameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final firstname = context.select(
      (RegisterBloc registerBloc) => registerBloc.state.firstname,
    );
    return TextFieldDecoration(
      child: TextField(
        key: const Key('registerForm_firstnameInput_textField'),
        onChanged: (firstName) => context.read<RegisterBloc>().add(
              RegisterEvent(
                RegisterEventType.firstNameChanged,
                input: firstName,
              ),
            ),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16, right: 16),
          border: InputBorder.none,
          hintText: l10n.firstNameHint,
          errorText:
              firstname.displayError != null ? l10n.firstNameEmpty : null,
        ),
      ),
    );
  }
}

class _LastnameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lastname = context
        .select((RegisterBloc registerBloc) => registerBloc.state.lastname);
    return TextFieldDecoration(
      child: TextField(
        key: const Key('registerForm_passwordInput_textField'),
        onChanged: (lastName) => context.read<RegisterBloc>().add(
              RegisterEvent(
                RegisterEventType.lastNameChanged,
                input: lastName,
              ),
            ),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16, right: 16),
          border: InputBorder.none,
          hintText: l10n.lastNameHint,
          errorText: lastname.displayError != null ? l10n.lastNameEmpty : null,
        ),
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context
        .select((RegisterBloc registerBloc) => registerBloc.state.status);
    final isValid = context.select((RegisterBloc bloc) => bloc.state.isValid);
    if (status.isInProgress) {
      return const CircularProgressIndicator(color: AppPalette.primaryColor);
    }
    return _buildRegisterButton(isValid, context, l10n);
  }

  ElevatedButton _buildRegisterButton(
    bool isValid,
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return ElevatedButton(
      key: const Key('registerForm_continue_raisedButton'),
      onPressed: isValid
          ? () {
              context.read<RegisterBloc>().add(
                    const RegisterEvent(RegisterEventType.submitted),
                  );
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Text(
        l10n.register,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: AppPalette.whiteBackgroundColor,
        ),
      ),
    );
  }
}
