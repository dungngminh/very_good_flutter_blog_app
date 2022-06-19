part of 'blog_bloc.dart';

abstract class BlogEvent extends Equatable {
  const BlogEvent();

  @override
  List<Object?> get props => [];
}

class BlogGetBlogs extends BlogEvent {
  const BlogGetBlogs({
    this.limit = 10,
    this.page = 1,
  });

  final int limit;
  final int page;

  @override
  List<Object?> get props => [limit, page];
}

class BlogLikePressed extends BlogEvent {
  const BlogLikePressed({
    required this.id,
  });

  final String id;

  @override
  List<Object?> get props => [id];
}

class BlogAddToBookmarkPressed extends BlogEvent {
  const BlogAddToBookmarkPressed({
    required this.blog,
  });

  final Blog blog;

  @override
  List<Object?> get props => [blog];
}

class BlogSearchChanged extends BlogEvent {
  const BlogSearchChanged({
    required this.value,
  });

  final String value;

  @override
  List<Object?> get props => [value];
}

class BlogCategoryPressed extends BlogEvent {
  const BlogCategoryPressed({
    required this.catagory,
  });

  final String catagory;

  @override
  List<Object?> get props => [catagory];
}

class BlogRemoveFromBookmarkPressed extends BlogEvent {
  const BlogRemoveFromBookmarkPressed({
    required this.blog,
  });

  final Blog blog;

  @override
  List<Object?> get props => [blog];
}

class BlogCardPressed extends BlogEvent {
  const BlogCardPressed({
    required this.blogId,
  });

  final String blogId;

  @override
  List<Object?> get props => [blogId];
}
