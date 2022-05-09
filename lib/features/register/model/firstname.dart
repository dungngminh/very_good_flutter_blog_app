import 'package:formz/formz.dart';

enum FirstnameValidationError { empty, tooShort }

class Firstname extends FormzInput<String, FirstnameValidationError> {
  const Firstname.pure() : super.pure('');
  const Firstname.dirty([String value = '']) : super.dirty(value);

  @override
  FirstnameValidationError? validator(String? value) {
    if (value?.isNotEmpty == true) {
      return value!.length > 3 ? null : FirstnameValidationError.tooShort;
    } else {
      return FirstnameValidationError.empty;
    }
  }
}
