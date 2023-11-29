import 'dart:convert';

import 'package:crypto/crypto.dart';

extension HashExtension on String {
  String get hashValue {
    return sha256.convert(utf8.encode(this)).toString();
  }
}
