// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'RegisterRequest',
      json,
      ($checkedConvert) {
        final val = RegisterRequest(
          email: $checkedConvert('email', (v) => v as String),
          password: $checkedConvert('password', (v) => v as String),
          fullName: $checkedConvert('full_name', (v) => v as String),
          confirmationPassword:
              $checkedConvert('confirmation_password', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'fullName': 'full_name',
        'confirmationPassword': 'confirmation_password'
      },
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'full_name': instance.fullName,
      'email': instance.email,
      'password': instance.password,
      'confirmation_password': instance.confirmationPassword,
    };
