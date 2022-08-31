part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticationStatusChanged extends AuthenticationEvent {
  const AuthenticationStatusChanged({
    required this.status,
  });

  final AuthenticationStatus status;

  @override
  List<Object?> get props => [status];
}

class AuthenticationConectivityStatusChanged extends AuthenticationEvent {
  const AuthenticationConectivityStatusChanged({
    this.isOffline = false,
  });

  final bool isOffline;

  @override
  List<Object?> get props => [isOffline];
}
