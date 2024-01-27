part of 'register_bloc.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.status = FormzSubmissionStatus.initial,
    this.username = const Username.isPure(),
    this.password = const Password.isPure(),
    this.lastname = const Lastname.isPure(),
    this.firstname = const Firstname.isPure(),
    this.confirmedPassword = const ConfirmedPassword.isPure(),
    this.isValid = false,
  });

  final FormzSubmissionStatus status;
  final Username username;
  final Password password;
  final Lastname lastname;
  final Firstname firstname;
  final ConfirmedPassword confirmedPassword;
  final bool isValid;

  RegisterState copyWith({
    FormzSubmissionStatus? status,
    Username? username,
    Password? password,
    Lastname? lastname,
    Firstname? firstname,
    ConfirmedPassword? confirmedPassword,
    bool? isValid,
  }) {
    return RegisterState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      lastname: lastname ?? this.lastname,
      firstname: firstname ?? this.firstname,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props {
    return [
      status,
      username,
      password,
      lastname,
      firstname,
      confirmedPassword,
      isValid,
    ];
  }
}
