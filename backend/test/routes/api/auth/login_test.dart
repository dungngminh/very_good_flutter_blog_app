
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stormberry/stormberry.dart';
import 'package:test/test.dart';
import 'package:very_good_blog_app_backend/common/constants.dart';
import 'package:very_good_blog_app_backend/dtos/response/base_response_data.dart';

import '../../../../routes/api/auth/login/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockDatabase extends Mock implements Database {}

void main() {
  group('POST /api/auth/login', (){
    test('responds with a 200 and returns Created.failed().', () async {
      final context = _MockRequestContext();
      final response = await route.onRequest(context);
      expect(response, equals(CreatedResponse()));
      expect(
        response.json(),
        completion(
          equals(
            {'success': false, 'message': kFailedResponseMessage},
          ),
        ),
      );
    });
  });
}
