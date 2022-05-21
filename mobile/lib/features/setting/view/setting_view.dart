import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_blog_app/app/app.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Assets.icons.circleArrowLeft.svg(
                      color: Palette.primaryColor,
                    ),
                    onPressed: () => context.pop(),
                  ),
                  const Text(
                    'Thiết lập',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Palette.primaryTextColor,
                    ),
                  ),
                  const SizedBox.square(
                    dimension: 30,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
