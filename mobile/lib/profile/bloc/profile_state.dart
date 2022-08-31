part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, done, error }

enum DeleteBlogStatus { initial, loading, done, error }

enum LikeBlogStatus { initial, loading, done, error }

class ProfileState extends Equatable {
  const ProfileState({
    this.user,
    this.messageError = '',
    this.profileStatus = ProfileStatus.initial,
    this.deleteStatus = DeleteBlogStatus.initial,
    this.likeBlogStatus = LikeBlogStatus.initial,
    this.userBlogs = const <BlogModel>[],
    this.userLikedBlogs = const <String>[],
    this.imagePath = '',
  });

  final UserModel? user;
  final String messageError;
  final ProfileStatus profileStatus;
  final DeleteBlogStatus deleteStatus;
  final LikeBlogStatus likeBlogStatus;
  final List<BlogModel> userBlogs;
  final List<String> userLikedBlogs;
  final String imagePath;

  @override
  List<Object?> get props => [
        user,
        messageError,
        profileStatus,
        userBlogs,
        deleteStatus,
        likeBlogStatus,
        userLikedBlogs,
        imagePath,
      ];

  ProfileState copyWith({
    UserModel? user,
    String? messageError,
    ProfileStatus? profileStatus,
    DeleteBlogStatus? deleteStatus,
    LikeBlogStatus? likeBlogStatus,
    List<BlogModel>? userBlogs,
    List<String>? userLikedBlogs,
    String? imagePath,
  }) {
    return ProfileState(
      user: user ?? this.user,
      messageError: messageError ?? this.messageError,
      profileStatus: profileStatus ?? this.profileStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      likeBlogStatus: likeBlogStatus ?? this.likeBlogStatus,
      userBlogs: userBlogs ?? this.userBlogs,
      userLikedBlogs: userLikedBlogs ?? this.userLikedBlogs,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
