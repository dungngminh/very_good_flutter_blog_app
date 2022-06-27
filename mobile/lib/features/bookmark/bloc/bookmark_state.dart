part of 'bookmark_bloc.dart';

enum GetBookmarkStatus { initial, loading, done, error }

enum ActionBookmarkStatus { initial, loading, addDone, error, removeDone }

class BookmarkState extends Equatable {
  const BookmarkState({
    this.bookmarks = const <BlogModel>[],
    this.getBookmarkStatus = GetBookmarkStatus.initial,
    this.actionBookmarkStatus = ActionBookmarkStatus.initial,
    this.messageError = '',
  });

  final List<BlogModel> bookmarks;
  final GetBookmarkStatus getBookmarkStatus;
  final ActionBookmarkStatus actionBookmarkStatus;

  final String messageError;

  BookmarkState copyWith({
    List<BlogModel>? bookmarks,
    GetBookmarkStatus? getBookmarkStatus,
    ActionBookmarkStatus? actionBookmarkStatus,
    String? messageError,
  }) {
    return BookmarkState(
      bookmarks: bookmarks ?? this.bookmarks,
      getBookmarkStatus: getBookmarkStatus ?? this.getBookmarkStatus,
      actionBookmarkStatus: actionBookmarkStatus ?? this.actionBookmarkStatus,
      messageError: messageError ?? this.messageError,
    );
  }

  @override
  List<Object?> get props =>
      [bookmarks, getBookmarkStatus, actionBookmarkStatus, messageError];
}
