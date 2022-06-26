part of 'bookmark_bloc.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();

  @override
  List<Object> get props => [];
}

class BookmarkFetching extends BookmarkEvent {}

class BookmarkAddBlog extends BookmarkEvent {
  const BookmarkAddBlog({required this.blog});

  final BlogModel blog;

  @override
  List<Object> get props => [blog];
}

class BookmarkRemoveBlog extends BookmarkEvent {
  const BookmarkRemoveBlog({required this.blog});

  final BlogModel blog;

  @override
  List<Object> get props => [blog];
}
