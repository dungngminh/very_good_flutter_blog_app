import 'package:flutter/material.dart';
import 'package:very_good_blog_app/app/app.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Assets.icons.setting.svg(color: Palette.primaryColor),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
