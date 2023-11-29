import 'package:stormberry/stormberry.dart';
import 'package:very_good_blog_app_backend/models/blog.dart';
import 'package:very_good_blog_app_backend/models/user.dart';

part 'favorite_blogs_users.schema.dart';

@Model()
abstract class FavoriteBlogsUsers {
  Blog get blog;
  User get user;
}
