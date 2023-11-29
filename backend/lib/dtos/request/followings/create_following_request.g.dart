// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_following_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateFollowingRequest _$CreateFollowingRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CreateFollowingRequest',
      json,
      ($checkedConvert) {
        final val = CreateFollowingRequest(
          userId: $checkedConvert('user_id', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'userId': 'user_id'},
    );

Map<String, dynamic> _$CreateFollowingRequestToJson(
        CreateFollowingRequest instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
    };
