import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/features/profile/profile.dart'
    show ProfileBloc, ProfileUserLogoutRequested;
import 'package:very_good_blog_app/features/setting/setting.dart'
    show SettingTile;
import 'package:very_good_blog_app/widgets/widgets.dart' show ActionBar;

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: context.padding.top + 16,
        ),
        child: Column(
          children: [
            const ActionBar(
              title: 'Thiết lập',
            ),
            const SizedBox(
              height: 8,
            ),
            SettingTile(
              iconPath: Assets.icons.profile.path,
              onTap: () => context.push(
                '${AppRoutes.setting}/${AppRoutes.editProfile}',
                extra: context.read<ProfileBloc>(),
              ),
              title: 'Thông tin cá nhân',
              primaryColor: AppPalette.purple700Color,
              supportBackgroundColor: AppPalette.purple700SupportColor,
            ),
            SettingTile(
              iconPath: Assets.icons.filter.path,
              onTap: () {},
              title: 'Tùy chọn',
              primaryColor: AppPalette.pink500Color,
              supportBackgroundColor: AppPalette.pink500SupportColor,
            ),
            SettingTile(
              iconPath: Assets.icons.info.path,
              onTap: () {},
              title: 'Về Very Good Blog App',
              primaryColor: AppPalette.mintColor,
              supportBackgroundColor: AppPalette.mintSupportColor,
            ),
            SettingTile(
              iconPath: Assets.icons.logOut.path,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text('Đăng xuất'),
                      content:
                          const Text('Xác nhận đăng xuất Very Good Blog App'),
                      actions: [
                        TextButton(
                          onPressed: () => context
                              .read<ProfileBloc>()
                              .add(ProfileUserLogoutRequested()),
                          child: const Text(
                            'Đăng xuất',
                            style: TextStyle(
                              color: AppPalette.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Hủy',
                            style: TextStyle(color: AppPalette.primaryColor),
                          ),
                        )
                      ],
                    );
                  },
                );
              },
              title: 'Đăng xuất',
              primaryColor: AppPalette.primaryColor,
              supportBackgroundColor: AppPalette.purpleSupportColor,
            )
          ],
        ),
      ),
    );
  }
}
