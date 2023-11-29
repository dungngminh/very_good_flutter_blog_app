import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/blog/blog.dart';
import 'package:very_good_blog_app/l10n/l10n.dart';
import 'package:very_good_blog_app/profile/profile.dart';
import 'package:very_good_blog_app/widgets/blog_card_placeholder.dart';
import 'package:very_good_blog_app/widgets/widgets.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) =>
          previous.profileStatus != current.profileStatus,
      listener: (context, state) {
        if (state.profileStatus == ProfileStatus.error) {
          Fluttertoast.cancel();
          Fluttertoast.showToast(msg: 'Cập nhất thất bại, hãy thử lại!');
        }
      },
      child: Builder(
        builder: (context) {
          final userBlogsLength = context.select(
            (ProfileBloc profileBloc) => profileBloc.state.userBlogs.length,
          );

          return DraggableHome(
            title: const _TitleTile(),
            actions: const [
              _SettingButton(
                color: AppPalette.whiteBackgroundColor,
              ),
            ],
            // physics: userBlogsLength > 0
            //     ? const BouncingScrollPhysics()
            //     : const NeverScrollableScrollPhysics(),
            leading: Padding(
              padding: const EdgeInsets.all(4),
              child: Align(
                alignment: Alignment.centerRight,
                child: Builder(
                  builder: (context) {
                    final status = context.select(
                      (ProfileBloc profileBloc) =>
                          profileBloc.state.profileStatus,
                    );
                    return RotateIconButton(
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
            headerExpandedHeight: 0.54,
            curvedBodyRadius: 40,
            appBarColor: AppPalette.primaryColor,
            body: const [
              _BlogPanel(),
            ],
          );
        },
      ),
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
                      return RotateIconButton(
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
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
                ),
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
        AppRoutes.setting,
        extra: context.read<ProfileBloc>(),
      ),
    );
  }
}

class _BasicUserInformation extends StatelessWidget {
  const _BasicUserInformation();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                    final userBlogs =
                        context.watch<ProfileBloc>().state.userBlogs;

                    return _ProfileStat(
                      key: const ValueKey('post'),
                      content: l10n.blog,
                      count: userBlogs.length,
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
                      content: l10n.follower,
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
                      content: l10n.following,
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
          clipper: _BackgroundClipper(),
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
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BackgroundClipper extends CustomClipper<Path> {
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
    final l10n = context.l10n;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
          child: Row(
            children: [
              _buildTab(index: 0, nameTab: l10n.all),
              const SizedBox(
                width: 16,
              ),
              _buildTab(index: 1, nameTab: l10n.liked),
            ],
          ),
        ),
        ValueListenableBuilder<int>(
          valueListenable: _currentTabIndex,
          builder: (context, index, child) {
            return LazyLoadIndexedStack(
              index: index,
              children: [
                Builder(
                  builder: (context) {
                    final userBlogs =
                        context.watch<ProfileBloc>().state.userBlogs;
                    if (userBlogs.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: Center(
                          child: Text(l10n.noOwnBlogs),
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.only(
                        bottom: 40,
                        left: 24,
                        right: 24,
                      ),
                      itemCount: userBlogs.length,
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final blog = userBlogs[index];
                        return BlogCard(
                          blog: blog,
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
                const _BuildLikedBlogList(),
              ],
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BuildLikedBlogList extends StatelessWidget {
  const _BuildLikedBlogList();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Builder(
      builder: (context) {
        final userLikedBlogs =
            context.watch<ProfileBloc>().state.userLikedBlogs;
        final likedBlogStatus = context.select(
          (ProfileBloc profileBloc) => profileBloc.state.likeBlogStatus,
        );
        final listCurrentBlog = context.watch<BlogBloc>().state.blogs;
        final listLikedBLogs = listCurrentBlog
            .where(
              (blog) => userLikedBlogs.any((likedBlog) => likedBlog == blog.id),
            )
            .toList();
        if (likedBlogStatus == LikeBlogStatus.loading) {
          return ListView.separated(
            padding: const EdgeInsets.only(
              bottom: 40,
              left: 24,
              right: 24,
            ),
            itemCount: 3,
            physics: const NeverScrollableScrollPhysics(),
            primary: false,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return const BlogCardPlaceholder();
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 16,
              );
            },
          );
        }
        if (likedBlogStatus == LikeBlogStatus.error) {
          return Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Center(
              child: Text(l10n.unknownError),
            ),
          );
        }
        if (userLikedBlogs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Center(
              child: Text(l10n.noLikedBlogs),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 24,
            right: 24,
          ),
          itemCount: listLikedBLogs.length,
          primary: false,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final blog = listLikedBLogs[index];
            return BlogCard(
              blog: blog,
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
    );
  }
}
