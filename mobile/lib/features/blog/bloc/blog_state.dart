part of 'blog_bloc.dart';

enum GetBlogStatus { loading, done, error }

enum LikeBlogStatus { initial, loading, done, error }


class BlogState extends Equatable {
  const BlogState({
    this.getBlogStatus = GetBlogStatus.loading,
    this.likeBlogStatus = LikeBlogStatus.initial,
    this.blogs = const <BlogModel>[],
    this.filterBlogs = const <BlogModel>[],
    this.popularBlogs = const <BlogModel>[],
    this.errorMessage = '',
    this.category = 'Tất cả',
    this.isSearching = false,
  });

  final GetBlogStatus getBlogStatus;
  final LikeBlogStatus likeBlogStatus;
  final List<BlogModel> blogs;
  final List<BlogModel> filterBlogs;
  final List<BlogModel> popularBlogs;
  final String errorMessage;
  final String category;
  final bool isSearching;

  BlogState copyWith({
    GetBlogStatus? getBlogStatus,
    LikeBlogStatus? likeBlogStatus,
    List<BlogModel>? blogs,
    List<BlogModel>? filterBlogs,
    List<BlogModel>? popularBlogs,
    bool? isSearching,
    String? errorMessage,
    String? category,
  }) {
    return BlogState(
      getBlogStatus: getBlogStatus ?? this.getBlogStatus,
      blogs: blogs ?? this.blogs,
      likeBlogStatus: likeBlogStatus ?? this.likeBlogStatus,
      filterBlogs: filterBlogs ?? this.filterBlogs,
      popularBlogs: popularBlogs ?? this.popularBlogs,
      isSearching: isSearching ?? this.isSearching,
      errorMessage: errorMessage ?? this.errorMessage,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props {
    return [
      getBlogStatus,
      likeBlogStatus,
      blogs,
      filterBlogs,
      isSearching,
      errorMessage,
      category,
    ];
  }
}
