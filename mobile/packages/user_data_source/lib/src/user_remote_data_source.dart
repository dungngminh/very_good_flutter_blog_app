import 'dart:io';

import 'package:user_data_source/user_data_source.dart';

class UserRemoteDataSource implements UserDataSource {
  UserRemoteDataSource({required HttpClientHandler httpClientHandler})
      : _httpClientHandler = httpClientHandler;

  final HttpClientHandler _httpClientHandler;

  @override
  Future<UserModel?> getUserInformationByUserId(String userId) async {
    try {
      final jsonBody = await _httpClientHandler.get('/users/$userId');
      return UserModel.fromJson(jsonBody as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUserInformation({
    required String userId,
    required String firstname,
    required String lastname,
    required String imagePath,
    required String username,
    required String token,
  }) {
    return _httpClientHandler.put(
      '/users/$userId',
      body: <String, dynamic>{
        'first_name': firstname,
        'last_name': lastname,
        'avatar': imagePath,
        '_id': userId,
        'username': username,
      },
      headers: <String, String>{
        HttpHeaders.authorizationHeader: token,
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
  }
}
