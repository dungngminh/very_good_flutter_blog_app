import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';
import 'package:very_good_blog_app/app/app.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  BlogBloc({required BlogRepository blogRepository})
      : _blogRepository = blogRepository,
        super(const BlogState()) {
    on<BlogGetBlogs>(_onGetBlogs);
    on<BlogLikePressed>(_onLikePressed);
    on<BlogUnlikePressed>(_onUnlikePressed);
    on<BlogCategoryPressed>(_onCategoryPressed);
    on<BlogSearchChanged>(_onSearchChanged);
    add(const BlogGetBlogs());
  }

  final BlogRepository _blogRepository;

  Future<void> _onSearchChanged(
    BlogSearchChanged event,
    Emitter<BlogState> emit,
  ) async {
    try {
      if (event.value.isEmpty) {
        if (state.category != 'all') {
          emit(
            state.copyWith(
              getBlogStatus: LoadingStatus.loading,
              isSearching: false,
            ),
          );
          await _blogRepository
              .getBlogsByCategory(
            state.category,
            page: event.page,
          )
              .then(
            (blogs) {
              emit(
                state.copyWith(
                  getBlogStatus: LoadingStatus.done,
                  filterBlogs: blogs,
                ),
              );
            },
          );
          return;
        }
        emit(
          state.copyWith(
            isSearching: false,
            filterBlogs: state.blogs,
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          getBlogStatus: LoadingStatus.loading,
          isSearching: true,
        ),
      );
      await _blogRepository
          .searchBlogs(
        event.value,
        page: event.page,
      )
          .then(
        (blogs) {
          emit(
            state.copyWith(
              getBlogStatus: LoadingStatus.done,
              filterBlogs: blogs,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          getBlogStatus: LoadingStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCategoryPressed(
    BlogCategoryPressed event,
    Emitter<BlogState> emit,
  ) async {
    try {
      if (event.catagory == 'all') {
        emit(
          state.copyWith(
            getBlogStatus: LoadingStatus.loading,
            category: event.catagory,
          ),
        );
        await _blogRepository
            .getBlogs(
          page: event.page,
        )
            .then(
          (blogs) {
            emit(
              state.copyWith(
                getBlogStatus: LoadingStatus.done,
                blogs: blogs,
                filterBlogs: blogs,
              ),
            );
          },
        );
        return;
      }
      emit(
        state.copyWith(
          getBlogStatus: LoadingStatus.loading,
          category: event.catagory,
        ),
      );
      await _blogRepository
          .getBlogsByCategory(
        event.catagory,
        page: event.page,
      )
          .then(
        (blogs) {
          emit(
            state.copyWith(
              getBlogStatus: LoadingStatus.done,
              filterBlogs: blogs,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          getBlogStatus: LoadingStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLikePressed(
    BlogLikePressed event,
    Emitter<BlogState> emit,
  ) async {
    try {
      emit(state.copyWith(likeBlogStatus: LoadingStatus.loading));
      await _blogRepository
          .likeBlog(
        event.id,
      )
          .then(
        (_) {
          emit(
            state.copyWith(
              likeBlogStatus: LoadingStatus.done,
            ),
          );
          add(const BlogGetBlogs());
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          likeBlogStatus: LoadingStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUnlikePressed(
    BlogUnlikePressed event,
    Emitter<BlogState> emit,
  ) async {
    try {
      emit(state.copyWith(likeBlogStatus: LoadingStatus.loading));
      await _blogRepository
          .unlikeBlog(
        event.id,
      )
          .then(
        (_) {
          emit(
            state.copyWith(
              likeBlogStatus: LoadingStatus.done,
            ),
          );
          add(const BlogGetBlogs());
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          likeBlogStatus: LoadingStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onGetBlogs(BlogGetBlogs event, Emitter<BlogState> emit) async {
    try {
      emit(state.copyWith(getBlogStatus: LoadingStatus.loading));
      await _blogRepository
          .getBlogs(
        page: event.page,
      )
          .then(
        (blogs) {
          emit(
            state.copyWith(
              getBlogStatus: LoadingStatus.done,
              blogs: blogs,
              filterBlogs: blogs,
            ),
          );
          if (state.popularBlogs.length <= 4) {
            state.copyWith(
              popularBlogs: blogs,
            );
          }
          log(
            state.filterBlogs.length.toString(),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          getBlogStatus: LoadingStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
