part of 'blog_bloc.dart';

enum GetBlogStatus { loading, idle, error }

enum LikeBlogStatus { initial, loading, idle, error }

enum ContentBlogStatus { initial, loading, idle, error }

class BlogState extends Equatable {
  const BlogState({
    this.getBlogStatus = GetBlogStatus.loading,
    this.likeBlogStatus = LikeBlogStatus.initial,
    this.contentBlogStatus = ContentBlogStatus.initial,
    this.blogs = const <BlogModel>[],
    this.filterBlogs = const <BlogModel>[],
    this.errorMessage = '',
    this.category = 'Tất cả',
    this.isSearching = false,
  });

  final GetBlogStatus getBlogStatus;
  final LikeBlogStatus likeBlogStatus;
  final ContentBlogStatus contentBlogStatus;
  final List<BlogModel> blogs;
  final List<BlogModel> filterBlogs;
  final String errorMessage;
  final String category;
  final bool isSearching;

  BlogState copyWith({
    GetBlogStatus? getBlogStatus,
    LikeBlogStatus? likeBlogStatus,
    ContentBlogStatus? contentBlogStatus,
    List<BlogModel>? blogs,
    List<BlogModel>? filterBlogs,
    bool? isSearching,
    String? errorMessage,
    String? category,
  }) {
    return BlogState(
      getBlogStatus: getBlogStatus ?? this.getBlogStatus,
      contentBlogStatus: contentBlogStatus ?? this.contentBlogStatus,
      blogs: blogs ?? this.blogs,
      likeBlogStatus: likeBlogStatus ?? this.likeBlogStatus,
      filterBlogs: filterBlogs ?? this.filterBlogs,
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
      contentBlogStatus,
      blogs,
      filterBlogs,
      isSearching,
      errorMessage,
      category,
    ];
  }
}
