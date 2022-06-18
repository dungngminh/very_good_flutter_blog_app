import 'package:flutter/widgets.dart';
import 'package:very_good_blog_app/app/app.dart' show AppPalette;

class AppTextTheme {
  static const darkW700TextStyle = TextStyle(
    color: AppPalette.primaryDarkTextColor,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static const titleTextStyle = TextStyle(
    color: AppPalette.primaryTextColor,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static const mediumTextStyle = TextStyle(
    color: AppPalette.primaryTextColor,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const regularTextStyle = TextStyle(
    color: AppPalette.primaryTextColor,
  );

  static const reqularDarkTextStyle = TextStyle(
    color: AppPalette.primaryDarkTextColor,
  );

  static const decriptionTextStyle = TextStyle(
    color: AppPalette.descriptionTextColor,
  );

  static const lightTextStyle = TextStyle(
    color: AppPalette.smallTextColor,
  );
}
