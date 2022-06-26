import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/data/remote/good_blog_client.dart';
import 'package:very_good_blog_app/models/models.dart';

class BookmarkRepository {
  const BookmarkRepository({
    required GoodBlogClient blogClient,
  }) : _blogClient = blogClient;

  final GoodBlogClient _blogClient;

  Future<List<BlogModel>> getBookmarks() async {
    try {
      final token = await SecureStorageHelper.getValueByKey(AppContants.jwt);

      final jsonBody = await _blogClient.get(
        '/bookmarks',
        headers: <String, String>{
          'Authorization': token!,
        },
      ) as List;
      if (jsonBody.isEmpty) return [];
      return jsonBody
          .map(
            (e) => BlogModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addBookmark({
    required String blogId,
  }) async {}

  Future<void> removeBookmark({
    required String blogId,
  }) async {
    try {} catch (e) {}
  }
}
