import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/features/authentication/authentication.dart';
import 'package:very_good_blog_app/features/login/login.dart';
import 'package:very_good_blog_app/repository/repository.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          context.go('/');
        }
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: context.screenHeight * 0.06,
              ),
              Flexible(
                flex: 2,
                child: Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Palette.purpleSupportColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(90),
                        topRight: Radius.circular(90),
                        bottomLeft: Radius.circular(90),
                      ),
                    ),
                    child: FittedBox(
                      child: Assets.images.veryGood.svg(),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Flexible(
                flex: 3,
                child: BlocProvider<LoginBloc>(
                  create: (context) => LoginBloc(
                    authenticationRepository:
                        context.read<AuthenticationRepository>(),
                  ),
                  child: const LoginForm(),
                ),
              ),
              const Spacer(),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Chưa có tài khoản? ',
                    children: [
                      TextSpan(
                        text: 'Đăng ký',
                        style: const TextStyle(
                          color: Palette.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => context.push('/register'),
                      )
                    ],
                  ),
                  style: const TextStyle(
                    color: Palette.descriptionTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: context.screenHeight * 0.02,
              )
            ],
          ),
        ),
      ),
    );
  }
}
