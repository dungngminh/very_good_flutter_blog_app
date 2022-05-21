import 'package:flutter/material.dart';
import 'package:very_good_blog_app/app/app.dart';

class OwnBlogCard extends StatelessWidget {
  const OwnBlogCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.likeCount,
    required this.dateAdded,
  });

  final String title;
  final String imageUrl;
  final int likeCount;
  final String dateAdded;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
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
          Expanded(
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
                        color: Palette.primaryTextColor,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      const Text(
                        '300',
                        style: TextStyle(
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
          )
        ],
      ),
    );
  }
}
