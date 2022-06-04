import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_blog_app/app/app.dart';

class BlogView extends StatelessWidget {
  const BlogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Assets.icons.circleArrowLeft.svg(
                    color: AppPalette.primaryColor,
                    height: 36,
                  ),
                  splashRadius: 24,
                  onPressed: () => context.pop(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: Assets.images.komkat.image().image,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'dungngminh',
                              style: AppTextTheme.titleTextStyle
                                  .copyWith(fontSize: 16),
                            ),
                            Text(
                              '20 phút trước',
                              style: AppTextTheme.decriptionTextStyle
                                  .copyWith(fontSize: 14),
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      'How i hack Microsoft, Google, '
                      'Meta to get user information',
                      style: AppTextTheme.titleTextStyle.copyWith(fontSize: 19),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      height: context.screenHeight / 3.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: Image.network(
                            'https://miro.medium.com/max/1400/1*yuiVVfFOuPnrsHcUx7xf_Q.png',
                          ).image,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Assets.icons.heart.svg(
                          color: AppPalette.pink500Color,
                          height: 18,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          '1000',
                          style: AppTextTheme.regularTextStyle
                              .copyWith(fontSize: 12),
                        ),
                        const Spacer(),
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: Assets.icons.bookmark.svg(
                            color: AppPalette.purple700Color,
                            height: 20,
                          ),
                          splashRadius: 24,
                          onPressed: () {},
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
