// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['_id'] as String,
      username: json['username'] as String,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      followingCount: json['following_count'] as int? ?? 0,
      followerCount: json['follower_count'] as int? ?? 0,
      blogCount: json['num_blog'] as int? ?? 0,
      avatarUrl: json['avatar'] as String? ?? '',
      blogs: (json['blogs'] as List<dynamic>?)
          ?.map((e) => BlogModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'following_count': instance.followingCount,
      'follower_count': instance.followerCount,
      'num_blog': instance.blogCount,
      'avatar': instance.avatarUrl,
      'blogs': instance.blogs,
    };
