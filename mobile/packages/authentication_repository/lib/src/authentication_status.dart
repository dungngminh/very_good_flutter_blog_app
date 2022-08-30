/// An enum that is used to indicate the authentication status of the user.
enum AuthenticationStatus {
  /// Used to indicate that the authentication status of the user is unknown.
  unknown,

  /// A state that is used to indicate that the user is authenticated.
  authenticated,

  /// A state that is used to indicate that the user
  /// is authenticated but the app is offline.
  authenticatedOffline,

  /// A state that is used to indicate that the user is not authenticated.
  unauthenticated,

  /// A state that is used to indicate that the user is successfully registered.
  successfullyRegistered,

  /// A state that is used to indicate that the user is already registered.
  existed,

  /// A value that is used to indicate that the user
  /// is not successfully registered.
  unsuccessfullyRegistered;
}
