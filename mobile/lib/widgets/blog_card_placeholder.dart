import 'package:flutter/material.dart';
import 'package:very_good_blog_app/app/app.dart';

class BlogCardPlaceholder extends StatelessWidget {
  const BlogCardPlaceholder({
    super.key,
    this.needMargin = false,
  });

  final bool needMargin;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 135,
      margin: needMargin ? const EdgeInsets.symmetric(horizontal: 24) : null,
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: const AspectRatio(
                aspectRatio: 1,
                child: ColoredBox(
                  color: AppPalette.whiteBackgroundColor,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    color: AppPalette.whiteBackgroundColor,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 12,
                    color: AppPalette.whiteBackgroundColor,
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Container(
                    height: 12,
                    color: AppPalette.whiteBackgroundColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
