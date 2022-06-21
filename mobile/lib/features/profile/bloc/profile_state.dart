part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, done, error }

class ProfileState extends Equatable {
  const ProfileState({
    this.user,
    this.messageError = '',
    this.status = ProfileStatus.initial,
    this.userBlogs = const <BlogModel>[],
    this.userLikedBlogs = const <BlogModel>[],
    this.imagePath = '', 
  });

  final UserModel? user;
  final String messageError;
  final ProfileStatus status;
  final List<BlogModel> userBlogs;
  final List<BlogModel> userLikedBlogs;
  final String imagePath;

  @override
  List<Object?> get props => [
        user,
        messageError,
        status,
        userBlogs,
        userLikedBlogs,
        imagePath,
      ];

  ProfileState copyWith({
    UserModel? user,
    String? messageError,
    ProfileStatus? status,
    List<BlogModel>? userBlogs,
    List<BlogModel>? userLikedBlogs,
    String? imagePath, 
  }) {
    return ProfileState(
      user: user ?? this.user,
      messageError: messageError ?? this.messageError,
      status: status ?? this.status,
      userBlogs: userBlogs ?? this.userBlogs,
      userLikedBlogs: userLikedBlogs ?? this.userLikedBlogs,
      imagePath: imagePath ?? this.imagePath,
      
    );
  }
}
