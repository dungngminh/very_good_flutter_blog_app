import 'package:json_annotation/json_annotation.dart';
import 'package:very_good_blog_app_backend/models/blog_category.dart';

part 'edit_blog_request.g.dart';

@JsonSerializable()
class EditBlogRequest {
  EditBlogRequest(
    this.title,
    this.content,
    this.imageUrl,
    this.category,
  );

  factory EditBlogRequest.fromJson(Map<String, dynamic> json) =>
      _$EditBlogRequestFromJson(json);

  final String? title;
  final String? content;
  final String? imageUrl;
  final BlogCategory? category;

  Map<String, dynamic> toJson() => _$EditBlogRequestToJson(this);
}
