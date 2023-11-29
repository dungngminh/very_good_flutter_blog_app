// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_blog_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBlogResponse _$GetBlogResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'GetBlogResponse',
      json,
      ($checkedConvert) {
        final val = GetBlogResponse(
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
          creator: $checkedConvert('creator',
              (v) => UserOfGetBlogResponse.fromJson(v as Map<String, dynamic>)),
          isFavoritedByUser:
              $checkedConvert('is_favorited_by_user', (v) => v as bool?),
        );
        return val;
      },
      fieldKeyMap: const {
        'imageUrl': 'image_url',
        'createdAt': 'created_at',
        'updatedAt': 'updated_at',
        'isFavoritedByUser': 'is_favorited_by_user'
      },
    );

Map<String, dynamic> _$GetBlogResponseToJson(GetBlogResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'image_url': instance.imageUrl,
      'category': _$BlogCategoryEnumMap[instance.category]!,
      'is_favorited_by_user': instance.isFavoritedByUser,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'creator': instance.creator.toJson(),
    };

const _$BlogCategoryEnumMap = {
  BlogCategory.business: 'business',
  BlogCategory.technology: 'technology',
  BlogCategory.fashion: 'fashion',
  BlogCategory.travel: 'travel',
  BlogCategory.food: 'food',
  BlogCategory.education: 'education',
};

UserOfGetBlogResponse _$UserOfGetBlogResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'UserOfGetBlogResponse',
      json,
      ($checkedConvert) {
        final val = UserOfGetBlogResponse(
          id: $checkedConvert('id', (v) => v as String),
          fullName: $checkedConvert('full_name', (v) => v as String),
          email: $checkedConvert('email', (v) => v as String),
          following: $checkedConvert('following', (v) => v as int),
          follower: $checkedConvert('follower', (v) => v as int),
          avatarUrl: $checkedConvert('avatar_url', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'fullName': 'full_name', 'avatarUrl': 'avatar_url'},
    );

Map<String, dynamic> _$UserOfGetBlogResponseToJson(
        UserOfGetBlogResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'email': instance.email,
      'avatar_url': instance.avatarUrl,
      'following': instance.following,
      'follower': instance.follower,
    };
