part of 'register_bloc.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.formStatus = FormzStatus.pure,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.lastname = const Lastname.pure(),
    this.firstname = const Firstname.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
  });

  final FormzStatus formStatus;
  final Username username;
  final Password password;
  final Lastname lastname;
  final Firstname firstname;
  final ConfirmedPassword confirmedPassword;

  RegisterState copyWith({
    FormzStatus? formStatus,
    Username? username,
    Password? password,
    Lastname? lastname,
    Firstname? firstname,
    ConfirmedPassword? confirmedPassword,
  }) {
    return RegisterState(
      formStatus: formStatus ?? this.formStatus,
      username: username ?? this.username,
      password: password ?? this.password,
      lastname: lastname ?? this.lastname,
      firstname: firstname ?? this.firstname,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
    );
  }

  @override
  List<Object?> get props {
    return [
      formStatus,
      username,
      password,
      lastname,
      firstname,
      confirmedPassword,
    ];
  }
}
