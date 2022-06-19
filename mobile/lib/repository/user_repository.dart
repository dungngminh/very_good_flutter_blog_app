import 'package:very_good_blog_app/data/remote/good_blog_client.dart';
import 'package:very_good_blog_app/models/models.dart';

class UserRepository {
  UserRepository({GoodBlogClient? blogClient})
      : _blogClient = blogClient ?? GoodBlogClient();

  late final GoodBlogClient _blogClient;

  Future<User?> getUserInformationByUserId(String userId) async {
    try {
      final jsonBody = await _blogClient.get('/users/$userId');
      return User.fromJson(jsonBody as Map<String, dynamic>);
    } catch (e) {
      throw Exception('can not get user information');
    }
  }
}
