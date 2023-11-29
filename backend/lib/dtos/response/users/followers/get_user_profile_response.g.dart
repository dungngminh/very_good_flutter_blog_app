// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserFollowerResponse _$GetUserFollowerResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'GetUserFollowerResponse',
      json,
      ($checkedConvert) {
        final val = GetUserFollowerResponse(
          id: $checkedConvert('id', (v) => v as String),
          fullName: $checkedConvert('full_name', (v) => v as String),
          email: $checkedConvert('email', (v) => v as String),
          avatarUrl: $checkedConvert('avatar_url', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'fullName': 'full_name', 'avatarUrl': 'avatar_url'},
    );

Map<String, dynamic> _$GetUserFollowerResponseToJson(
        GetUserFollowerResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'email': instance.email,
      'avatar_url': instance.avatarUrl,
    };
