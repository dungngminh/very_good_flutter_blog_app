// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_user_profile_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditUserProfileRequest _$EditUserProfileRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'EditUserProfileRequest',
      json,
      ($checkedConvert) {
        final val = EditUserProfileRequest(
          $checkedConvert('full_name', (v) => v as String?),
          $checkedConvert('avatar_url', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'fullName': 'full_name', 'avatarUrl': 'avatar_url'},
    );

Map<String, dynamic> _$EditUserProfileRequestToJson(
        EditUserProfileRequest instance) =>
    <String, dynamic>{
      'full_name': instance.fullName,
      'avatar_url': instance.avatarUrl,
    };
