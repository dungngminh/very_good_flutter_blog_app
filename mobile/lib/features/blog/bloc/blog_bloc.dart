import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:very_good_blog_app/models/models.dart';
import 'package:very_good_blog_app/repository/repository.dart'
    show BlogRepository;

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  BlogBloc({required BlogRepository blogRepository})
      : _blogRepository = blogRepository,
        super(const BlogState()) {
    on<BlogGetBlogs>(_onGetBlogs);
    on<BlogLikePressed>(_onLikePressed);
  }

  final BlogRepository _blogRepository;

  Future<void> _onLikePressed(
    BlogLikePressed event,
    Emitter<BlogState> emit,
  ) async {
    try {
      emit(state.copyWith(likeBlogStatus: LikeBlogStatus.loading));
      await _blogRepository
          .likeBlog(
        event.id,
      )
          .then(
        (_) {
          emit(
            state.copyWith(
              likeBlogStatus: LikeBlogStatus.idle,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          getBlogStatus: GetBlogStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onGetBlogs(BlogGetBlogs event, Emitter<BlogState> emit) async {
    try {
      emit(state.copyWith(getBlogStatus: GetBlogStatus.loading));
      await _blogRepository
          .getBlogs(
        page: event.page,
        offset: event.offset,
      )
          .then(
        (blogs) {
          emit(
            state.copyWith(
              getBlogStatus: GetBlogStatus.idle,
              blogs: blogs.toSet(),
              filterBlogs: blogs,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          getBlogStatus: GetBlogStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
