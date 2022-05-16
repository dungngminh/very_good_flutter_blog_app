part of 'register_bloc.dart';

enum RegisterEventType {
  lastNameChanged,
  firstNameChanged,
  confirmedPasswordChanged,
  userNameChanged,
  passwordChanged,
  submitted,
}

 class RegisterEvent extends Equatable {
  const RegisterEvent(
    this.type,{
    this.input = '',
  });

  final RegisterEventType? type;
  final String input;
  @override
  List<Object?> get props => [type, input];
}
