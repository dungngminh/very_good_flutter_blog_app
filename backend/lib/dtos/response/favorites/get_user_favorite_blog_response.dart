import 'package:json_annotation/json_annotation.dart';
import 'package:very_good_blog_app_backend/models/blog_category.dart';
import 'package:very_good_blog_app_backend/models/favorite_blogs_users.dart';

part 'get_user_favorite_blog_response.g.dart';

@JsonSerializable()
class GetUserFavoriteBlogResponse {
  GetUserFavoriteBlogResponse({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetUserFavoriteBlogResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserFavoriteBlogResponseFromJson(json);

  factory GetUserFavoriteBlogResponse.fromView(FavoriteBlogsUsersView view) {
    return GetUserFavoriteBlogResponse(
      id: view.blog.id,
      title: view.blog.title,
      content: view.blog.content,
      imageUrl: view.blog.imageUrl,
      category: view.blog.category,
      createdAt: view.blog.createdAt,
      updatedAt: view.blog.updatedAt,
    );
  }

  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final BlogCategory category;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$GetUserFavoriteBlogResponseToJson(this);
}
