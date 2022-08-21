part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileGetUserInformation extends ProfileEvent {}

class ProfileGetLikedBlogs extends ProfileEvent {}

class ProfileConfirmEditInformation extends ProfileEvent {}

class ProfileUserLogoutRequested extends ProfileEvent {}

class ProfileAvatarButtonPressed extends ProfileEvent {}

class ProfileOnLongPressedBlog extends ProfileEvent {
  const ProfileOnLongPressedBlog({
    required this.blog,
  });

  final BlogModel blog;

  @override
  List<Object?> get props => [blog];
}
