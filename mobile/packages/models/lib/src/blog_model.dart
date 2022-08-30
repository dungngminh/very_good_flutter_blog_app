import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'blog_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class BlogModel extends Equatable {
  const BlogModel({
     required this.id,
    required this.title,
    this.likeCount = 0,
    required this.imageUrl,
    required this.category,
    this.content,
    required this.createdAt,
    required this.user,
  });

  const BlogModel.preview({
    this.id = 'preview',
    required this.title,
    this.likeCount = 0,
    required this.imageUrl,
    required this.category,
    this.content,
    required this.user,
    required this.createdAt,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) =>
      _$BlogModelFromJson(json);

  @JsonKey(name: '_id')
  final String id;
  final String title;
  @JsonKey(name: 'likes')
  final int likeCount;
  final String imageUrl;
  final String category;
  final String? content;
  @JsonKey(name: 'author_detail')
  final UserModel user;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  final DateTime createdAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'content': content,
        'image_url': imageUrl,
        'title': title,
        'category': [category],
      };

  static DateTime _fromJson(int timestamp) =>
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
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

  BlogModel copyWith({
    String? id,
    String? title,
    int? likeCount,
    String? imageUrl,
    String? category,
    String? content,
    UserModel? user,
    DateTime? createdAt,
  }) {
    return BlogModel(
      id: id ?? this.id,
      title: title ?? this.title,
      likeCount: likeCount ?? this.likeCount,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      content: content ?? this.content,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'BlogModel($id, $title)';
  }
}
