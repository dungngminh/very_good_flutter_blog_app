part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState({
    this.status = AuthenticationStatus.unknown,
  });


  final AuthenticationStatus status;

  @override
  List<Object?> get props => [status];
}
