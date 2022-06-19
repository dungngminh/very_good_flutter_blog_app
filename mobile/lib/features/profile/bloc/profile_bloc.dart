import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_blog_app/app/config/helpers/secure_storage_helper.dart';
import 'package:very_good_blog_app/models/models.dart';
import 'package:very_good_blog_app/repository/repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required UserRepository userRepository,
    required AuthenticationRepository authenticationRepository,
    required BlogRepository blogRepository,
  })  : _userRepository = userRepository,
        _authenticationRepository = authenticationRepository,
        _blogRepository = blogRepository,
        super(const ProfileState()) {
    on<ProfileGetUserInformation>(_onGetUserInformation);
    on<ProfileUserLogoutRequested>(_onUserRequestedLogout);
    on<ProfileConfirmEditUserInformation>(_onConfirmEditUserInformation);
    add(ProfileGetUserInformation());
  }

  final UserRepository _userRepository;
  final AuthenticationRepository _authenticationRepository;
  final BlogRepository _blogRepository;

  Future<void> _onGetUserInformation(
    ProfileGetUserInformation event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      final userId = await SecureStorageHelper.getValueByKey('id');
      final user = await _userRepository.getUserInformationByUserId(userId!);
      final userBlogs = await _blogRepository.getBlogsByUserId(userId);
      emit(
        state.copyWith(
          user: user,
          status: ProfileStatus.done,
          userBlogs: userBlogs,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          messageError: e.toString(),
          status: ProfileStatus.error,
        ),
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
