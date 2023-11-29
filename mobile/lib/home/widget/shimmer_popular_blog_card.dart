import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:very_good_blog_app/app/app.dart';

class ShimmerPopularBlogCard extends StatelessWidget {
  const ShimmerPopularBlogCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenHeight * 0.35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: CircleAvatar(
                    backgroundColor: AppPalette.whiteBackgroundColor,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppPalette.whiteBackgroundColor,
                ),
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Shimmer.fromColors(
                  baseColor: AppPalette.shimmerBaseColor,
                  highlightColor: AppPalette.shimmerHighlightColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 10,
                                  color: AppPalette.whiteBackgroundColor,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Container(
                                  height: 10,
                                  color: AppPalette.whiteBackgroundColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 16,
                        color: AppPalette.whiteBackgroundColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
