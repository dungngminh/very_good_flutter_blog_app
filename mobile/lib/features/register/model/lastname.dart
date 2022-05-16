import 'package:formz/formz.dart';

enum LastnameValidationError { empty, tooShort }

class Lastname extends FormzInput<String, LastnameValidationError> {
  const Lastname.pure() : super.pure('');
  const Lastname.dirty([String value = '']) : super.dirty(value);

  @override
  LastnameValidationError? validator(String? value) {
    if (value?.isNotEmpty == true) {
      return value!.length > 3 ? null : LastnameValidationError.tooShort;
    } else {
      return LastnameValidationError.empty;
    }
  }
}
