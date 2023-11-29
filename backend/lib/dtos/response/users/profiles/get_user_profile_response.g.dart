// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserProfileResponse _$GetUserProfileResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'GetUserProfileResponse',
      json,
      ($checkedConvert) {
        final val = GetUserProfileResponse(
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

Map<String, dynamic> _$GetUserProfileResponseToJson(
        GetUserProfileResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'email': instance.email,
      'avatar_url': instance.avatarUrl,
      'following': instance.following,
      'follower': instance.follower,
    };
