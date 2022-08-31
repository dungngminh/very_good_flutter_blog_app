import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:very_good_blog_app/app/app.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.title,
    required this.iconPath,
    required this.primaryColor,
    required this.supportBackgroundColor,
    required this.onTap,
  });

  final String title;
  final String iconPath;
  final Color primaryColor;
  final Color supportBackgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: supportBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                iconPath,
                color: primaryColor,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppPalette.primaryTextColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
