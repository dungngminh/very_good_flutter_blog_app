part of 'edit_profile_bloc.dart';

class EditProfileState extends Equatable {
  const EditProfileState({
    this.loadingStatus = LoadingStatus.done,
    this.lastname = const Lastname.isPure(),
    this.firstname = const Firstname.isPure(),
    this.imagePath = '',
    this.enableEditing = false,
    this.errorMessage = '',
    this.isValid = false,
  });

  final LoadingStatus loadingStatus;
  final Lastname lastname;
  final Firstname firstname;
  final String imagePath;
  final bool enableEditing;
  final String errorMessage;
  final bool isValid;

  EditProfileState copyWith({
    LoadingStatus? loadingStatus,
    Lastname? lastname,
    Firstname? firstname,
    String? imagePath,
    bool? enableEditing,
    String? errorMessage,
    bool? isValid,
  }) {
    return EditProfileState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      lastname: lastname ?? this.lastname,
      firstname: firstname ?? this.firstname,
      imagePath: imagePath ?? this.imagePath,
      enableEditing: enableEditing ?? this.enableEditing,
      errorMessage: errorMessage ?? this.errorMessage,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props {
    return [
      loadingStatus,
      lastname,
      firstname,
      imagePath,
      enableEditing,
      errorMessage,
      isValid,
    ];
  }
}
