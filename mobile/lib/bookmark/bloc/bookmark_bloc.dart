import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/models/models.dart';
import 'package:very_good_blog_app/repository/repository.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  BookmarkBloc({required BookmarkRepository bookmarkRepository})
      : _bookmarkRepository = bookmarkRepository,
        super(const BookmarkState()) {
    on<BookmarkFetching>(_onGetBookmarks);
    on<BookmarkAddBlog>(_onAddBlog);
    on<BookmarkRemoveBlog>(_onRemoveBlog);

    add(BookmarkFetching());
  }

  final BookmarkRepository _bookmarkRepository;

  Future<void> _onGetBookmarks(
    BookmarkFetching event,
    Emitter<BookmarkState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          getBookmarkStatus: LoadingStatus.loading,
        ),
      );
      final isHasNetwork = await ConnectivityHelper.isInternetOnline();
      if (isHasNetwork) {
        final bookmarks = await _bookmarkRepository.getBookmarks();
        final bookmarksInLocal = _bookmarkRepository.getBookmarksInLocalBox();
        if (bookmarks != bookmarksInLocal) {
          for (final blog in bookmarks) {
            final isExist = bookmarksInLocal.any((e) => blog.id == e.id);
            if (isExist) continue;
            await _bookmarkRepository.addBookmarkToLocal(blog: blog);
          }
        }
        emit(
          state.copyWith(
            getBookmarkStatus: LoadingStatus.done,
            bookmarks: bookmarks,
          ),
        );
      } else {
        final bookmarksInLocal = _bookmarkRepository.getBookmarksInLocalBox();
        emit(
          state.copyWith(
            getBookmarkStatus: LoadingStatus.done,
            bookmarks: bookmarksInLocal,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          getBookmarkStatus: LoadingStatus.error,
          messageError: e.toString(),
        ),
      );
      rethrow;
    }
  }

  Future<void> _onAddBlog(
    BookmarkAddBlog event,
    Emitter<BookmarkState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          actionBookmarkStatus: ActionBookmarkStatus.loading,
        ),
      );
      await _bookmarkRepository.addBookmark(blog: event.blog);
      emit(
        state.copyWith(
          bookmarks: [...state.bookmarks, event.blog],
          actionBookmarkStatus: ActionBookmarkStatus.addDone,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          actionBookmarkStatus: ActionBookmarkStatus.error,
          messageError: e.toString(),
        ),
      );
      rethrow;
    }
  }

  Future<void> _onRemoveBlog(
    BookmarkRemoveBlog event,
    Emitter<BookmarkState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          actionBookmarkStatus: ActionBookmarkStatus.loading,
        ),
      );
      await _bookmarkRepository.removeBookmark(blog: event.blog);
      emit(
        state.copyWith(
          bookmarks: state.bookmarks
              .where((bookmark) => bookmark.id != event.blog.id)
              .toList(),
          actionBookmarkStatus: ActionBookmarkStatus.removeDone,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          actionBookmarkStatus: ActionBookmarkStatus.error,
          messageError: e.toString(),
        ),
      );
      rethrow;
    }
  }
}
