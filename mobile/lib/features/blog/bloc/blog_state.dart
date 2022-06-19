part of 'blog_bloc.dart';

enum GetBlogStatus { loading, idle, error }

enum LikeBlogStatus { loading, idle, error }

enum ContentBlogStatus { loading, idle, error }

class BlogState extends Equatable {
  const BlogState({
    this.getBlogStatus = GetBlogStatus.idle,
    this.likeBlogStatus = LikeBlogStatus.idle,
    this.contentBlogStatus = ContentBlogStatus.idle,
    this.blogs = const <Blog>[],
    this.filterBlogs = const <Blog>[],
    this.isLoading = false,
    this.errorMessage = '',
  });

  final GetBlogStatus getBlogStatus;
  final LikeBlogStatus likeBlogStatus;
  final ContentBlogStatus contentBlogStatus;
  final List<Blog> blogs;
  final List<Blog> filterBlogs;
  final bool isLoading;
  final String errorMessage;

  BlogState copyWith({
    GetBlogStatus? getBlogStatus,
    LikeBlogStatus? likeBlogStatus,
    ContentBlogStatus? contentBlogStatus,
    List<Blog>? blogs,
    List<Blog>? filterBlogs,
    bool? isLoading,
    String? errorMessage,
  }) {
    return BlogState(
      getBlogStatus: getBlogStatus ?? this.getBlogStatus,
      contentBlogStatus: contentBlogStatus ?? this.contentBlogStatus,
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
      contentBlogStatus,
      blogs,
      filterBlogs,
      isLoading,
      errorMessage,
    ];
  }
}
