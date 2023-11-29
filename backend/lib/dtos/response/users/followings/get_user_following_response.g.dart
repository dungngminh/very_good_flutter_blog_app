// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_following_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserFollowingResponse _$GetUserFollowingResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'GetUserFollowingResponse',
      json,
      ($checkedConvert) {
        final val = GetUserFollowingResponse(
          id: $checkedConvert('id', (v) => v as String),
          fullName: $checkedConvert('full_name', (v) => v as String),
          email: $checkedConvert('email', (v) => v as String),
          avatarUrl: $checkedConvert('avatar_url', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'fullName': 'full_name', 'avatarUrl': 'avatar_url'},
    );

Map<String, dynamic> _$GetUserFollowingResponseToJson(
        GetUserFollowingResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'email': instance.email,
      'avatar_url': instance.avatarUrl,
    };
