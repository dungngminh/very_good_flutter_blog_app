import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:very_good_blog_app/app/app.dart';

class BlogCard extends StatelessWidget {
  const BlogCard({
    super.key,
    required this.username,
    required this.title,
  });

  final String username;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenHeight * 0.35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Palette.primaryColor,
        image: DecorationImage(
          image: Image.network(
            'https://vissaihotel.vn/photo/trang-an-ha-long-bay-on-land.png',
          ).image,
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: ClipOval(
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  splashRadius: 20,
                  icon: const DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Icon(
                        PhosphorIcons.bookmarkFill,
                        size: 26,
                        color: Palette.whiteBackgroundColor,
                      ),
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Palette.whiteBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: Assets.images.komkat.image().image,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Palette.primaryTextColor,
                            ),
                          ),
                          const Text(
                            '20 phút trước',
                            style: TextStyle(
                              fontSize: 13,
                              color: Palette.primaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Palette.primaryTextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
