import 'package:dart_frog/dart_frog.dart';
import 'package:very_good_blog_app_backend/middleware/middleware.dart';

Handler middleware(Handler handler) {
  return handler.use(authenticationValidator(expectMethods: [HttpMethod.get]));
}
