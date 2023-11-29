import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  LoginRequest({required this.email, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  final String email;
  final String password;

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
