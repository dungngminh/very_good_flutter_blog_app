// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_blog_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateBlogRequest _$CreateBlogRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'CreateBlogRequest',
      json,
      ($checkedConvert) {
        final val = CreateBlogRequest(
          title: $checkedConvert('title', (v) => v as String),
          content: $checkedConvert('content', (v) => v as String),
          category: $checkedConvert(
              'category', (v) => $enumDecode(_$BlogCategoryEnumMap, v)),
          imageUrl: $checkedConvert('image_url', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'imageUrl': 'image_url'},
    );

Map<String, dynamic> _$CreateBlogRequestToJson(CreateBlogRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'category': _$BlogCategoryEnumMap[instance.category]!,
      'image_url': instance.imageUrl,
    };

const _$BlogCategoryEnumMap = {
  BlogCategory.business: 'business',
  BlogCategory.technology: 'technology',
  BlogCategory.fashion: 'fashion',
  BlogCategory.travel: 'travel',
  BlogCategory.food: 'food',
  BlogCategory.education: 'education',
};
