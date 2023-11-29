import 'dart:async';

import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';
import 'package:string_validator/string_validator.dart';
import 'package:uuid/uuid.dart';
import 'package:very_good_blog_app_backend/common/extensions/hash_extension.dart';
import 'package:very_good_blog_app_backend/common/extensions/json_ext.dart';
import 'package:very_good_blog_app_backend/dtos/request/auth/register_request.dart';
import 'package:very_good_blog_app_backend/dtos/response/base_response_data.dart';
import 'package:very_good_blog_app_backend/models/user.dart';

/// @Allow(POST)
FutureOr<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _onRegisterPostRequest(context),
    _ => Future.value(MethodNotAllowedResponse()),
  };
}

Future<Response> _onRegisterPostRequest(RequestContext context) async {
  final db = context.read<Database>();

  final body = await context.request.body();

  if (body.isEmpty) return BadRequestResponse();

  final request = RegisterRequest.fromJson(body.asJson());

  if (request.password != request.confirmationPassword) {
    return BadRequestResponse('Confirmation password not match');
  }

  if (!isEmail(request.email)) {
    return BadRequestResponse('Email format is wrong, please check again');
  }

  final users = await db.users.queryUsers(
    QueryParams(
      where: 'email=@email',
      values: {
        'email': request.email,
      },
    ),
  );
  if (users.isNotEmpty) {
    return ConflictResponse('This email was registered');
  }

    return db.users
        .insertOne(
          UserInsertRequest(
            email: request.email,
            follower: 0,
            following: 0,
            fullName: request.fullName,
            id: const Uuid().v4(),
            password: request.password.hashValue,
          ),
        )
      .then<Response>((_) => CreatedResponse())
      .onError((e, _) => ServerErrorResponse(e.toString()));
}
