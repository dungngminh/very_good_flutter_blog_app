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
              .toList() ??
          const <BlogModel>[],
    );


