import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/features/blog/blog.dart';
import 'package:very_good_blog_app/features/profile/profile.dart';
import 'package:very_good_blog_app/models/models.dart';
import 'package:very_good_blog_app/widgets/widgets.dart';

class PopularBlogCard extends StatelessWidget {
  const PopularBlogCard({
    super.key,
    required this.blog,
  });

  final BlogModel blog;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        AppRoute.blog,
        extra: ExtraParams3<BlogModel, ProfileBloc, BlogBloc>(
          param1: blog,
          param2: context.read<ProfileBloc>(),
          param3: context.read<BlogBloc>(),
        ),
      ),
      child: Container(
        width: context.screenHeight * 0.35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
            image: Image.network(
              blog.imageUrl,
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
              child: CircleAvatar(
                backgroundColor:
                    AppPalette.whiteBackgroundColor.withOpacity(0.4),
                child: InkEffectIconButton(
                  child: Assets.icons.bookmark.svg(
                    color: AppPalette.purple700Color,
                    height: 24,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color: AppPalette.whiteBackgroundColor,
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
                        backgroundImage: blog.user.avatarUrl.isEmpty
                            ? Assets.images.blankAvatar.image().image
                            : NetworkImage(blog.user.avatarUrl),
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
                              blog.user.username,
                              style: AppTextTheme.titleTextStyle
                                  .copyWith(fontSize: 14),
                            ),
                            Text(
                              timeago.format(
                                blog.createdAt,
                              ),
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
                    blog.title,
                    style: AppTextTheme.titleTextStyle.copyWith(fontSize: 15),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
