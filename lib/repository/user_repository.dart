import 'package:very_good_blog_app/models/models.dart';

class UserRepository {
  Future<User?> getUser() async {
    return Future.delayed(
      const Duration(seconds: 2),
      () => const User.new(name: 'dungngminh'),
    );
  }
}
