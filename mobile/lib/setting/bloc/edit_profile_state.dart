part of 'edit_profile_bloc.dart';

class EditProfileState extends Equatable {
  const EditProfileState({
    this.validationStatus = FormzStatus.pure,
    this.editProfileStatus = LoadingStatus.done,
    this.lastname = const Lastname.pure(),
    this.firstname = const Firstname.pure(),
    this.imagePath = '',
    this.enableEditing = false,
    this.errorMessage = '',
  });

  final FormzStatus validationStatus;
  final LoadingStatus editProfileStatus;
  final Lastname lastname;
  final Firstname firstname;
  final String imagePath;
  final bool enableEditing;
  final String errorMessage;

  EditProfileState copyWith({
    FormzStatus? validationStatus,
    LoadingStatus? editProfileStatus,
    Lastname? lastname,
    Firstname? firstname,
    String? imagePath,
    bool? enableEditing,
    String? errorMessage,
  }) {
    return EditProfileState(
      validationStatus: validationStatus ?? this.validationStatus,
      lastname: lastname ?? this.lastname,
      editProfileStatus: editProfileStatus ?? this.editProfileStatus,
      firstname: firstname ?? this.firstname,
      imagePath: imagePath ?? this.imagePath,
      enableEditing: enableEditing ?? this.enableEditing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props {
    return [
      validationStatus,
      lastname,
      firstname,
      imagePath,
      enableEditing,
      editProfileStatus,
      errorMessage
    ];
  }
}
