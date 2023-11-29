import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:very_good_blog_app_backend/common/constants.dart';
import 'package:very_good_blog_app_backend/dtos/request/auth/login_request.dart';
import 'package:very_good_blog_app_backend/dtos/request/auth/register_request.dart';
import 'package:very_good_blog_app_backend/dtos/response/auth/login_response.dart';
import 'package:very_good_blog_app_backend/dtos/response/base_response_data.dart';

import 'helpers.dart';

void main() {
  group('E2E Authentication', () {
    final loginRequest = LoginRequest(
      email: 'ngminhdung1311@gmail.com',
      password: 'kminhdung123',
    );
    final registerRequest = RegisterRequest(
      fullName: 'Mặt gian vcl (from bé nào đó)',
      email: 'ngminhdung1311@gmail.com',
      password: 'kminhdung123',
      confirmationPassword: 'kminhdung123',
    );
    test(
        'POST /api/auth/login return BadRequestResponse(User is not registered)',
        () async {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/auth/login'),
        headers: headers,
        body: jsonEncode(loginRequest.toJson()),
      );

      expect(response.statusCode, HttpStatus.badRequest);
      expect(
        jsonDecode(response.body),
        equals({
          'success': false,
          'message': 'User is not registered',
        }),
      );
    });

    test('POST /api/auth/register return CreatedResponse()', () async {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/auth/register'),
        headers: headers,
        body: jsonEncode(registerRequest.toJson()),
      );

      expect(response.statusCode, HttpStatus.created);
      expect(
        jsonDecode(response.body),
        equals({
          'success': true,
          'message': kSuccessResponseMessage,
        }),
      );
    });

    test(
        'POST /api/auth/register return BadRequestResponse(This email was registered)',
        () async {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/auth/register'),
        headers: headers,
        body: jsonEncode(registerRequest.toJson()),
      );

      expect(response.statusCode, HttpStatus.conflict);
      expect(
        jsonDecode(response.body),
        equals({
          'success': false,
          'message': 'This email was registered',
        }),
      );
    });

    test('POST /api/auth/login return OkResponse and data is userid and jwt',
        () async {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/auth/login'),
        headers: headers,
        body: jsonEncode(loginRequest.toJson()),
      );

      final baseResponse = BaseResponseData.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );

      final loginResponse =
          LoginResponse.fromJson(baseResponse.data as Map<String, dynamic>);

      expect(response.statusCode, HttpStatus.ok);
      expect(
        jsonDecode(response.body),
        equals({
          'success': true,
          'message': kSuccessResponseMessage,
          'data': {
            'id': loginResponse.id,
            'token': loginResponse.token,
          },
        }),
      );
    });
  });
}
