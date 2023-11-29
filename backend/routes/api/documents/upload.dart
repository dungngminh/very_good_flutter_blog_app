import 'package:dart_frog/dart_frog.dart';
import 'package:very_good_blog_app_backend/dtos/response/base_response_data.dart';

/// @Allow(POST)
/// HAPPY BIRTHDAY @dungngminh
Future<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.post => _onUploadPostRequest(context),
    _ => Future.value(MethodNotAllowedResponse())
  };
}

Future<Response> _onUploadPostRequest(RequestContext context) async {
  final request = await context.request.formData();
  try {
    final folderName = request.fields['folderName'];
    final uploadedFile = request.files['file'];
    return OkResponse(uploadedFile?.name);
  } catch (e) {
    return BadRequestResponse();
  }
}
