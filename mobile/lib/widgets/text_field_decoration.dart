import 'package:flutter/material.dart';
import 'package:very_good_blog_app/app/app.dart';

class TextFieldDecoration extends StatelessWidget {
  const TextFieldDecoration({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.only(top: 10),
    this.padding,
    this.fieldColor = AppPalette.fieldColor,
  });

  final Widget child;
  final EdgeInsets margin;
  final EdgeInsets? padding;
  final Color fieldColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      width: context.screenWidth,
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }
}
