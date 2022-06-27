import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/features/authentication/authentication.dart';
import 'package:very_good_blog_app/features/register/bloc/register_bloc.dart';
import 'package:very_good_blog_app/features/register/view/register_form.dart';
import 'package:very_good_blog_app/repository/repository.dart';
import 'package:very_good_blog_app/widgets/tap_hide_keyboard.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.status == AuthenticationStatus.successfullyRegistered) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Đăng ký thành công')),
            );
          context.pop();
        } else if (state.status ==
            AuthenticationStatus.unsuccessfullyRegistered) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Đăng ký thất bại')),
            );
        } else if (state.status == AuthenticationStatus.existed) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Tên người dùng đã tồn tại')),
            );
        }
      },
      child: TapHideKeyboard(
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
