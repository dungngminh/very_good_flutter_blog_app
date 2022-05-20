import 'package:flutter/material.dart';
import 'package:very_good_blog_app/app/app.dart';

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
                  icon: Assets.icons.setting.svg(color: Palette.primaryColor),
                  onPressed: () {},
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
  @override
  Widget build(BuildContext context) {
    return  const Expanded(
      flex: 5,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Palette.whiteBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
      ),
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
              children: const [
                Text(
                  '4',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: Palette.primaryTextColor,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Bài viết',
                  style: TextStyle(
                    color: Palette.primaryTextColor,
                  ),
                ),
              ],
            ),
            Column(
              children: const [
                Text(
                  '100',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: Palette.primaryTextColor,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Người t.dõi',
                  style: TextStyle(
                    color: Palette.primaryTextColor,
                  ),
                ),
              ],
            ),
            Column(
              children: const [
                Text(
                  '58',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: Palette.primaryTextColor,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Đang t.dõi',
                  style: TextStyle(
                    color: Palette.primaryTextColor,
                  ),
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
                      splashRadius: 20,
                      padding: const EdgeInsets.all(6),
                      icon: Assets.icons.camera.svg(
                        color: Palette.primaryColor,
                      ),
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
