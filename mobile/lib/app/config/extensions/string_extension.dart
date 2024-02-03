import 'package:dartx/dartx.dart';

extension StringExtension on String? {
  bool isEmail() {
    if (isNullOrEmpty || isNullOrBlank) {
      return false;
    }
    final emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );
    return emailRegex.hasMatch(this!);
  }
}
