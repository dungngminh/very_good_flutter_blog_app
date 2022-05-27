import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            horizontal: 24,
            vertical: 16,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.zero,
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
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: SizedBox.square(
                      dimension: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              _SettingTile(
                iconPath: Assets.icons.profile.path,
                onTapAction: () {},
                title: 'Thông tin cá nhân',
                primaryColor: Palette.purple700Color,
                supportBackgroundColor: Palette.purple700SupportColor,
              ),
              _SettingTile(
                iconPath: Assets.icons.filter.path,
                onTapAction: () {},
                title: 'Tùy chọn',
                primaryColor: Palette.pink500Color,
                supportBackgroundColor: Palette.pink500SupportColor,
              ),
              _SettingTile(
                iconPath: Assets.icons.info.path,
                onTapAction: () {},
                title: 'Về Very Good Blog App',
                primaryColor: Palette.mintColor,
                supportBackgroundColor: Palette.mintSupportColor,
              ),
              _SettingTile(
                iconPath: Assets.icons.logOut.path,
                onTapAction: () {},
                title: 'Đăng xuất',
                primaryColor: Palette.primaryColor,
                supportBackgroundColor: Palette.purpleSupportColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.title,
    required this.iconPath,
    required this.primaryColor,
    required this.supportBackgroundColor,
    required this.onTapAction,
  });

  final String title;
  final String iconPath;
  final Color primaryColor;
  final Color supportBackgroundColor;
  final VoidCallback onTapAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: supportBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(
              iconPath,
              color: primaryColor,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Palette.primaryTextColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}
