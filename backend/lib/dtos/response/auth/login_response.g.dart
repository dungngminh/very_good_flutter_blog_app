// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'LoginResponse',
      json,
      ($checkedConvert) {
        final val = LoginResponse(
          id: $checkedConvert('id', (v) => v as String),
          token: $checkedConvert('token', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
    };
