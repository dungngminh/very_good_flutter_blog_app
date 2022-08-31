part of 'edit_profile_bloc.dart';

enum EditProfileType {
  lastNameChanged,
  firstNameChanged,
  enalbeToEdit,
  submitted,
  chooseImageButtonPressed,
}

class EditProfileEvent extends Equatable {
  const EditProfileEvent(
    this.type, {
    this.input = '',
  });

  final EditProfileType? type;
  final String input;

  @override
  List<Object?> get props => [type, input];
}
