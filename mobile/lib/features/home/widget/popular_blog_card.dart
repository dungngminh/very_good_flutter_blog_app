import 'package:flutter/material.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/widgets/widgets.dart';

class PopularBlogCard extends StatelessWidget {
  const PopularBlogCard({
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
            child: InkEffectWidget(
              child: Assets.icons.bookmark.svg(
                color: Palette.whiteBackgroundColor,
                height: 24,
              ),
              onTapEvent: () {},
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
                            style: AppTextTheme.titleTextStyle
                                .copyWith(fontSize: 14),
                          ),
                          Text(
                            '20 phút trước',
                            style: AppTextTheme.regularTextStyle
                                .copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: AppTextTheme.titleTextStyle.copyWith(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
