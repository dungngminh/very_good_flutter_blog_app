import 'package:authentication_data_source/authentication_data_source.dart';

class MockAuthenticationDataSource implements AuthenticationDataSource {
  @override
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> register({
    required String lastname,
    required String firstname,
    required String username,
    required String password,
    required String confirmationPassword,
  }) {
    throw UnimplementedError();
  }
}
