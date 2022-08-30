/// {@template blog_exception}
/// Base exception for blog repository failures.
/// {@endtemplate}
abstract class BlogException implements Exception {
  /// {@macro blog_exception}
  const BlogException(this.error, this.stackTrace);

  /// The error that was caught.
  final Object error;

  /// The Stacktrace associated with the [error].
  final StackTrace stackTrace;
}
