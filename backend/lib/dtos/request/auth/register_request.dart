import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {
  RegisterRequest({
    required this.email,
    required this.password,
    required this.fullName,
    required this.confirmationPassword,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  final String fullName;
  final String email;
  final String password;
  final String confirmationPassword;

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
