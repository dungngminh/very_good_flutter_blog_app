part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileGetUserInformation extends ProfileEvent {}

class ProfileConfirmEditUserInformation extends ProfileEvent {}

class ProfileUserLogoutRequested extends ProfileEvent {}
