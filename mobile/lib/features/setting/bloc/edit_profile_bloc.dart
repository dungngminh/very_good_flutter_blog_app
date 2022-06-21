import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/features/profile/bloc/profile_bloc.dart';
import 'package:very_good_blog_app/features/register/register.dart';
import 'package:very_good_blog_app/repository/repository.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc({
    required UserRepository userRepository,
    required ProfileBloc profileBloc,
  })  : _userRepository = userRepository,
        _profileBloc = profileBloc,
        super(const EditProfileState()) {
    on<EditProfileEvent>((event, emit) async {
      switch (event.type!) {
        case EditProfileType.lastNameChanged:
          _onLastnameChanged(event.input, emit);
          break;
        case EditProfileType.firstNameChanged:
          _onFirstnameChanged(event.input, emit);
          break;
        case EditProfileType.enalbeToEdit:
          _onEnableToEdit(event, emit);
          break;
        case EditProfileType.submitted:
          await _onSubmitted(event, emit);
          break;
        case EditProfileType.chooseImageButtonPressed:
          await _chooseImageButtonPressed(event, emit);
          break;
      }
    });
    add(
      EditProfileEvent(
        EditProfileType.firstNameChanged,
        input: profileBloc.state.user!.firstName,
      ),
    );
    add(
      EditProfileEvent(
        EditProfileType.lastNameChanged,
        input: profileBloc.state.user!.lastName,
      ),
    );
  }

  final UserRepository _userRepository;
  final ProfileBloc _profileBloc;

  Future<void> _onSubmitted(
    EditProfileEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    if (state.validationStatus.isValid) {
      emit(state.copyWith(loadingStatus: EditProfileLoadingStatus.loading));
      try {
        final user = _profileBloc.state.user;
        await _userRepository.updateUserInformation(
          username: user!.username,
          firstName: state.firstname.value,
          lastName: state.lastname.value,
          imagePath: state.imagePath == '' ? user.avatarUrl : state.imagePath,
          userId: user.id,
        );
        emit(state.copyWith(loadingStatus: EditProfileLoadingStatus.done));
      } catch (e) {
        emit(
          state.copyWith(
            loadingStatus: EditProfileLoadingStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  void _onEnableToEdit(
    EditProfileEvent event,
    Emitter<EditProfileState> emit,
  ) {
    emit(state.copyWith(enableEditing: !state.enableEditing));
  }

  Future<void> _chooseImageButtonPressed(
    EditProfileEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    final imagePickedPath =
        await ImagePickerHelper.pickImageFromSource(ImageSource.gallery);
    if (imagePickedPath != null) {
      emit(
        state.copyWith(
          imagePath: imagePickedPath,
        ),
      );
    }
  }

  void _onLastnameChanged(String input, Emitter<EditProfileState> emit) {
    final lastname = Lastname.dirty(input);
    emit(
      state.copyWith(
        lastname: lastname,
        firstname: state.firstname,
        validationStatus: Formz.validate(
          [
            lastname,
            state.firstname,
          ],
        ),
      ),
    );
  }

  void _onFirstnameChanged(String input, Emitter<EditProfileState> emit) {
    final firstname = Firstname.dirty(input);
    emit(
      state.copyWith(
        lastname: state.lastname,
        firstname: firstname,
        validationStatus: Formz.validate(
          [
            state.lastname,
            firstname,
          ],
        ),
      ),
    );
  }
}
