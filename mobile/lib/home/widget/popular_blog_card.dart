import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/blog/blog.dart';
import 'package:very_good_blog_app/bookmark/book_mark.dart';
import 'package:very_good_blog_app/profile/profile.dart';
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
        AppRoutes.blog,
        extra: ExtraParams4<BlogModel, ProfileBloc, BlogBloc, BookmarkBloc>(
          param1: blog,
          param2: context.read<ProfileBloc>(),
          param3: context.read<BlogBloc>(),
          param4: context.read<BookmarkBloc>(),
        ),
      ),
      child: Container(
        width: context.screenHeight * 0.35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        // padding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CachedNetworkImage(
              imageUrl: blog.imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                width: context.screenHeight * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              progressIndicatorBuilder: (context, url, progress) =>
                  Shimmer.fromColors(
                baseColor: AppPalette.shimmerBaseColor,
                highlightColor: AppPalette.shimmerHighlightColor,
                child: Container(
                  width: context.screenHeight * 0.35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppPalette.whiteBackgroundColor,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: context.screenHeight * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    image: Assets.images.blankImage.image().image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              cacheManager: AppCacheManager.customCacheManager,
            ),
            Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: CircleAvatar(
                      backgroundColor:
                          AppPalette.whiteBackgroundColor.withOpacity(0.4),
                      child: Builder(
                        builder: (context) {
                          final bookmarks =
                              context.watch<BookmarkBloc>().state.bookmarks;
                          final isInUserBookmark = bookmarks.any(
                            (bookmark) => bookmark.id == blog.id,
                          );
                          return InkEffectIconButton(
                            onPressed: isInUserBookmark
                                ? () {
                                    context
                                        .read<BookmarkBloc>()
                                        .add(BookmarkRemoveBlog(blog: blog));
                                  }
                                : () {
                                    context
                                        .read<BookmarkBloc>()
                                        .add(BookmarkAddBlog(blog: blog));
                                  },
                            child: isInUserBookmark
                                ? Assets.icons.closeSquare.svg(
                                    color: AppPalette.purple700Color,
                                    height: 28,
                                  )
                                : Assets.icons.bookmark.svg(
                                    color: AppPalette.purple700Color,
                                    height: 24,
                                  ),
                          );
                        },
                      ),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                        style:
                            AppTextTheme.titleTextStyle.copyWith(fontSize: 15),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
