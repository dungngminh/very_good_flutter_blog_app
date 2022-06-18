part of 'blog_bloc.dart';

enum GetBlogStatus { loading, idle, error }

enum LikeBlogStatus { loading, idle, error }

class BlogState extends Equatable {
  const BlogState({
    this.getBlogStatus = GetBlogStatus.idle,
    this.likeBlogStatus = LikeBlogStatus.idle,
    this.blogs = const <Blog>{},
    this.filterBlogs = const <Blog>[],
    this.isLoading = false,
    this.errorMessage = '',
  });

  final GetBlogStatus getBlogStatus;
  final LikeBlogStatus likeBlogStatus;
  final Set<Blog> blogs;
  final List<Blog> filterBlogs;
  final bool isLoading;
  final String errorMessage;

  BlogState copyWith({
    GetBlogStatus? getBlogStatus,
    LikeBlogStatus? likeBlogStatus,
    Set<Blog>? blogs,
    List<Blog>? filterBlogs,
    bool? isLoading,
    String? errorMessage,
  }) {
    return BlogState(
      getBlogStatus: getBlogStatus ?? this.getBlogStatus,
      blogs: blogs ?? this.blogs,
      likeBlogStatus: likeBlogStatus ?? this.likeBlogStatus,
      filterBlogs: filterBlogs ?? this.filterBlogs,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props {
    return [
      getBlogStatus,
      likeBlogStatus,
      blogs,
      filterBlogs,
      isLoading,
      errorMessage,
    ];
  }
}
