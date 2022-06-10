import 'package:very_good_blog_app/data/remote/good_blog_client.dart';
import 'package:very_good_blog_app/models/models.dart';

class UserRepository {
  UserRepository({GoodBlogClient? blogClient})
      : _blogClient = blogClient ?? GoodBlogClient();

  late final GoodBlogClient _blogClient;

  Future<User?> getUserInformation() async {
    try {
      // final body = await _blogClient.get('/users');
      await Future.delayed(const Duration(seconds: 2), () => user);
    } catch (e) {
      throw Exception('can not get user information');
    }
    return null;
  }
}

const user = User(
  id: '',
  username: 'dungngminh',
  firstName: 'Nguyen',
  lastName: 'Minh Dung',
  followingCount: 10,
  followerCount: 10,
  blogCount: 2,
  
);
