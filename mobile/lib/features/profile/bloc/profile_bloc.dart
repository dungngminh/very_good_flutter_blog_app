import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_blog_app/models/models.dart';
import 'package:very_good_blog_app/repository/repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required UserRepository userRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _userRepository = userRepository,
        _authenticationRepository = authenticationRepository,
        super(const ProfileState()) {
    on<ProfileGetUserInformation>(_onGetUserInformation);
    on<ProfileUserLogoutRequested>(_onUserRequestedLogout);
    on<ProfileConfirmEditUserInformation>(_onConfirmEditUserInformation);
    add(ProfileGetUserInformation());
  }

  final UserRepository _userRepository;
  final AuthenticationRepository _authenticationRepository;

  Future<void> _onGetUserInformation(
    ProfileGetUserInformation event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      final user = await _userRepository.getUserInformation();
      emit(state.copyWith(user: user, status: ProfileStatus.done));
    } catch (e) {
      emit(
        state.copyWith(messageError: e.toString(), status: ProfileStatus.error),
      );
    }
  }

  Future<void> _onUserRequestedLogout(
    ProfileUserLogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    return _authenticationRepository.logOut();
  }

  Future<FutureOr<void>> _onConfirmEditUserInformation(
    ProfileConfirmEditUserInformation event,
    Emitter<ProfileState> emit,
  ) async {
    await _authenticationRepository.logOut();
  }
}
