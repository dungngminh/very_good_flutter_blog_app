import 'package:json_annotation/json_annotation.dart';

part 'register_request_body.g.dart';

@JsonSerializable(createFactory: false)
class RegisterRequestBody {
  RegisterRequestBody({
    required this.email,
    required this.password,
    required this.confirmationPassword,
    required this.fullName,
  });
  final String email;
  final String password;
  final String confirmationPassword;
  final String fullName;

  Map<String, dynamic> toJson() => _$RegisterRequestBodyToJson(this);
}
