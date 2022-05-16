part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user = User.empty,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(User user)
      : this._(
          status: AuthenticationStatus.authenticated,
          user: user,
        );

  const AuthenticationState.unauthenticated()
      : this._(
          status: AuthenticationStatus.unauthenticated,
        );

  const AuthenticationState.successfullyRegistered()
      : this._(
          status: AuthenticationStatus.successfullyRegistered,
        );
  const AuthenticationState.existed()
      : this._(
          status: AuthenticationStatus.existed,
        );
  const AuthenticationState.unsuccessfullyRegistered()
      : this._(
          status: AuthenticationStatus.unsuccessfullyRegistered,
        );

  final AuthenticationStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];
}
