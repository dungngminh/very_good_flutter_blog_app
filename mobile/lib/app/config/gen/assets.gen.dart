/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/Nunito-Black.ttf
  String get nunitoBlack => 'assets/fonts/Nunito-Black.ttf';

  /// File path: assets/fonts/Nunito-Bold.ttf
  String get nunitoBold => 'assets/fonts/Nunito-Bold.ttf';

  /// File path: assets/fonts/Nunito-ExtraBold.ttf
  String get nunitoExtraBold => 'assets/fonts/Nunito-ExtraBold.ttf';

  /// File path: assets/fonts/Nunito-ExtraLight.ttf
  String get nunitoExtraLight => 'assets/fonts/Nunito-ExtraLight.ttf';

  /// File path: assets/fonts/Nunito-Italic.ttf
  String get nunitoItalic => 'assets/fonts/Nunito-Italic.ttf';

  /// File path: assets/fonts/Nunito-Light.ttf
  String get nunitoLight => 'assets/fonts/Nunito-Light.ttf';

  /// File path: assets/fonts/Nunito-Medium.ttf
  String get nunitoMedium => 'assets/fonts/Nunito-Medium.ttf';

  /// File path: assets/fonts/Nunito-Regular.ttf
  String get nunitoRegular => 'assets/fonts/Nunito-Regular.ttf';

  /// File path: assets/fonts/Nunito-SemiBold.ttf
  String get nunitoSemiBold => 'assets/fonts/Nunito-SemiBold.ttf';
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/add_user.svg
  SvgGenImage get addUser => const SvgGenImage('assets/icons/add_user.svg');

  /// File path: assets/icons/arrow_down.svg
  SvgGenImage get arrowDown => const SvgGenImage('assets/icons/arrow_down.svg');

  /// File path: assets/icons/bell.svg
  SvgGenImage get bell => const SvgGenImage('assets/icons/bell.svg');

  /// File path: assets/icons/bookmark.svg
  SvgGenImage get bookmark => const SvgGenImage('assets/icons/bookmark.svg');

  /// File path: assets/icons/camera.svg
  SvgGenImage get camera => const SvgGenImage('assets/icons/camera.svg');

  /// File path: assets/icons/circle_arrow_left.svg
  SvgGenImage get circleArrowLeft =>
      const SvgGenImage('assets/icons/circle_arrow_left.svg');

  /// File path: assets/icons/close_square.svg
  SvgGenImage get closeSquare =>
      const SvgGenImage('assets/icons/close_square.svg');

  /// File path: assets/icons/edit.svg
  SvgGenImage get edit => const SvgGenImage('assets/icons/edit.svg');

  /// File path: assets/icons/edit_square.svg
  SvgGenImage get editSquare =>
      const SvgGenImage('assets/icons/edit_square.svg');

  /// File path: assets/icons/filter.svg
  SvgGenImage get filter => const SvgGenImage('assets/icons/filter.svg');

  /// File path: assets/icons/heart.svg
  SvgGenImage get heart => const SvgGenImage('assets/icons/heart.svg');

  /// File path: assets/icons/hide.svg
  SvgGenImage get hide => const SvgGenImage('assets/icons/hide.svg');

  /// File path: assets/icons/home.svg
  SvgGenImage get home => const SvgGenImage('assets/icons/home.svg');

  /// File path: assets/icons/info.svg
  SvgGenImage get info => const SvgGenImage('assets/icons/info.svg');

  /// File path: assets/icons/log_out.svg
  SvgGenImage get logOut => const SvgGenImage('assets/icons/log_out.svg');

  /// File path: assets/icons/plus.svg
  SvgGenImage get plus => const SvgGenImage('assets/icons/plus.svg');

  /// File path: assets/icons/plus_border.svg
  SvgGenImage get plusBorder =>
      const SvgGenImage('assets/icons/plus_border.svg');

  /// File path: assets/icons/profile.svg
  SvgGenImage get profile => const SvgGenImage('assets/icons/profile.svg');

  /// File path: assets/icons/refresh.svg
  SvgGenImage get refresh => const SvgGenImage('assets/icons/refresh.svg');

  /// File path: assets/icons/search.svg
  SvgGenImage get search => const SvgGenImage('assets/icons/search.svg');

  /// File path: assets/icons/setting.svg
  SvgGenImage get setting => const SvgGenImage('assets/icons/setting.svg');

  /// File path: assets/icons/show.svg
  SvgGenImage get show => const SvgGenImage('assets/icons/show.svg');

  /// File path: assets/icons/user.svg
  SvgGenImage get user => const SvgGenImage('assets/icons/user.svg');
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/blank_avatar.png
  AssetGenImage get blankAvatar =>
      const AssetGenImage('assets/images/blank_avatar.png');

  /// File path: assets/images/komkat.png
  AssetGenImage get komkat => const AssetGenImage('assets/images/komkat.png');

  /// File path: assets/images/very_good.svg
  SvgGenImage get veryGood => const SvgGenImage('assets/images/very_good.svg');
}

class Assets {
  Assets._();

  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    Color? color,
    BlendMode colorBlendMode = BlendMode.srcIn,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    Clip clipBehavior = Clip.hardEdge,
    bool cacheColorFilter = false,
    SvgTheme? theme,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
      theme: theme,
    );
  }

  String get path => _assetName;
}
