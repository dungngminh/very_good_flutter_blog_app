class HttpException implements Exception {
  HttpException(
    this.statusCode, {
    this.message = '',
  });

  final String message;
  final int statusCode;
}

class UnauthorizedException extends HttpException {
  UnauthorizedException({super.message = 'Unauthorized'}) : super(401);
}

class BadRequestException extends HttpException {
  BadRequestException({super.message = 'Bad Request'}) : super(400);
}

class TimeoutException extends HttpException {
  TimeoutException({super.message = 'Request Timeout'}) : super(408);
}

class NotFoundException extends HttpException {
  NotFoundException({super.message = 'Not Found'}) : super(404);
}

class ServerErrorException extends HttpException {
  ServerErrorException({super.message = 'Internal Server Error'}) : super(500);
}
