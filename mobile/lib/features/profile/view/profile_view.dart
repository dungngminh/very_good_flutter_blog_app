import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/widgets/widgets.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Assets.icons.setting.svg(
                    color: Palette.primaryColor,
                    height: 26,
                  ),
                  onPressed: () => context.push(RouteManager.setting),
                ),
              ),
            ),
            const _ProfilePanel(),
            const SizedBox(
              height: 16,
            ),
            const _PostPanel(),
          ],
        ),
      ),
    );
  }
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
    return Expanded(
      flex: 5,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Palette.whiteBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
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
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 40, left: 24, right: 24),
                itemCount: 3,
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
            ),
          ],
        ),
      ),
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
                          ? Palette.primaryColor
                          : Palette.primaryTextColor,
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
                          ? Palette.primaryColor
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

class _ProfilePanel extends StatelessWidget {
  const _ProfilePanel();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Expanded(
              flex: 3,
              child: _AvatarDecoration(),
            ),
            Expanded(
              flex: 2,
              child: _BasicUserInformation(),
            )
          ],
        ),
      ),
    );
  }
}

class _BasicUserInformation extends StatelessWidget {
  const _BasicUserInformation();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text(
          'Nguyen Minh Dung',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Palette.primaryTextColor,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  '4',
                  style: AppTextTheme.titleTextStyle.copyWith(fontSize: 22),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'Bài viết',
                  style: AppTextTheme.regularTextStyle,
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '100',
                  style: AppTextTheme.titleTextStyle.copyWith(fontSize: 22),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'Người t.dõi',
                  style: AppTextTheme.regularTextStyle,
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '58',
                  style: AppTextTheme.titleTextStyle.copyWith(fontSize: 22),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'Đang t.dõi',
                  style: AppTextTheme.regularTextStyle,
                ),
              ],
            ),
          ],
        )
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
                color: Palette.primaryColor,
              );
            },
          ),
        ),
        Positioned(
          bottom: 6,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: Assets.images.komkat.image().image,
              ),
              Positioned(
                bottom: -4,
                right: -4,
                child: CircleAvatar(
                  backgroundColor: Palette.purpleSupportColor,
                  radius: 18,
                  child: Align(
                    child: IconButton(
                      icon: Assets.icons.camera.svg(
                        color: Palette.primaryColor,
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
