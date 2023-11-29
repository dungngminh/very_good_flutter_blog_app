import 'package:stormberry/stormberry.dart';
import 'package:very_good_blog_app_backend/models/user.dart';

part 'following_follower.schema.dart';

@Model()
abstract class FollowingFollower {
  User get following;
  User get follower;
}
