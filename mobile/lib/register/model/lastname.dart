import 'package:formz/formz.dart';

enum LastnameValidationError {
  empty,
}

class Lastname extends FormzInput<String, LastnameValidationError> {
  const Lastname.isPure() : super.pure('');
  const Lastname.dirty([super.value = '']) : super.dirty();

  @override
  LastnameValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : LastnameValidationError.empty;
  }
}
