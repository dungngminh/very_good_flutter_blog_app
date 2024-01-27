import 'package:formz/formz.dart';

enum ImagePathValidationError { empty }

class ImagePath extends FormzInput<String, ImagePathValidationError> {
  const ImagePath.isPure() : super.pure('');
  const ImagePath.dirty([super.value = '']) : super.dirty();

  @override
  ImagePathValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : ImagePathValidationError.empty;
  }
}
