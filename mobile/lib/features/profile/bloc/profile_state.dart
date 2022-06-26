part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, done, error }

enum DeleteStatus { initial, loading, done, error }

class ProfileState extends Equatable {
  const ProfileState({
    this.user,
    this.messageError = '',
    this.profileStatus = ProfileStatus.initial,
    this.deleteStatus = DeleteStatus.initial,
    this.userBlogs = const <BlogModel>[],
    this.userLikedBlogs = const <BlogModel>[],
    this.imagePath = '',
  });

  final UserModel? user;
  final String messageError;
  final ProfileStatus profileStatus;
  final DeleteStatus deleteStatus;
  final List<BlogModel> userBlogs;
  final List<BlogModel> userLikedBlogs;
  final String imagePath;

  @override
  List<Object?> get props => [
        user,
        messageError,
        profileStatus,
        userBlogs,
        deleteStatus,
        userLikedBlogs,
        imagePath,
      ];

  ProfileState copyWith({
    UserModel? user,
    String? messageError,
    ProfileStatus? profileStatus,
    DeleteStatus? deleteStatus,
    List<BlogModel>? userBlogs,
    List<BlogModel>? userLikedBlogs,
    String? imagePath,
  }) {
    return ProfileState(
      user: user ?? this.user,
      messageError: messageError ?? this.messageError,
      profileStatus: profileStatus ?? this.profileStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      userBlogs: userBlogs ?? this.userBlogs,
      userLikedBlogs: userLikedBlogs ?? this.userLikedBlogs,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
