import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/features/profile/bloc/profile_bloc.dart';

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
                    // alignment: Alignment.centerLeft,
                    padding: EdgeInsets.zero,
                    icon: Assets.icons.circleArrowLeft.svg(
                      color: AppPalette.primaryColor,
                      height: 36,
                    ),
                    splashRadius: 24,
                    onPressed: () => context.pop(),
                  ),
                  const Text(
                    'Thiết lập',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: AppPalette.primaryTextColor,
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
                primaryColor: AppPalette.purple700Color,
                supportBackgroundColor: AppPalette.purple700SupportColor,
              ),
              _SettingTile(
                iconPath: Assets.icons.filter.path,
                onTapAction: () {},
                title: 'Tùy chọn',
                primaryColor: AppPalette.pink500Color,
                supportBackgroundColor: AppPalette.pink500SupportColor,
              ),
              _SettingTile(
                iconPath: Assets.icons.info.path,
                onTapAction: () {},
                title: 'Về Very Good Blog App',
                primaryColor: AppPalette.mintColor,
                supportBackgroundColor: AppPalette.mintSupportColor,
              ),
              _SettingTile(
                iconPath: Assets.icons.logOut.path,
                onTapAction: () => context
                    .read<ProfileBloc>()
                    .add(ProfileUserLogoutRequested()),
                title: 'Đăng xuất',
                primaryColor: AppPalette.primaryColor,
                supportBackgroundColor: AppPalette.purpleSupportColor,
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
      child: GestureDetector(
        onTap: onTapAction,
        behavior: HitTestBehavior.opaque,
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
                  color: AppPalette.primaryTextColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
