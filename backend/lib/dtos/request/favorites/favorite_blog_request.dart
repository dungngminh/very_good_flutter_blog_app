import 'package:json_annotation/json_annotation.dart';

part 'favorite_blog_request.g.dart';

@JsonSerializable()
class FavoriteBlogRequest {
  FavoriteBlogRequest({required this.blogId, required this.isFavorite});

  factory FavoriteBlogRequest.fromJson(Map<String, dynamic> json) =>
      _$FavoriteBlogRequestFromJson(json);

  final String blogId;
  final bool isFavorite;

  Map<String, dynamic> toJson() => _$FavoriteBlogRequestToJson(this);
}
