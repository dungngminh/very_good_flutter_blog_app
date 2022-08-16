import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
import 'package:very_good_blog_app/app/app.dart';

class GoodBlogClient {
  GoodBlogClient({required Client client}) : _client = client;

  final Client _client;

  static const _baseUrl = '10.0.2.2:8080';

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.http(
        _baseUrl,
        '/api/v1$path',
        queryParams,
      );

      final response = await _client.get(uri, headers: headers).timeout(
            AppContants.timeOutDuration,
            onTimeout: () => throw TimeoutException('Ah shjt timeout'),
          );
      return _returnResponseResult(response);
    } on SocketException {
      throw ConnectionExpcetion('No internet connection');
    }
  }

  Future<T> delete<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.http(
        _baseUrl,
        '/api/v1$path',
      );

      final response = await _client
          .delete(uri, headers: headers, body: jsonEncode(body))
          .timeout(
            AppContants.timeOutDuration,
            onTimeout: () => throw TimeoutException('Ah shjt timeout'),
          );
      return _returnResponseResult(response);
    } on SocketException {
      throw ConnectionExpcetion('No internet connection');
    }
  }

  Future<T> post<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.http(
        _baseUrl,
        '/api/v1$path',
      );
      final response = await _client
          .post(
            uri,
            body: jsonEncode(body),
            headers: headers,
          )
          .timeout(
            AppContants.timeOutDuration,
            onTimeout: () => throw TimeoutException('Ah shjt timeout'),
          );
      return _returnResponseResult(response);
    } on SocketException {
      throw ConnectionExpcetion('No internet connection');
    } catch (e) {
      throw Exception();
    }
  }

  Future<T> put<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.http(
        _baseUrl,
        '/api/v1$path',
      );
      final response = await _client
          .put(
            uri,
            body: jsonEncode(body),
            headers: headers,
          )
          .timeout(
            AppContants.timeOutDuration,
            onTimeout: () => throw TimeoutException('Ah shjt timeout'),
          );
      return _returnResponseResult(response);
    } on SocketException {
      throw ConnectionExpcetion('No internet connection');
    }
  }

  T _returnResponseResult<T>(Response response) {
    log('${response.body}${response.statusCode}');
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(utf8.decode(response.bodyBytes)) as T;
      case 403:
        throw UnauthorizedException(
          'Authorization fail',
        );
      default:
        throw Exception(
          'Error occured while Communication'
          ' with Server with StatusCode : ${response.statusCode}',
        );
    }
  }
}
