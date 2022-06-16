class AppException implements Exception {
  AppException(
    this.message, {
    required this.name,
  });

  final String message;
  final String name;

  @override
  String toString() {
    return '$name: $message';
  }
}

class UnauthorizedException extends AppException {
  UnauthorizedException(
    super.message, {
    super.name = 'Unauthorized 403',
  });
}

class ConnectionExpcetion extends AppException {
  ConnectionExpcetion(
    super.message, {
    super.name = 'Connection:',
  });
}

class TimeoutException extends AppException {
  TimeoutException(
    super.message, {
    super.name = 'Timeout',
  });
}

class BadRequestedExpcetion extends AppException {
  BadRequestedExpcetion(super.message, {super.name = 'Bad requested',});
}
