import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secure_storage_helper/secure_storage_helper.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_blog_app/app/app.dart';

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
    on<ProfileGetLikedBlogs>(_onGetLikedBlogs);
    on<ProfileConfirmEditInformation>(_onConfirmEditUserInformation);
    on<ProfileAvatarButtonPressed>(_onAvatarButtonPressed);
    on<ProfileOnLongPressedBlog>(_onBlogLongPressed);
    add(ProfileGetUserInformation());
    add(ProfileGetLikedBlogs());
  }

  final UserRepository _userRepository;
  final AuthenticationRepository _authenticationRepository;
  final BlogRepository _blogRepository;

  Future<void> _onBlogLongPressed(
    ProfileOnLongPressedBlog event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(deleteStatus: DeleteBlogStatus.loading));
      await _blogRepository.deleteBlog(event.blog.id);
      emit(state.copyWith(deleteStatus: DeleteBlogStatus.done));
      add(ProfileGetUserInformation());
    } catch (e) {
      emit(
        state.copyWith(
          deleteStatus: DeleteBlogStatus.error,
          messageError: e.toString(),
        ),
      );
      rethrow;
    }
  }

  Future<void> _onGetUserInformation(
    ProfileGetUserInformation event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(profileStatus: ProfileStatus.loading));
      final userId =
          await SecureStorageHelper.readValueByKey(SecureStorageKey.userId);
      final user = await _userRepository.getUserInformationByUserId(userId!);

      final userBlogs = await _blogRepository.getBlogsByUserId(userId);
      add(ProfileGetLikedBlogs());
      emit(
        state.copyWith(
          user: user,
          profileStatus: ProfileStatus.done,
          userBlogs: userBlogs,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          messageError: e.toString(),
          profileStatus: ProfileStatus.error,
        ),
      );
      rethrow;
    }
  }

  Future<void> _onGetLikedBlogs(
    ProfileGetLikedBlogs event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(likeBlogStatus: LikeBlogStatus.loading));
      final userLikesBlog = await _blogRepository.getLikedBlog();
      emit(
        state.copyWith(
          likeBlogStatus: LikeBlogStatus.done,
          userLikedBlogs: userLikesBlog,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          messageError: e.toString(),
          likeBlogStatus: LikeBlogStatus.loading,
        ),
      );
      rethrow;
    }
  }

  Future<void> _onUserRequestedLogout(
    ProfileUserLogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    return _authenticationRepository.logout();
  }

  Future<void> _onConfirmEditUserInformation(
    ProfileConfirmEditInformation event,
    Emitter<ProfileState> emit,
  ) async {
    return _authenticationRepository.logout();
  }

  Future<void> _onAvatarButtonPressed(
    ProfileAvatarButtonPressed event,
    Emitter<ProfileState> emit,
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
}
