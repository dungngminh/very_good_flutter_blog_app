// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Blog _$BlogFromJson(Map<String, dynamic> json) => Blog(
      id: json['_id'] as String,
      title: json['title'] as String,
      authorId: json['author_id'] as String,
      likeCount: json['likes'] as int,
      imageUrl: json['image_url'] as String,
      content: json['content'] as String,
      createAt: json['created_at'] as String,
    );

Map<String, dynamic> _$BlogToJson(Blog instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'author_id': instance.authorId,
      'likes': instance.likeCount,
      'image_url': instance.imageUrl,
      'content': instance.content,
      'created_at': instance.createAt,
    };
