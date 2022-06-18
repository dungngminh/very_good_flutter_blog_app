import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:very_good_blog_app/models/models.dart' show User;

part 'blog.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Blog extends Equatable {
  const Blog({
    required this.id,
    required this.title,
    this.likeCount = 0,
    required this.imageUrl,
    required this.category,
    required this.content,
    required this.createdAt,
    required this.user,
  });

  const Blog.preview({
    this.id = 'preview',
    required this.title,
    this.likeCount = 0,
    required this.imageUrl,
    required this.category,
    this.content,
    required this.user,
    required this.createdAt,
  });

  factory Blog.fromJson(Map<String, dynamic> json) => _$BlogFromJson(json);

  @JsonKey(name: '_id')
  final String id;
  final String title;
  @JsonKey(name: 'likes')
  final int likeCount;
  final String imageUrl;
  final String category;
  final String? content;
  @JsonKey(name: 'author_detail')
  final User user;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  final DateTime createdAt;

  Map<String, dynamic> toJson() => _$BlogToJson(this);

  static DateTime _fromJson(int int) =>
      DateTime.fromMillisecondsSinceEpoch(int);
  static int _toJson(DateTime time) => time.millisecondsSinceEpoch;

  @override
  List<Object?> get props {
    return [
      id,
      title,
      likeCount,
      imageUrl,
      content,
      category,
      createdAt,
    ];
  }

  @override
  bool get stringify => true;
}
