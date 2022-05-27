import 'package:flutter/material.dart';
import 'package:very_good_blog_app/app/app.dart';

enum CardType {
  titleAuthorTime,
  titleStatsTime,
  titleStatsAuthor,
}

// TODO(dungngminh): implement dynamic BlogCard
class BlogCard extends StatelessWidget {
  const BlogCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.likeCount,
    this.author,
    required this.dateAdded,
    this.cardType = CardType.titleAuthorTime,
  });

  final String title;
  final String imageUrl;
  final int? likeCount;
  final String? author;
  final String dateAdded;

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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Palette.fieldColor,
      ),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 1.1,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          _buildCardContent(cardType),
          if (cardType == CardType.titleAuthorTime)
            IconButton(
              icon: Assets.icons.bookmark.svg(color: Palette.deepPurpleColor),
              onPressed: () {},
            )
          else
            const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildCardContent(CardType cardType) {
    switch (cardType) {
      case CardType.titleAuthorTime:
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
                    color: Palette.primaryTextColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  author!,
                  style: const TextStyle(
                    color: Palette.descriptionTextColor,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  dateAdded,
                  style: const TextStyle(
                    color: Palette.descriptionTextColor,
                    fontSize: 12,
                  ),
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
                  style: const TextStyle(
                    color: Palette.primaryTextColor,
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
                      height: 22,
                      color: Palette.pink500Color,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Text(
                      '300',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Palette.primaryTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  dateAdded,
                  style: const TextStyle(
                    color: Palette.descriptionTextColor,
                    fontSize: 12,
                  ),
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
                    color: Palette.primaryTextColor,
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
                      height: 22,
                      color: Palette.pink500Color,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Text(
                      '300',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Palette.primaryTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  dateAdded,
                  style: const TextStyle(
                    color: Palette.descriptionTextColor,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
        );
    }
  }
}
