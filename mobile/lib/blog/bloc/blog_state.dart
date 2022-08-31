part of 'blog_bloc.dart';



class BlogState extends Equatable {
  const BlogState({
    this.getBlogStatus = LoadingStatus.done,
    this.likeBlogStatus = LoadingStatus.done,
    this.blogs = const <BlogModel>[],
    this.filterBlogs = const <BlogModel>[],
    this.popularBlogs = const <BlogModel>[],
    this.errorMessage = '',
    this.category = 'all',
    this.isSearching = false,
  });

  final LoadingStatus getBlogStatus;
  final LoadingStatus likeBlogStatus;
  final List<BlogModel> blogs;
  final List<BlogModel> filterBlogs;
  final List<BlogModel> popularBlogs;
  final String errorMessage;
  final String category;
  final bool isSearching;

  BlogState copyWith({
    LoadingStatus? getBlogStatus,
    LoadingStatus? likeBlogStatus,
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
