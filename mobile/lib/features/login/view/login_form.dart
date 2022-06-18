import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/features/authentication/authentication.dart';
import 'package:very_good_blog_app/features/login/login.dart';
import 'package:very_good_blog_app/widgets/widgets.dart'
    show TitleOfTextField, TextFieldDecoration;

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
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
            const TitleOfTextField('Tên người dùng'),
            _UsernameInput(),
            const Padding(padding: EdgeInsets.all(12)),
            const TitleOfTextField('Mật khẩu'),
            _PasswordInput(),
            const SizedBox(
              height: 24,
            ),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Quên mật khẩu',
                style: TextStyle(
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
              hintText: 'Nhập vào tên người dùng',
              errorText:
                  state.username.invalid ? 'Tên người dùng không hợp lệ' : null,
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
              hintText: 'Nhập vào mật khẩu',
              errorText:
                  state.password.invalid ? 'Mật khẩu không hợp lệ' : null,
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
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator(
                color: AppPalette.primaryColor,
              )
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                onPressed: state.status.isValidated
                    ? () {
                        context.read<LoginBloc>().add(const LoginSubmitted());
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(130, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  primary: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(
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
