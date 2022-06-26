import 'package:formz/formz.dart';

enum BlogTitleValidationError { empty, maxLength }

class BlogTitle extends FormzInput<String, BlogTitleValidationError> {
  const BlogTitle.pure() : super.pure('');
  const BlogTitle.dirty([super.value = '']) : super.dirty();

  @override
  BlogTitleValidationError? validator(String? value) {
    if (value?.isNotEmpty == true) {
      return value!.length >= 200 ? BlogTitleValidationError.maxLength : null;
    } else {
      return BlogTitleValidationError.empty;
    }
  }
}
