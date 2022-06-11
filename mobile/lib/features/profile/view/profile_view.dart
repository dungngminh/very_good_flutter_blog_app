import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/features/profile/bloc/profile_bloc.dart';
import 'package:very_good_blog_app/widgets/widgets.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      title: const _TitleTile(),
      actions: [
        IconButton(
          icon: Assets.icons.setting.svg(
            color: AppPalette.whiteBackgroundColor,
            height: 30,
          ),
          splashRadius: 24,
          onPressed: () => context.push(AppRoute.setting),
        ),
      ],
      leading: Padding(
        padding: const EdgeInsets.all(4),
        child: Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Assets.icons.refresh.svg(
              color: AppPalette.whiteBackgroundColor,
              height: 28,
            ),
            splashRadius: 24,
            onPressed: () => context.read<ProfileBloc>().add(
                  const ProfileGetUserInformation(
                    isForRefreshing: true,
                  ),
                ),
          ),
        ),
      ),
      headerWidget: const _ProfilePanel(),
      headerExpandedHeight: 0.56,
      curvedBodyRadius: 40,
      appBarColor: AppPalette.primaryColor,
      body: const [
        _PostPanel(),
      ],
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
            child: BlocBuilder<ProfileBloc, ProfileState>(
              buildWhen: (previous, current) =>
                  previous.user?.avatarUrl != current.user?.avatarUrl,
              builder: (context, state) {
                return CircleAvatar(
                  backgroundImage: NetworkImage(state.user?.avatarUrl ?? ''),
                );
              },
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        BlocBuilder<ProfileBloc, ProfileState>(
          buildWhen: (previous, current) =>
              previous.user?.firstName != current.user?.firstName ||
              previous.user?.lastName != current.user?.lastName,
          builder: (context, state) {
            return Text(
              '${state.user?.firstName} '
              '${state.user?.lastName}',
              style: AppTextTheme.darkW700TextStyle
                  .copyWith(color: AppPalette.whiteBackgroundColor),
            );
          },
        )
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
                  child: IconButton(
                    icon: Assets.icons.refresh.svg(
                      color: AppPalette.primaryColor,
                      height: 28,
                    ),
                    splashRadius: 24,
                    onPressed: () => context.read<ProfileBloc>().add(
                          const ProfileGetUserInformation(
                            isForRefreshing: true,
                          ),
                        ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Assets.icons.setting.svg(
                      color: AppPalette.primaryColor,
                      height: 30,
                    ),
                    splashRadius: 24,
                    onPressed: () => context.push(AppRoute.setting),
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
            BlocBuilder<ProfileBloc, ProfileState>(
              buildWhen: (previous, current) =>
                  previous.user?.firstName != current.user?.firstName ||
                  previous.user?.lastName != current.user?.lastName,
              builder: (context, state) {
                return Text(
                  '${state.user?.firstName}'
                  ' ${state.user?.lastName}',
                  style: AppTextTheme.mediumTextStyle.copyWith(fontSize: 21),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BlocBuilder<ProfileBloc, ProfileState>(
                  buildWhen: (previous, current) =>
                      previous.user?.blogCount != current.user?.blogCount,
                  builder: (context, state) {
                    return _ProfileStat(
                      key: const ValueKey('post'),
                      content: 'Bài viết',
                      count: state.user?.blogCount ?? 0,
                    );
                  },
                ),
                BlocBuilder<ProfileBloc, ProfileState>(
                  buildWhen: (previous, current) =>
                      previous.user?.followerCount !=
                      current.user?.followerCount,
                  builder: (context, state) {
                    return _ProfileStat(
                      key: const ValueKey('follower'),
                      content: 'Người t.dõi',
                      count: state.user?.followerCount ?? 0,
                    );
                  },
                ),
                BlocBuilder<ProfileBloc, ProfileState>(
                  buildWhen: (previous, current) =>
                      previous.user?.followingCount !=
                      current.user?.followingCount,
                  builder: (context, state) {
                    return _ProfileStat(
                      key: const ValueKey('following'),
                      content: 'Đang t.dõi',
                      count: state.user?.followingCount ?? 0,
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
              BlocBuilder<ProfileBloc, ProfileState>(
                buildWhen: (previous, current) =>
                    previous.user?.avatarUrl != current.user?.avatarUrl,
                builder: (context, state) {
                  return CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(state.user?.avatarUrl ?? ''),
                  );
                },
              ),
              Positioned(
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

class _PostPanel extends StatefulWidget {
  const _PostPanel();

  @override
  State<_PostPanel> createState() => _PostPanelState();
}

class _PostPanelState extends State<_PostPanel> {
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
        ListView.separated(
          padding: const EdgeInsets.only(bottom: 40, left: 24, right: 24),
          itemCount: 10,
          primary: false,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return const BlogCard(
              title: 'How i hack Google, Microsoft,dadadadad,..',
              imageUrl: 'https://i.kym-cdn.com/'
                  'photos/images/facebook/001/839/197/2ad.png',
              likeCount: 300,
              dateAdded: '20 tháng 9, 2022',
              cardType: CardType.titleStatsTime,
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 16,
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
