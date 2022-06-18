import 'package:flutter/material.dart';
import 'package:very_good_blog_app/app/app.dart' show AppPalette;

class TitleOfTextField extends StatelessWidget {
  const TitleOfTextField(
    this.title, {
    super.key,
    this.padding = EdgeInsets.zero,
  });

  final String title;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppPalette.primaryTextColor,
        ),
      ),
    );
  }
}
