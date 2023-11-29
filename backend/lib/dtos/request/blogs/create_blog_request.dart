import 'package:json_annotation/json_annotation.dart';
import 'package:very_good_blog_app_backend/models/blog_category.dart';

part 'create_blog_request.g.dart';

@JsonSerializable()
class CreateBlogRequest {
  CreateBlogRequest({
    required this.title,
    required this.content,
    required this.category,
    required this.imageUrl,
  });

  factory CreateBlogRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBlogRequestFromJson(json);

  final String title;
  final String content;
  final BlogCategory category;
  final String imageUrl;

  Map<String, dynamic> toJson() => _$CreateBlogRequestToJson(this);
}
