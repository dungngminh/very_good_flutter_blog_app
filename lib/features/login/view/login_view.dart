import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_blog_app/config/config.dart';
import 'package:very_good_blog_app/features/authentication/authentication.dart';
import 'package:very_good_blog_app/features/login/login.dart';
import 'package:very_good_blog_app/repository/authentication_repository.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          context.go('/');
          return;
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
                    width: 180,
                    height: 180,
                    decoration: const BoxDecoration(
                      color: Palette.purpleSupportColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(90),
                        topRight: Radius.circular(90),
                        bottomLeft: Radius.circular(90),
                      ),
                    ),
                    child: FittedBox(
                      child: SvgPicture.asset(
                        'assets/images/very_good.svg',
                      ),
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
                        recognizer: TapGestureRecognizer()..onTap = () {},
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
