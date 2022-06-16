import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/features/register/register.dart';
import 'package:very_good_blog_app/widgets/widgets.dart';

class ResigterForm extends StatelessWidget {
  const ResigterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTileTextField('Họ của bạn'),
            _FirstnameInput(),
            const SizedBox(
              height: 16,
            ),
            _buildTileTextField('Tên của bạn'),
            _LastnameInput(),
            const SizedBox(
              height: 16,
            ),
            _buildTileTextField('Tên người dùng'),
            _UsernameInput(),
            const SizedBox(
              height: 16,
            ),
            _buildTileTextField('Mật khẩu'),
            _PasswordInput(),
            const SizedBox(
              height: 16,
            ),
            _buildTileTextField('Xác nhận mật khẩu'),
            _ConfirmedPasswordInput(),
            const Padding(padding: EdgeInsets.all(12)),
            Center(
              child: _RegisterButton(),
            ),
          ],
        ),
      ),
    );
  }

  Text _buildTileTextField(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppPalette.primaryTextColor,
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextFieldDecoration(
          child: TextField(
            key: const Key('registerForm_usernameInput_textField'),
            onChanged: (username) => context.read<RegisterBloc>().add(
                  RegisterEvent(
                    RegisterEventType.userNameChanged,
                    input: username,
                  ),
                ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 16, right: 16),
              border: InputBorder.none,
              hintText: 'Nhập vào tên người dùng',
              errorText:
                  state.username.invalid ? 'Tên người dùng không hợp lệ' : null,
            ),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
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
            obscureText: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 16, right: 16),
              border: InputBorder.none,
              hintText: 'Nhập vào mật khẩu',
              errorText:
                  state.password.invalid ? 'Mật khẩu không hợp lệ' : null,
            ),
          ),
        );
      },
    );
  }
}

class _ConfirmedPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            obscureText: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 16, right: 16),
              border: InputBorder.none,
              hintText: 'Nhập lại mật khẩu',
              errorText: state.confirmedPassword.invalid
                  ? 'Mật khẩu không trùng'
                  : null,
            ),
          ),
        );
      },
    );
  }
}

class _FirstnameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.firstname != current.firstname,
      builder: (context, state) {
        return TextFieldDecoration(
          child: TextField(
            key: const Key('registerForm_firstnameInput_textField'),
            onChanged: (firstname) => context.read<RegisterBloc>().add(
                  RegisterEvent(
                    RegisterEventType.firstNameChanged,
                    input: firstname,
                  ),
                ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 16, right: 16),
              border: InputBorder.none,
              hintText: 'Nhập vào họ của bạn',
              errorText:
                  state.firstname.invalid ? 'Họ của bạn không hợp lệ' : null,
            ),
          ),
        );
      },
    );
  }
}

class _LastnameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.lastname != current.lastname,
      builder: (context, state) {
        return TextFieldDecoration(
          child: TextField(
            key: const Key('registerForm_passwordInput_textField'),
            onChanged: (lastname) => context.read<RegisterBloc>().add(
                  RegisterEvent(
                    RegisterEventType.lastNameChanged,
                    input: lastname,
                  ),
                ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 16, right: 16),
              border: InputBorder.none,
              hintText: 'Nhập vào tên của bạn',
              errorText:
                  state.lastname.invalid ? 'Tên của bạn không hợp lệ' : null,
            ),
          ),
        );
      },
    );
  }
}

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator(
                color: AppPalette.primaryColor,
              )
            : ElevatedButton(
                key: const Key('registerForm_continue_raisedButton'),
                onPressed: state.status.isValidated
                    ? () {
                        context.read<RegisterBloc>().add(
                              const RegisterEvent(RegisterEventType.submitted),
                            );
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
                  'Đăng ký',
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
