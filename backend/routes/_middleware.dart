import 'dart:io';

import 'package:cloudinary/cloudinary.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';
import 'package:very_good_blog_app_backend/models/user.dart';
import 'package:very_good_blog_app_backend/util/jwt_handler.dart';

final db = Database(
  host: Platform.environment['PGHOST'],
  port: int.tryParse(Platform.environment['PGPORT'] ?? '5432'),
  database: Platform.environment['PGDATABASE'],
  user: Platform.environment['PGUSER'],
  password: Platform.environment['PGPASSWORD'],
  useSSL: false,
);

final cloudinary = Cloudinary.signedConfig(
  apiKey: Platform.environment['CLOUDINARY_APIKEY'] ?? '',
  apiSecret: Platform.environment['CLOUDINARY_APISECRET'] ?? '',
  cloudName: Platform.environment['CLOUDINARY_CLOUDNAME'] ?? '',
);

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      // .use(fromShelfMiddleware(enforceSSL()))
      .use(provider<Database>((_) => db))
      .use(provider((_) => JwtHandler(userRepository: db.users)))
      .use(provider((_) => cloudinary));
}
