import 'package:formz/formz.dart';

enum PasswordValidationError { empty, tooShort }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String? value) {
    if (value?.isNotEmpty == true) {
      return value!.length >= 8 ? null : PasswordValidationError.tooShort;
    } else {
      return PasswordValidationError.empty;
    }
  }
}
