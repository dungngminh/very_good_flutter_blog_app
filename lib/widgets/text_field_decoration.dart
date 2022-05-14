import 'package:flutter/material.dart';
import 'package:very_good_blog_app/app/app.dart';

class TextFieldDecoration extends StatelessWidget {
  const TextFieldDecoration({
    Key? key,
    required this.child,
  }) : super(key: key);

  final TextField child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: context.screenWidth,
      decoration: BoxDecoration(
        color: Palette.fieldColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }
}
