import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
import 'package:very_good_blog_app/app/app.dart';

class GoodBlogClient {
  GoodBlogClient({Client? client}) : _client = client ?? Client();

  late final Client _client;

  static const _baseUrl = 'lequocthinh.com';

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.https(
        _baseUrl,
        '/api/v1$path',
        queryParams,
      );
      log(uri.toString());

      final response = await _client.get(uri, headers: headers).timeout(
            Constant.timeOutDuration,
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
    log(body.toString());
    try {
      final uri = Uri.https(
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
            Constant.timeOutDuration,
            onTimeout: () => throw TimeoutException('Ah shjt timeout'),
          );
      return _returnResponseResult(response);
    } on SocketException {
      throw ConnectionExpcetion('No internet connection');
    } catch (e) {
      log(e.toString());
      throw Exception();
    }
  }

  Future<T> put<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    log(body.toString());
    try {
      final uri = Uri.https(
        _baseUrl,
        '/api/v1$path',
      );
      log(uri.toString());
      final response = await _client
          .put(
            uri,
            body: jsonEncode(body),
            headers: headers,
          )
          .timeout(
            Constant.timeOutDuration,
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
        return jsonDecode(response.body) as T;
      case 403:
        throw UnauthorizedException(
          'authorization fail',
        );
      default:
        throw Exception(
          'Error occured while Communication'
          ' with Server with StatusCode : ${response.statusCode}',
        );
    }
  }
}
