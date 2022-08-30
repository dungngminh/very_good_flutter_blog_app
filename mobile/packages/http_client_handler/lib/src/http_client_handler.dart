// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_client_handler/http_client_handler.dart';

/// {@template http_client_handler}
/// A http client handler for base api client
/// {@endtemplate}
class HttpClientHandler {
  /// {@macro http_client_handler}
  HttpClientHandler({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? 'http://10.0.2.2:8080';

  final http.Client _client;

  final String _baseUrl;

  Future get(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameter,
  }) async {
    try {
      final uri = _getUri(
        baseUrl: _baseUrl,
        path: path,
        queryParameter: queryParameter,
      );
      return _client
          .get(
            uri,
            headers: headers,
          )
          .then(_handleResponse);
    } on SocketException {
      rethrow;
    }
  }

  Future post(
    String path, {
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameter,
  }) async {
    try {
      final uri = _getUri(
        baseUrl: _baseUrl,
        path: path,
        queryParameter: queryParameter,
      );
      return _client
          .post(uri, headers: headers, body: jsonEncode(body))
          .then(_handleResponse);
    } on SocketException {
      rethrow;
    }
  }

  Future put(
    String path, {
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameter,
  }) async {
    try {
      final uri = _getUri(
        baseUrl: _baseUrl,
        path: path,
        queryParameter: queryParameter,
      );
      return _client
          .put(uri, headers: headers, body: body)
          .then(_handleResponse);
    } on SocketException {
      rethrow;
    }
  }

  Future delete(
    String path, {
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameter,
  }) async {
    try {
      final uri = _getUri(
        baseUrl: _baseUrl,
        path: path,
        queryParameter: queryParameter,
      );
      return _client
          .delete(uri, headers: headers, body: body)
          .then(_handleResponse);
    } catch (e) {
      rethrow;
    }
  }

  dynamic _handleResponse(http.Response response) {
    log(response.body);
    final statusCode = response.statusCode;
    if (HttpStatus.ok <= statusCode &&
        statusCode <= HttpStatus.multipleChoices) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    switch (statusCode) {
      case 400:
        throw BadRequestException();
      case 401:
        throw UnauthorizedException();
      case 404:
        throw NotFoundException();
      case 500:
        throw ServerErrorException();
      default:
        throw Exception(
          'Error occured while Communication'
          ' with Server with StatusCode : ${response.statusCode}',
        );
    }
  }

  Uri _getUri({
    required String baseUrl,
    required String path,
    Map<String, dynamic>? queryParameter,
  }) {
    final splited = baseUrl.split('://');
    final schema = splited.first;
    final hostPort = splited[1].split(':');
    final host = hostPort.first;
    final port = hostPort[1].isEmpty ? null : int.parse(hostPort[1]);
    return Uri(
      scheme: schema,
      host: host,
      path: 'api/v1$path',
      port: port,
      queryParameters: queryParameter,
    );
  }
}
