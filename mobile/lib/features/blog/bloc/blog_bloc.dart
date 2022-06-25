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
        if (state.category != 'Tất cả') {
          emit(
            state.copyWith(
              getBlogStatus: GetBlogStatus.loading,
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
              log(blogs.toString());
              emit(
                state.copyWith(
                  getBlogStatus: GetBlogStatus.done,
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
          getBlogStatus: GetBlogStatus.loading,
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
          log(blogs.toString());
          emit(
            state.copyWith(
              getBlogStatus: GetBlogStatus.done,
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

  Future<void> _onCategoryPressed(
    BlogCategoryPressed event,
    Emitter<BlogState> emit,
  ) async {
    try {
      if (event.catagory == 'Tất cả') {
        emit(
          state.copyWith(
            getBlogStatus: GetBlogStatus.loading,
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
                getBlogStatus: GetBlogStatus.done,
                blogs: blogs,
                filterBlogs: blogs,
              ),
            );
            log(
              state.filterBlogs.length.toString(),
            );
          },
        );
        return;
      }
      emit(
        state.copyWith(
          getBlogStatus: GetBlogStatus.loading,
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
          log(blogs.toString());
          emit(
            state.copyWith(
              getBlogStatus: GetBlogStatus.done,
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
              likeBlogStatus: LikeBlogStatus.done,
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
      )
          .then(
        (blogs) {
          emit(
            state.copyWith(
              getBlogStatus: GetBlogStatus.done,
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
              contentBlogStatus: ContentBlogStatus.done,
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
