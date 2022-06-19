part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, done, error }

class ProfileState extends Equatable {
  const ProfileState({
    this.user,
    this.messageError = '',
    this.status = ProfileStatus.initial,
    this.userBlogs = const <Blog>[],
    this.userLikedBlogs = const <Blog>[],
  });

  final User? user;
  final String messageError;
  final ProfileStatus status;
  final List<Blog> userBlogs;
  final List<Blog> userLikedBlogs;

  @override
  List<Object?> get props => [
        user,
        messageError,
        status,
        userBlogs,
        userLikedBlogs,
      ];

  ProfileState copyWith({
    User? user,
    String? messageError,
    ProfileStatus? status,
    List<Blog>? userBlogs,
    List<Blog>? userLikedBlogs,
  }) {
    return ProfileState(
      user: user ?? this.user,
      messageError: messageError ?? this.messageError,
      status: status ?? this.status,
      userBlogs: userBlogs ?? this.userBlogs,
      userLikedBlogs: userLikedBlogs ?? this.userLikedBlogs,
    );
  }
}
