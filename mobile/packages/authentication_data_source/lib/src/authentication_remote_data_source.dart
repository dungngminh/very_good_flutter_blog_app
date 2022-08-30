import 'dart:developer';
import 'dart:io';

import 'package:authentication_data_source/authentication_data_source.dart';
import 'package:http_client_handler/http_client_handler.dart';

class AuthenticationRemoteDataSource implements AuthenticationDataSource {
  AuthenticationRemoteDataSource({required HttpClientHandler httpClientHandler})
      : _httpClientHandler = httpClientHandler;

  final HttpClientHandler _httpClientHandler;

  @override
  Future<dynamic> login({
    required String username,
    required String password,
  }) {
    log('user', name: '$runtimeType');
    return _httpClientHandler.post(
      '/auth/login',
      body: <String, dynamic>{
        'username': username,
        'password': password,
      },
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json'
      },
    );
  }

  @override
  Future<void> register({
    required String lastname,
    required String firstname,
    required String username,
    required String password,
    required String confirmationPassword,
  }) {
    return _httpClientHandler.post(
      '/auth/register',
      body: <String, dynamic>{
        'username': username,
        'first_name': firstname,
        'last_name': lastname,
        'password': password,
        'confirmation_password': confirmationPassword,
      },
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json'
      },
    );
  }
}
