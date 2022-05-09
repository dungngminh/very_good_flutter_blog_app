import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:very_good_blog_app/features/register/register.dart';
import 'package:very_good_blog_app/repository/authentication_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const RegisterState()) {
    on<RegisterEvent>((event, emit) {
      switch (event.type) {
        case RegisterEventType.lastNameChanged:
          _onLastnameChanged(event.input, emit);
          break;
        case RegisterEventType.firstNameChanged:
          _onFirstnameChanged(event.input, emit);
          break;
        case RegisterEventType.confirmedPasswordChanged:
          _onConfirmedPasswordChanged(event.input, emit);
          break;
        case RegisterEventType.userNameChanged:
          _onUsernameChanged(event.input, emit);
          break;
        case RegisterEventType.passwordChanged:
          _onPasswordChanged(event.input, emit);
          break;
        case RegisterEventType.submitted:
          _onSubmitted(emit);
          break;
      }
    });
  }

  final AuthenticationRepository _authenticationRepository;

  void _onLastnameChanged(String input, Emitter<RegisterState> emit) {
    final lastname = Lastname.dirty(input);
    emit(
      state.copyWith(
        username: state.username,
        password: state.password,
        confirmedPassword: state.confirmedPassword,
        lastname: lastname,
        firstname: state.firstname,
        status: Formz.validate(
          [
            state.username,
            state.password,
            state.confirmedPassword,
            lastname,
            state.firstname,
          ],
        ),
      ),
    );
  }

  void _onFirstnameChanged(String input, Emitter<RegisterState> emit) {
    final firstname = Firstname.dirty(input);
    emit(
      state.copyWith(
        username: state.username,
        password: state.password,
        confirmedPassword: state.confirmedPassword,
        lastname: state.lastname,
        firstname: firstname,
        status: Formz.validate(
          [
            state.username,
            state.password,
            state.confirmedPassword,
            state.lastname,
            firstname,
          ],
        ),
      ),
    );
  }

  void _onConfirmedPasswordChanged(String input, Emitter<RegisterState> emit) {
    final confirmedPassword =
        ConfirmedPassword.dirty(password: state.password.value, value: input);
    emit(
      state.copyWith(
        username: state.username,
        password: state.password,
        confirmedPassword: confirmedPassword,
        lastname: state.lastname,
        firstname: state.firstname,
        status: Formz.validate(
          [
            state.username,
            state.password,
            confirmedPassword,
            state.lastname,
            state.firstname,
          ],
        ),
      ),
    );
  }

  void _onUsernameChanged(String input, Emitter<RegisterState> emit) {
    final username = Username.dirty(input);
    emit(
      state.copyWith(
        username: username,
        password: state.password,
        confirmedPassword: state.confirmedPassword,
        lastname: state.lastname,
        firstname: state.firstname,
        status: Formz.validate(
          [
            username,
            state.password,
            state.confirmedPassword,
            state.lastname,
            state.firstname,
          ],
        ),
      ),
    );
  }

  void _onPasswordChanged(String input, Emitter<RegisterState> emit) {
    final password = Password.dirty(input);
    emit(
      state.copyWith(
        username: state.username,
        password: password,
        confirmedPassword: state.confirmedPassword,
        lastname: state.lastname,
        firstname: state.firstname,
        status: Formz.validate(
          [
            state.username,
            password,
            state.confirmedPassword,
            state.lastname,
            state.firstname,
          ],
        ),
      ),
    );
  }

  Future<void> _onSubmitted(Emitter<RegisterState> emit) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        await _authenticationRepository.logIn(
          username: state.username.value,
          password: state.password.value,
        );
      } catch (e) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}
