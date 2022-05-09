import 'package:formz/formz.dart';

enum ConfirmedPasswordValidationError { empty, notMatch }

class ConfirmedPassword
    extends FormzInput<String, ConfirmedPasswordValidationError> {
  const ConfirmedPassword.pure({this.password = ''}) : super.pure('');
  const ConfirmedPassword.dirty({
    required this.password,
    String value = '',
  }) : super.dirty(value);

  final String password;
  @override
  ConfirmedPasswordValidationError? validator(String? value) {
    if (value?.isEmpty == true) {
      return ConfirmedPasswordValidationError.empty;
    }
    return password == value ? null : ConfirmedPasswordValidationError.notMatch;
  }
}
