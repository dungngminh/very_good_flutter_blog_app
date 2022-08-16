import 'package:formz/formz.dart';

enum ConfirmedPasswordValidationError { notMatch }

class ConfirmedPassword
    extends FormzInput<String, ConfirmedPasswordValidationError> {
  const ConfirmedPassword.pure({this.password = ''}) : super.pure('');
  const ConfirmedPassword.dirty({
    this.password = '',
    String value = '',
  }) : super.dirty(value);

  final String password;
  
  @override
  ConfirmedPasswordValidationError? validator(String? value) {
    return password == value ? null : ConfirmedPasswordValidationError.notMatch;
  }
}
