part of 'bookmark_bloc.dart';


enum ActionBookmarkStatus { initial, loading, addDone, error, removeDone }

class BookmarkState extends Equatable {
  const BookmarkState({
    this.bookmarks = const <BlogModel>[],
    this.getBookmarkStatus = LoadingStatus.done,
    this.actionBookmarkStatus = ActionBookmarkStatus.initial,
    this.messageError = '',
  });

  final List<BlogModel> bookmarks;
  final LoadingStatus getBookmarkStatus;
  final ActionBookmarkStatus actionBookmarkStatus;

  final String messageError;

  BookmarkState copyWith({
    List<BlogModel>? bookmarks,
    LoadingStatus? getBookmarkStatus,
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
