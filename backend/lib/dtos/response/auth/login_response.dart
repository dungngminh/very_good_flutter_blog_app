import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  LoginResponse({required this.id, required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  final String id;
  final String token;

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
