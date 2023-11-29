import 'dart:async';

import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';
import 'package:string_validator/string_validator.dart';
import 'package:very_good_blog_app_backend/common/extensions/hash_extension.dart';
import 'package:very_good_blog_app_backend/common/extensions/json_ext.dart';
import 'package:very_good_blog_app_backend/dtos/request/auth/login_request.dart';
import 'package:very_good_blog_app_backend/dtos/response/auth/login_response.dart';
import 'package:very_good_blog_app_backend/dtos/response/base_response_data.dart';
import 'package:very_good_blog_app_backend/models/user.dart';
import 'package:very_good_blog_app_backend/util/create_jwt.dart';

/// @Allow(POST)
Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _onLoginPostRequest(context),
    _ => Future.value(MethodNotAllowedResponse()),
  };
}

Future<Response> _onLoginPostRequest(RequestContext context) async {
  final db = context.read<Database>();

  final body = await context.request.body();

  if (body.isEmpty) return BadRequestResponse();
  final request = LoginRequest.fromJson(body.asJson());

  if (!isEmail(request.email)) {
    return BadRequestResponse('Email format is wrong, please check again');
  }

  return db.users
      .queryUsers(
    QueryParams(
      where: 'email=@email AND password=@password',
      values: {'email': request.email, 'password': request.password.hashValue},
    ),
  )
      .then<Response>((users) {
    final user = users.firstOrNull;
    return user == null
        ? BadRequestResponse('User is not registered')
        : OkResponse(
            LoginResponse(id: user.id, token: createJwt(user.id)).toJson(),
          );
  }).onError((e, _) => ServerErrorResponse(e.toString()));
}
