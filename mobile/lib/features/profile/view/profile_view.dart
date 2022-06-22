import 'dart:math' as math;

import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/features/profile/bloc/profile_bloc.dart';
import 'package:very_good_blog_app/widgets/widgets.dart';

// TODO(dung.nguyen): handle lock scroll body when listBlog isEmpty
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) =>
          previous.profileStatus != current.profileStatus,
      listener: (context, state) {
        if (state.profileStatus == ProfileStatus.loading) {
          Fluttertoast.cancel();
          Fluttertoast.showToast(msg: 'Đang cập nhật dữ liệu');
        } else if (state.profileStatus == ProfileStatus.error) {
          Fluttertoast.cancel();
          Fluttertoast.showToast(msg: 'Cập nhất thất bại, hãy thử lại!');
        } else if (state.profileStatus == ProfileStatus.done) {
          Fluttertoast.cancel();
          Fluttertoast.showToast(msg: 'Cập nhật dữ liệu thành công');
        }
      },
      child: DraggableHome(
        title: const _TitleTile(),
        actions: const [
          _SettingButton(
            color: AppPalette.whiteBackgroundColor,
          )
        ],
        leading: Padding(
          padding: const EdgeInsets.all(4),
          child: Align(
            alignment: Alignment.centerRight,
            child: Builder(
              builder: (context) {
                final status = context.select(
                  (ProfileBloc profileBloc) => profileBloc.state.profileStatus,
                );
                return _RotateIconButton(
                  icon: Assets.icons.refresh.svg(
                    color: AppPalette.whiteBackgroundColor,
                    height: 28,
                  ),
                  isLoading: status == ProfileStatus.loading,
                  onPressed: () => context.read<ProfileBloc>().add(
                        ProfileGetUserInformation(),
                      ),
                );
              },
            ),
          ),
        ),
        headerWidget: const _ProfilePanel(),
        headerExpandedHeight: 0.56,
        curvedBodyRadius: 40,
        appBarColor: AppPalette.primaryColor,
        body: const [
          _BlogPanel(),
        ],
      ),
    );
  }
}

class _RotateIconButton extends StatefulWidget {
  const _RotateIconButton({
    required this.icon,
    this.isLoading = false,
    required this.onPressed,
  });

  final Widget icon;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  State<_RotateIconButton> createState() => _RotateIconButtonState();
}

class _RotateIconButtonState extends State<_RotateIconButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ),
    );

    super.initState();
  }

  @override
  void didUpdateWidget(covariant _RotateIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        return Transform.rotate(
          angle:
              widget.isLoading ? _animationController.value * 2 * math.pi : 0,
          child: IconButton(
            icon: widget.icon,
            splashRadius: 24,
            onPressed: widget.onPressed,
          ),
        );
      },
    );
  }
}

class _TitleTile extends StatelessWidget {
  const _TitleTile();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: AppPalette.purpleSupportColor,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Builder(
              builder: (context) {
                final avatarUrl = context.select(
                  (ProfileBloc profileBloc) =>
                      profileBloc.state.user?.avatarUrl,
                );

                return CircleAvatar(
                  backgroundImage: avatarUrl == null || avatarUrl.isEmpty
                      ? Assets.images.blankAvatar.image().image
                      : NetworkImage(avatarUrl),
                );
              },
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Builder(
          builder: (context) {
            final firstName = context.select(
              (ProfileBloc profileBloc) => profileBloc.state.user?.firstName,
            );
            final lastName = context.select(
              (ProfileBloc profileBloc) => profileBloc.state.user?.lastName,
            );
            return Text(
              '$firstName $lastName',
              style: AppTextTheme.darkW700TextStyle
                  .copyWith(color: AppPalette.whiteBackgroundColor),
            );
          },
        ),
      ],
    );
  }
}

class _ProfilePanel extends StatelessWidget {
  const _ProfilePanel();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Builder(
                    builder: (context) {
                      final status = context.select(
                        (ProfileBloc profileBloc) =>
                            profileBloc.state.profileStatus,
                      );
                      return _RotateIconButton(
                        icon: Assets.icons.refresh.svg(
                          color: AppPalette.primaryColor,
                          height: 28,
                        ),
                        isLoading: status == ProfileStatus.loading,
                        onPressed: () => context.read<ProfileBloc>().add(
                              ProfileGetUserInformation(),
                            ),
                      );
                    },
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(4),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _SettingButton(
                    color: AppPalette.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: const [
                SizedBox(
                  height: 180,
                  child: _AvatarDecoration(),
                ),
                SizedBox(
                  height: 4,
                ),
                SizedBox(
                  height: 120,
                  child: _BasicUserInformation(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingButton extends StatelessWidget {
  const _SettingButton({
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Assets.icons.setting.svg(
        color: color,
        height: 30,
      ),
      splashRadius: 24,
      onPressed: () => context.push(
        AppRoute.setting,
        extra: context.read<ProfileBloc>(),
      ),
    );
  }
}

class _BasicUserInformation extends StatelessWidget {
  const _BasicUserInformation();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) => previous.user != current.user,
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Builder(
              builder: (context) {
                final firstName = context.select(
                  (ProfileBloc profileBloc) =>
                      profileBloc.state.user?.firstName,
                );
                final lastName = context.select(
                  (ProfileBloc profileBloc) => profileBloc.state.user?.lastName,
                );
                return Text(
                  '$firstName $lastName',
                  style: AppTextTheme.mediumTextStyle.copyWith(fontSize: 21),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Builder(
                  builder: (context) {
                    final userBlogs = context.select(
                      (ProfileBloc profileBloc) =>
                          profileBloc.state.user?.blogs,
                    );
                    return _ProfileStat(
                      key: const ValueKey('post'),
                      content: 'Bài viết',
                      count: userBlogs?.length ?? 0,
                    );
                  },
                ),
                Builder(
                  builder: (context) {
                    final followerCount = context.select(
                      (ProfileBloc profileBloc) =>
                          profileBloc.state.user?.followerCount,
                    );
                    return _ProfileStat(
                      key: const ValueKey('follower'),
                      content: 'Người t.dõi',
                      count: followerCount ?? 0,
                    );
                  },
                ),
                Builder(
                  builder: (context) {
                    final followingCount = context.select(
                      (ProfileBloc profileBloc) =>
                          profileBloc.state.user?.followingCount,
                    );
                    return _ProfileStat(
                      key: const ValueKey('following'),
                      content: 'Đang t.dõi',
                      count: followingCount ?? 0,
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({
    super.key,
    required this.count,
    required this.content,
  });

  final int count;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: AppTextTheme.titleTextStyle.copyWith(fontSize: 22),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          content,
          style: AppTextTheme.regularTextStyle,
        ),
      ],
    );
  }
}

class _AvatarDecoration extends StatelessWidget {
  const _AvatarDecoration();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        ClipPath(
          clipper: BackgroundClipper(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                height: constraints.maxHeight,
                color: AppPalette.primaryColor,
              );
            },
          ),
        ),
        Positioned(
          bottom: 4,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomRight,
            children: [
              Builder(
                builder: (context) {
                  final avatarUrl = context.select(
                    (ProfileBloc profileBloc) =>
                        profileBloc.state.user?.avatarUrl,
                  );
                  return CircleAvatar(
                    radius: 60,
                    backgroundColor: AppPalette.purple700SupportColor,
                    backgroundImage: avatarUrl == null || avatarUrl.isEmpty
                        ? Assets.images.blankAvatar.image().image
                        : NetworkImage(avatarUrl),
                  );
                },
              ),
              Visibility(
                visible: false,
                child: Positioned(
                  bottom: -4,
                  right: -4,
                  child: CircleAvatar(
                    backgroundColor: AppPalette.purpleSupportColor,
                    radius: 18,
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
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final h = size.height;
    final w = size.width;

    final path = Path()
      ..moveTo(0, h / 2)
      ..lineTo(0, h)
      ..lineTo(w, h / 2)
      ..lineTo(w, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class _BlogPanel extends StatefulWidget {
  const _BlogPanel();

  @override
  State<_BlogPanel> createState() => _BlogPanelState();
}

class _BlogPanelState extends State<_BlogPanel> {
  late ValueNotifier<int> _currentTabIndex;

  @override
  void initState() {
    super.initState();
    _currentTabIndex = ValueNotifier(0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
          child: Row(
            children: [
              _buildTab(index: 0, nameTab: 'Tất cả'),
              const SizedBox(
                width: 16,
              ),
              _buildTab(index: 1, nameTab: 'Đã thích'),
            ],
          ),
        ),
        Builder(
          builder: (context) {
            final userBlogs = context.watch<ProfileBloc>().state.userBlogs;
            if (userBlogs.isEmpty) {
              return const Center(
                child: Text('Bạn chưa có blog nào'),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.only(bottom: 40, left: 24, right: 24),
              itemCount: userBlogs.length,
              primary: false,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final blog = userBlogs[index];
                return BlogCard(
                  blog: blog,
                  // title: blog.title,
                  // imageUrl: blog.imageUrl,
                  // likeCount: blog.likeCount,
                  // dateAdded: '${blog.createdAt.day} tháng '
                  //     '${blog.createdAt.month}, ${blog.createdAt.year}',
                  cardType: CardType.titleStatsTime,
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 16,
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildTab({required int index, required String nameTab}) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentTabIndex,
      builder: (context, currentValue, child) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _currentTabIndex.value = index,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  AnimatedDefaultTextStyle(
                    style: TextStyle(
                      color: currentValue == index
                          ? AppPalette.primaryColor
                          : AppPalette.primaryTextColor,
                      fontSize: 15,
                    ),
                    duration: const Duration(milliseconds: 200),
                    child: Text(nameTab),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 6,
                    width: 6,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentValue == index
                          ? AppPalette.primaryColor
                          : Colors.transparent,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
