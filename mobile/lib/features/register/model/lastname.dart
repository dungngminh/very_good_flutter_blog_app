import 'package:formz/formz.dart';

enum LastnameValidationError { empty, tooShort }

class Lastname extends FormzInput<String, LastnameValidationError> {
  const Lastname.pure() : super.pure('');
  const Lastname.dirty([super.value = '']) : super.dirty();

  @override
  LastnameValidationError? validator(String? value) {
    if (value?.isNotEmpty == true) {
      return value!.isNotEmpty ? null : LastnameValidationError.tooShort;
    } else {
      return LastnameValidationError.empty;
    }
  }
}
