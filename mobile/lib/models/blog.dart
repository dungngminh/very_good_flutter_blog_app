import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'blog.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Blog extends Equatable {
  const Blog({
    required this.id,
    required this.title,
    required this.authorId,
    this.likeCount = 0,
    required this.imageUrl,
    required this.category,
    required this.content,
    required this.createdAt,
  });

  factory Blog.fromJson(Map<String, dynamic> json) => _$BlogFromJson(json);

  @JsonKey(name: '_id')
  final String id;
  final String title;
  final String authorId;
  @JsonKey(name: 'likes')
  final int likeCount;
  final String imageUrl;
  final String category;
  final String content;
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
      authorId,
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
