import 'package:flutter/material.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/widgets/ink_response_widget.dart';

enum CardType {
  titleAuthorTime,
  titleStatsTime,
  titleStatsAuthor,
}

class BlogCard extends StatelessWidget {
  const BlogCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.likeCount,
    this.author,
    required this.dateAdded,
    this.cardType = CardType.titleAuthorTime,
    this.needMargin = false,
  });

  final String title;
  final String imageUrl;
  final int? likeCount;
  final String? author;
  final String dateAdded;
  final bool needMargin;

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
    return InkWell(
      child: Container(
        // height: 135,
        margin: needMargin ? const EdgeInsets.symmetric(horizontal: 24) : null,
        padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppPalette.fieldColor,
        ),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildCardContent(cardType),
            if (cardType == CardType.titleAuthorTime)
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
                  title,
                  style: AppTextTheme.titleTextStyle.copyWith(fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  author!,
                  style:
                      AppTextTheme.decriptionTextStyle.copyWith(fontSize: 13),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  dateAdded,
                  style:
                      AppTextTheme.decriptionTextStyle.copyWith(fontSize: 12),
                )
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
                  title,
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
                    const Text(
                      '300',
                      style: AppTextTheme.mediumTextStyle,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  dateAdded,
                  style:
                      AppTextTheme.decriptionTextStyle.copyWith(fontSize: 12),
                )
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
                  title,
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
                  author!,
                  style: AppTextTheme.decriptionTextStyle.copyWith(
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
        );
    }
  }
}
