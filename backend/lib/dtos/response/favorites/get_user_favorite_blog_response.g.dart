// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_favorite_blog_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserFavoriteBlogResponse _$GetUserFavoriteBlogResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'GetUserFavoriteBlogResponse',
      json,
      ($checkedConvert) {
        final val = GetUserFavoriteBlogResponse(
          id: $checkedConvert('id', (v) => v as String),
          title: $checkedConvert('title', (v) => v as String),
          content: $checkedConvert('content', (v) => v as String),
          imageUrl: $checkedConvert('image_url', (v) => v as String),
          category: $checkedConvert(
              'category', (v) => $enumDecode(_$BlogCategoryEnumMap, v)),
          createdAt:
              $checkedConvert('created_at', (v) => DateTime.parse(v as String)),
          updatedAt:
              $checkedConvert('updated_at', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {
        'imageUrl': 'image_url',
        'createdAt': 'created_at',
        'updatedAt': 'updated_at'
      },
    );

Map<String, dynamic> _$GetUserFavoriteBlogResponseToJson(
        GetUserFavoriteBlogResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'image_url': instance.imageUrl,
      'category': _$BlogCategoryEnumMap[instance.category]!,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$BlogCategoryEnumMap = {
  BlogCategory.business: 'business',
  BlogCategory.technology: 'technology',
  BlogCategory.fashion: 'fashion',
  BlogCategory.travel: 'travel',
  BlogCategory.food: 'food',
  BlogCategory.education: 'education',
};
