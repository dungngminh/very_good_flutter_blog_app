// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_blog_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteBlogRequest _$FavoriteBlogRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'FavoriteBlogRequest',
      json,
      ($checkedConvert) {
        final val = FavoriteBlogRequest(
          blogId: $checkedConvert('blog_id', (v) => v as String),
          isFavorite: $checkedConvert('is_favorite', (v) => v as bool),
        );
        return val;
      },
      fieldKeyMap: const {'blogId': 'blog_id', 'isFavorite': 'is_favorite'},
    );

Map<String, dynamic> _$FavoriteBlogRequestToJson(
        FavoriteBlogRequest instance) =>
    <String, dynamic>{
      'blog_id': instance.blogId,
      'is_favorite': instance.isFavorite,
    };
