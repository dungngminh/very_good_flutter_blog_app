import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart' show BlogModel;
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/blog/bloc/blog_bloc.dart';
import 'package:very_good_blog_app/bookmark/book_mark.dart';
import 'package:very_good_blog_app/profile/bloc/profile_bloc.dart';
import 'package:very_good_blog_app/widgets/ink_response_widget.dart';

enum CardType {
  titleAuthorTime,
  titleStatsTime,
  titleStatsAuthor,
}

class BlogCard extends StatelessWidget {
  const BlogCard({
    super.key,
    this.cardType = CardType.titleAuthorTime,
    required this.blog,
    this.needMargin = false,
    this.enableBookmarkButton = false,
    this.isOffline = false,
  });

  final BlogModel blog;
  final bool enableBookmarkButton;
  final bool needMargin;
  final bool isOffline;

  /// This setting for order of content display from top to bottom
  ///
  /// For Default : `CardType.titleAuthorTime` that means content order is
  /// title is first, then author, last is Time (Date, Month, Year)
  ///
  /// See also:
  ///
  ///  * `CardType.titleStatsTime` that means content order is
  /// title is first, then Stats (Like Count), last is Time (Date, Month, Year)
  ///  * `CardType.titleStatsAuthor` that means content order is
  /// title is first, then Stats (Like Count), last is Time (Date, Month, Year)
  final CardType cardType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isOffline
          ? () => context.push(
                '${context.currentLocation}/${AppRoutes.offlineBlog}',
                extra: blog,
              )
          : () => context.push(
                AppRoutes.blog,
                extra: ExtraParams4<BlogModel, ProfileBloc, BlogBloc,
                    BookmarkBloc>(
                  param1: blog,
                  param2: context.read<ProfileBloc>(),
                  param3: context.read<BlogBloc>(),
                  param4: context.read<BookmarkBloc>(),
                ),
              ),
      child: Container(
        // height: 135,
        padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
        margin: needMargin
            ? const EdgeInsets.symmetric(horizontal: 24)
            : EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppPalette.fieldColor,
        ),
        child: Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: CachedNetworkImage(
                  imageUrl: blog.imageUrl,
                  imageBuilder: (context, imageProvider) => DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
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
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppPalette.whiteBackgroundColor,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: Assets.images.blankImage.image().image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  cacheManager: AppCacheManager.customCacheManager,
                ),
              ),
            ),
            _buildCardContent(cardType),
            if (enableBookmarkButton)
              InkEffectIconButton(
                child: Assets.icons.bookmark
                    .svg(color: AppPalette.deepPurpleColor),
                onPressed: () {},
              )
            else
              const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardContent(CardType cardType) {
    switch (cardType) {
      case CardType.titleAuthorTime:
        return Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: AppTextTheme.titleTextStyle.copyWith(fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  blog.user.username,
                  style:
                      AppTextTheme.decriptionTextStyle.copyWith(fontSize: 13),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  timeago.format(blog.createdAt),
                  style:
                      AppTextTheme.decriptionTextStyle.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      case CardType.titleStatsTime:
        return Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: AppTextTheme.titleTextStyle.copyWith(fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Assets.icons.heart.svg(
                      height: 22,
                      color: AppPalette.pink500Color,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      '${blog.likeCount}',
                      style: AppTextTheme.mediumTextStyle,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  timeago.format(blog.createdAt),
                  style:
                      AppTextTheme.decriptionTextStyle.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      case CardType.titleStatsAuthor:
        return Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: const TextStyle(
                    color: AppPalette.primaryTextColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Assets.icons.heart.svg(
                      height: 20,
                      color: AppPalette.pink500Color,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      '300',
                      style:
                          AppTextTheme.mediumTextStyle.copyWith(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  blog.user.username,
                  style: AppTextTheme.decriptionTextStyle.copyWith(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }
}
