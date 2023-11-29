import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:very_good_blog_app_backend/common/constants.dart';

part 'base_response_data.g.dart';

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
)
class BaseResponseData {
  const BaseResponseData({
    required this.success,
    this.data,
    this.message = kSuccessResponseMessage,
  });

  factory BaseResponseData.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseDataFromJson(json);

  factory BaseResponseData.data(dynamic data) {
    return BaseResponseData(
      success: true,
      data: data,
    );
  }

  factory BaseResponseData.empty([String? message]) {
    return BaseResponseData(
      success: true,
      message: message ?? kSuccessResponseMessage,
    );
  }

  factory BaseResponseData.failed([String? message]) {
    return BaseResponseData(
      success: false,
      message: message ?? kFailedResponseMessage,
    );
  }

  final bool success;
  final String message;
  final dynamic data;

  Map<String, dynamic> toJson() => _$BaseResponseDataToJson(this);

  BaseResponseData copyWith({
    bool? success,
    String? message,
    dynamic data,
  }) {
    return BaseResponseData(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

class OkResponse extends Response {
  OkResponse([dynamic data])
      : super.json(
          statusCode: HttpStatus.ok,
          body: data == null
              ? BaseResponseData.empty().toJson()
              : BaseResponseData.data(data).toJson(),
        );
}

class CreatedResponse extends Response {
  CreatedResponse([String? message])
      : super.json(
          statusCode: HttpStatus.created,
          body: BaseResponseData.empty(message).toJson(),
        );
}

class NotFoundResponse extends Response {
  NotFoundResponse([String? message])
      : super.json(
          statusCode: HttpStatus.notFound,
          body: BaseResponseData.failed(message).toJson(),
        );
}

class ConflictResponse extends Response {
  ConflictResponse([String? message])
      : super.json(
          statusCode: HttpStatus.conflict,
          body: BaseResponseData.failed(message).toJson(),
        );
}

class UnauthorizedResponse extends Response {
  UnauthorizedResponse([String? message])
      : super.json(
          statusCode: HttpStatus.unauthorized,
          body: BaseResponseData.failed(message).toJson(),
        );
}

class BadRequestResponse extends Response {
  BadRequestResponse([String? message])
      : super.json(
          statusCode: HttpStatus.badRequest,
          body: BaseResponseData.failed(message).toJson(),
        );
}

class ForbiddenResponse extends Response {
  ForbiddenResponse([String? message])
      : super.json(
          statusCode: HttpStatus.forbidden,
          body: BaseResponseData.failed(message).toJson(),
        );
}

class ServerErrorResponse extends Response {
  ServerErrorResponse([String? message])
      : super.json(
          statusCode: HttpStatus.internalServerError,
          body: BaseResponseData.failed(message).toJson(),
        );
}

class MethodNotAllowedResponse extends Response {
  MethodNotAllowedResponse()
      : super.json(
          statusCode: HttpStatus.methodNotAllowed,
        );
}
