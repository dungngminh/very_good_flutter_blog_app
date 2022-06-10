import 'dart:io';

import 'package:http/http.dart';

class GoodBlogClient {
  GoodBlogClient({Client? client}) : _client = client ?? Client();

  late final Client _client;

  static const _baseUrl =
      'be4c-2001-ee0-4b49-e890-14a8-5d35-dbf4-5148.ap.ngrok.io';

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
      final response = await _client.get(uri, headers: headers);
      return _returnResponseResult(response);
    } on SocketException {
      throw Exception('socket fail');
    }
  }

  Future<T> post<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.https(_baseUrl, path);
      final response = await _client.post(
        uri,
        body: body,
        headers: headers,
      );
      return _returnResponseResult(response);
    } on SocketException {
      throw Exception('socket fail');
    }
  }

  T _returnResponseResult<T>(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response.body as T;
      default:
        throw Exception(
          'Error occured while Communication'
          ' with Server with StatusCode : ${response.statusCode}',
        );
    }
  }
}
