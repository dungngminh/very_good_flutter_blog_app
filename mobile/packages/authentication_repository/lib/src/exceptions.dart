/// {@template authentication_repository}
/// Base exception for authentication_repository failures.
/// {@endtemplate}
abstract class AuthenticationException implements Exception {
  /// {@macro authentication_repository}
  const AuthenticationException(this.error, this.stackTrace);

  /// The error that was caught.
  final Object error;

  /// The Stacktrace associated with the [error].
  final StackTrace stackTrace;
}

/// Extending `AuthenticationException` and is used 
/// to throw an exception when the user
/// is not logged in.
class LoginException extends AuthenticationException {
  LoginException(super.error, super.stackTrace);
}

/// Extending `AuthenticationException` and is used to 
/// throw an exception when the user
/// is not registered.
class RegisterException extends AuthenticationException {
  RegisterException(super.error, super.stackTrace);
}

/// A class that extends `AuthenticationException` and is 
/// used to throw an exception when the user
/// is not logged out.
class LogoutException extends AuthenticationException {
  LogoutException(super.error, super.stackTrace);
}
