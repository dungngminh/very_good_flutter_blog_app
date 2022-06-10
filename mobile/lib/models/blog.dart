import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'blog.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Blog extends Equatable {
  const Blog({
    required this.id,
    required this.title,
    required this.authorId,
    required this.likeCount,
    required this.imageUrl,
    required this.content,
    required this.createAt,
  });
  factory Blog.fromJson(Map<String, dynamic> json) => _$BlogFromJson(json);

  @JsonKey(name:'_id')
  final String id;
  final String title;
  final String authorId;
  @JsonKey(name: 'likes')
  final int likeCount;
  final String imageUrl;
  final String content;
  final String createAt;

  Map<String, dynamic> toJson() => _$BlogToJson(this);

  @override
  List<Object?> get props {
    return [
      id,
      title,
      authorId,
      likeCount,
      imageUrl,
      content,
      createAt,
    ];
  }

  @override
  bool get stringify => true;
}
