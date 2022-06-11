// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Blog _$BlogFromJson(Map<String, dynamic> json) => Blog(
      id: json['_id'] as String,
      title: json['title'] as String,
      authorId: json['author_id'] as String,
      likeCount: json['likes'] as int? ?? 0,
      imageUrl: json['image_url'] as String,
      category: json['category'] as String,
      content: json['content'] as String,
      createdAt: Blog._fromJson(json['created_at'] as int),
    );

Map<String, dynamic> _$BlogToJson(Blog instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'author_id': instance.authorId,
      'likes': instance.likeCount,
      'image_url': instance.imageUrl,
      'category': instance.category,
      'content': instance.content,
      'created_at': Blog._toJson(instance.createdAt),
    };
