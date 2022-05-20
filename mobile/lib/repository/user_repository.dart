import 'package:very_good_blog_app/models/models.dart';

class UserRepository {
  Future<User?> getUser() async {
    return Future.delayed(
      const Duration(milliseconds: 300),
      () => const User(name: 'dungngminh'),
    );
  }
}
