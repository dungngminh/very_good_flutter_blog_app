import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

String createJwt(
  dynamic payload, {
  Duration expiresIn = const Duration(days: 1),
}) {
  final jwt = JWT(payload);
  return jwt.sign(SecretKey('secret passphrase'), expiresIn: expiresIn);
}
