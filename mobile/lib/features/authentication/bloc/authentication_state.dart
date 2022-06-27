part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState({
    this.status = AuthenticationStatus.unknown,
    this.isOffline = false,
  });

  final AuthenticationStatus status;
  final bool isOffline;

  @override
  List<Object?> get props => [status, isOffline];

  AuthenticationState copyWith({
    AuthenticationStatus? status,
    bool? isOffline,
  }) {
    return AuthenticationState(
      status: status ?? this.status,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}
