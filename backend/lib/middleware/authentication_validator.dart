import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:stormberry/stormberry.dart';
import 'package:very_good_blog_app_backend/models/user.dart';

Middleware authenticationValidator({
  List<HttpMethod> expectMethods = const [],
}) =>
    bearerAuthentication<UserView>(
      authenticator: (context, token) {
        final db = context.read<Database>();
        final jwt = JWT.verify(token, SecretKey('secret passphrase'));
        final payload = jwt.payload as String;
        return db.users.queryUser(payload);
      },
      applies: (context) =>
          Future.value(!expectMethods.contains(context.request.method)),
    );
