import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:very_good_blog_app_backend/models/user.dart';

class JwtHandler {
  JwtHandler({required UserRepository userRepository})
      : _userRepository = userRepository;

  final UserRepository _userRepository;

  Future<UserView?> userFromToken(String token) async {
    try {
      final jwt = JWT.verify(token, SecretKey('secret passphrase'));
      final payload = jwt.payload as String;
      return _userRepository.queryUser(payload);
    } catch (e) {
      return null;
    }
  }
}
