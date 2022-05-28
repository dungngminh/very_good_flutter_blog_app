import 'package:flutter/widgets.dart';
import 'package:very_good_blog_app/app/app.dart' show Palette;

class AppTextTheme {
  static const darkW700TextStyle = TextStyle(
    color: Palette.primaryDarkTextColor,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static const titleTextStyle = TextStyle(
    color: Palette.primaryTextColor,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static const mediumTextStyle = TextStyle(
    color: Palette.primaryTextColor,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const regularTextStyle = TextStyle(
    color: Palette.primaryTextColor,
  );

  static const decriptionTextStyle = TextStyle(
    color: Palette.descriptionTextColor,
  );

  static const lightTextStyle = TextStyle(
    color: Palette.smallTextColor,
  );
}
