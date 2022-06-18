import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_blog_app/app/app.dart';

class ActionBar extends StatelessWidget {
  const ActionBar({
    super.key,
    this.title,
    this.actions,
  });

  final String? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          // alignment: Alignment.centerLeft,
          padding: EdgeInsets.zero,
          icon: Assets.icons.circleArrowLeft.svg(
            color: AppPalette.primaryColor,
            height: 36,
          ),
          splashRadius: 24,
          onPressed: () => context.pop(),
        ),
        if (title != null)
          const Text(
            'title',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppPalette.primaryTextColor,
            ),
          ),
        if (actions != null)
          Row(
            children: actions!,
          )
        else
          const Padding(
            padding: EdgeInsets.all(8),
            child: SizedBox.square(
              dimension: 30,
            ),
          ),
      ],
    );
  }
}
