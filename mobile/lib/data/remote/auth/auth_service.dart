import 'package:chopper/chopper.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_blog_app/data/remote/auth/requests/login_request_body.dart';
import 'package:very_good_blog_app/data/remote/auth/responses/login_response.dart';

part 'auth_service.chopper.dart';

@lazySingleton
@ChopperApi(baseUrl: 'api/auth')
abstract class AuthService extends ChopperService {
  @factoryMethod
  static AuthService create(@Named('unAuthClient') ChopperClient client) {
    return _$AuthService(client);
  }

  @Post(path: 'login')
  Future<LoginResponse> login(@Body() LoginRequestBody body);
}
