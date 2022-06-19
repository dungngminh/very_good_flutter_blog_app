import 'dart:developer';

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
    on<BlogCardPressed>(_onBlogCardPressed);
    add(const BlogGetBlogs());
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
        limit: event.limit,
      )
          .then(
        (blogs) {
          emit(
            state.copyWith(
              getBlogStatus: GetBlogStatus.idle,
              blogs: blogs,
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

  Future<void> _onBlogCardPressed(
    BlogCardPressed event,
    Emitter<BlogState> emit,
  ) async {
    try {
      
      emit(state.copyWith(contentBlogStatus: ContentBlogStatus.loading));
      await _blogRepository
          .getBlogById(
        event.blogId,
      )
          .then(
        (data) {
          final currentBlogs = state.blogs;
          for (var i = 0; i < currentBlogs.length; i++) {
            if (currentBlogs[i].id == event.blogId) {
              currentBlogs[i] = currentBlogs[i].copyWith(content: data.content);
            }
          }
          emit(
            state.copyWith(
              contentBlogStatus: ContentBlogStatus.idle,
              blogs: currentBlogs,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          contentBlogStatus: ContentBlogStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
