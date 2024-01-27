part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzSubmissionStatus.initial,
    this.username = const Username.isPure(),
    this.password = const Password.isPure(),
    this.isValid = false,
  });

  final FormzSubmissionStatus status;
  final Username username;
  final Password password;
  final bool isValid;

  LoginState copyWith({
    FormzSubmissionStatus? status,
    Username? username,
    Password? password,
    bool? isValid,
  }) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [status, username, password, isValid];
}
