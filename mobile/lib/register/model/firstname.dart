import 'package:formz/formz.dart';

enum FirstnameValidationError { empty, tooShort }

class Firstname extends FormzInput<String, FirstnameValidationError> {
  const Firstname.pure() : super.pure('');
  const Firstname.dirty([super.value = '']) : super.dirty();

  @override
  FirstnameValidationError? validator(String? value) {
    if (value?.isNotEmpty == true) {
      return value!.isNotEmpty ? null : FirstnameValidationError.tooShort;
    } else {
      return FirstnameValidationError.empty;
    }
  }
}
