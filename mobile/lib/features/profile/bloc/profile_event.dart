// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileGetUserInformation extends ProfileEvent {
  final User? user;
  final bool isForRefreshing;

  const ProfileGetUserInformation({
    this.user,
    this.isForRefreshing = false,
  });

  @override
  List<Object?> get props => [user];
}

class ProfileConfirmEditUserInformation extends ProfileEvent {}

class ProfileUserLogoutRequested extends ProfileEvent {}
