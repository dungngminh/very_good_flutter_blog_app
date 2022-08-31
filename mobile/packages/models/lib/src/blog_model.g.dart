// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogModel _$BlogModelFromJson(Map<String, dynamic> json) => BlogModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      likeCount: json['likes'] as int? ?? 0,
      imageUrl: json['image_url'] as String,
      category: json['category'] as String,
      content: json['content'] as String?,
      createdAt: BlogModel._fromJson(json['created_at'] as int),
      user: UserModel.fromJson(json['author_detail'] as Map<String, dynamic>),
    );
