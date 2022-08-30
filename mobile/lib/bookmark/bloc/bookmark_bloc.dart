import 'package:bloc/bloc.dart';
import 'package:bookmark_repository/bookmark_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';
import 'package:very_good_blog_app/app/app.dart';

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
      final bookmarks = await _bookmarkRepository.getBookmarks();
      emit(
        state.copyWith(
          bookmarks: bookmarks,
          getBookmarkStatus: LoadingStatus.done,
        ),
      );
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
      await _bookmarkRepository.addBookmark(event.blog);
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
      await _bookmarkRepository.removeBookmark(event.blog);
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
