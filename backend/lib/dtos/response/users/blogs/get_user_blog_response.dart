import 'package:json_annotation/json_annotation.dart';
import 'package:very_good_blog_app_backend/models/blog.dart';
import 'package:very_good_blog_app_backend/models/blog_category.dart';

part 'get_user_blog_response.g.dart';

@JsonSerializable()
class GetUserBlogResponse {
  GetUserBlogResponse({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetUserBlogResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserBlogResponseFromJson(json);

  factory GetUserBlogResponse.fromView(BlogView view) {
    return GetUserBlogResponse(
      id: view.id,
      title: view.title,
      content: view.content,
      imageUrl: view.imageUrl,
      category: view.category,
      createdAt: view.createdAt,
      updatedAt: view.updatedAt,
    );
  }

  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final BlogCategory category;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$GetUserBlogResponseToJson(this);
}
