// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, done, error }

class ProfileState extends Equatable {
  const ProfileState({
    this.user,
    this.messageError,
    this.status = ProfileStatus.initial,
  });

  final User? user;
  final String? messageError;
  final ProfileStatus status;

  @override
  List<Object?> get props => [user, messageError, status];

  ProfileState copyWith({
    User? user,
    String? messageError,
    ProfileStatus? status,
  }) {
    return ProfileState(
      user: user ?? this.user,
      messageError: messageError ?? this.messageError,
      status: status ?? this.status,
    );
  }
}
