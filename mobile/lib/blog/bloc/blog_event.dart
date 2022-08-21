part of 'blog_bloc.dart';

abstract class BlogEvent extends Equatable {
  const BlogEvent();

  @override
  List<Object?> get props => [];
}

class BlogGetBlogs extends BlogEvent {
  const BlogGetBlogs({
    this.page = 1,
  });

  final int page;

  @override
  List<Object?> get props => [page];
}

class BlogOnLongPressedBlog extends BlogEvent {
  const BlogOnLongPressedBlog({
    required this.blog,
  });

  final BlogModel blog;

  @override
  List<Object?> get props => [blog];
}

class BlogLikePressed extends BlogEvent {
  const BlogLikePressed({
    required this.id,
  });

  final String id;

  @override
  List<Object?> get props => [id];
}

class BlogUnlikePressed extends BlogEvent {
  const BlogUnlikePressed({
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

  final BlogModel blog;

  @override
  List<Object?> get props => [blog];
}

class BlogSearchChanged extends BlogEvent {
  const BlogSearchChanged({
    required this.value,
    this.page = 1,
  });

  final String value;
  final int page;

  @override
  List<Object?> get props => [value, page];
}

class BlogCategoryPressed extends BlogEvent {
  const BlogCategoryPressed({
    required this.catagory,
    this.page = 1,
  });

  final String catagory;
  final int page;

  @override
  List<Object?> get props => [catagory, page];
}

class BlogRemoveFromBookmarkPressed extends BlogEvent {
  const BlogRemoveFromBookmarkPressed({
    required this.blog,
  });

  final BlogModel blog;

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
