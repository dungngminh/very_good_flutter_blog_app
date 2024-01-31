import 'package:injectable/injectable.dart';
import 'package:very_good_blog_app/data/datasources/local/user_secure_storage.dart';
import 'package:very_good_blog_app/data/datasources/remote/auth/auth_service.dart';
import 'package:very_good_blog_app/data/datasources/remote/auth/requests/login_request_body.dart';
import 'package:very_good_blog_app/data/datasources/remote/auth/requests/register_request_body.dart';
import 'package:very_good_blog_app/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthService authService,
    required UserSecureStorage secureStorage,
  })  : _authService = authService,
        _secureStorage = secureStorage;

  final AuthService _authService;
  final UserSecureStorage _secureStorage;

  @override
  Future<void> login({required String email, required String password}) {
    return _authService
        .login(LoginRequestBody(email: email, password: password))
        .then<void>((response) {
      _secureStorage
        ..setAccessToken(response.token)
        ..setUserId(response.id);
    });
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    required String confirmationPassword,
    required String fullName,
  }) {
    return _authService.register(
      RegisterRequestBody(
        email: email,
        password: password,
        confirmationPassword: confirmationPassword,
        fullName: fullName,
      ),
    );
  }

  @override
  Future<void> signOut() {
    return _secureStorage.removeAllKeys();
  }
}
