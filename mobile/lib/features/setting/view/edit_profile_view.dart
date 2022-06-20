import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/features/profile/profile.dart';
import 'package:very_good_blog_app/widgets/action_bar.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

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
            ActionBar(
              title: 'Thông tin cá nhân',
              actions: [
                IconButton(
                  icon: Assets.icons.edit.svg(
                    color: AppPalette.deepPurpleColor,
                    height: 28,
                  ),
                  onPressed: () {
                    context
                        .read<ProfileBloc>()
                        .add(ProfileEditInformationRequested());
                  },
                  splashRadius: 24,
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            const _UserAvatar()
          ],
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomRight,
      children: [
        Builder(
          builder: (context) {
            final avatarUrl = context.select(
              (ProfileBloc profileBloc) => profileBloc.state.user?.avatarUrl,
            );
            return CircleAvatar(
              radius: 70,
              backgroundImage: avatarUrl == null || avatarUrl.isEmpty
                  ? Assets.images.blankAvatar.image().image
                  : NetworkImage(avatarUrl),
            );
          },
        ),
        Positioned(
          bottom: -2,
          right: -2,
          child: CircleAvatar(
            backgroundColor: AppPalette.purpleSupportColor,
            radius: 19,
            child: Align(
              child: IconButton(
                icon: Assets.icons.camera.svg(
                  color: AppPalette.primaryColor,
                ),
                splashRadius: 24,
                // TODO(dungngminh): add function user picture
                onPressed: () {},
              ),
            ),
          ),
        )
      ],
    );
  }
}
