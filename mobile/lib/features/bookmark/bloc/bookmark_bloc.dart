import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    on<BookmartRemoveBlog>(_onRemoveBlog);

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
          getBookmarkStatus: GetBookmarkStatus.loading,
        ),
      );
      final bookmarks = await _bookmarkRepository.getBookmarks();
      emit(
        state.copyWith(
          getBookmarkStatus: GetBookmarkStatus.done,
          bookmarks: bookmarks,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          getBookmarkStatus: GetBookmarkStatus.error,
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
      await _bookmarkRepository.addBookmark(blogId: event.blog.id);
      emit(
        state.copyWith(
          bookmarks: [...state.bookmarks, event.blog],
          actionBookmarkStatus: ActionBookmarkStatus.done,
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
    BookmartRemoveBlog event,
    Emitter<BookmarkState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          actionBookmarkStatus: ActionBookmarkStatus.loading,
        ),
      );
      await _bookmarkRepository.removeBookmark(blogId: event.blog.id);
      final currentBookmark = state.bookmarks..remove(event.blog);
      emit(
        state.copyWith(
          bookmarks: currentBookmark,
          actionBookmarkStatus: ActionBookmarkStatus.done,
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
