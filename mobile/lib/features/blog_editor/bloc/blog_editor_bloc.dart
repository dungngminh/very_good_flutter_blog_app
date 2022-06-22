import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:very_good_blog_app/app/config/helpers/image_picker_helper.dart'
    show ImagePickerHelper;
import 'package:very_good_blog_app/features/blog_editor/blog_editor.dart'
    show ImagePath, BlogTitle;
import 'package:very_good_blog_app/models/models.dart';
import 'package:very_good_blog_app/repository/repository.dart'
    show BlogRepository;

part 'blog_editor_event.dart';
part 'blog_editor_state.dart';

class BlogEditorBloc extends Bloc<BlogEditorEvent, BlogEditorState> {
  BlogEditorBloc({required BlogRepository blogRepository})
      : _blogRepository = blogRepository,
        super(const BlogEditorState()) {
    on<BlogEditorTitleChanged>(_onTitleChanged);
    on<BlogEditorAddImage>(_onAddImage);
    on<BlogEditorCategoryChanged>(_onCategoryChanged);
    on<BlogEditorUploadBlog>(_onSubmitBlog);
    on<BlogEditorSubmitContent>(_onSubmitContent);
    on<BlogEditorRemoveImage>(_onRemoveImage);
    on<BlogEditorEditExistBlog>(_onEditExistBlog);
  }

  final BlogRepository _blogRepository;

  void _onRemoveImage(
    BlogEditorRemoveImage event,
    Emitter<BlogEditorState> emit,
  ) {
    const imagePath = ImagePath.dirty();
    emit(
      state.copyWith(
        imagePath: imagePath,
        validationStatus: Formz.validate([
          state.blogTitle,
          imagePath,
        ]),
      ),
    );
  }

  Future<void> _onSubmitBlog(
    BlogEditorUploadBlog event,
    Emitter<BlogEditorState> emit,
  ) async {
    emit(
      state.copyWith(
        uploadStatus: UploadBlogStatus.loading,
      ),
    );
    if (state.existBlog != null) {}
    try {
      if (state.existBlog != null) {
        await _blogRepository
            .updateBlog(
          blog: state.existBlog!,
          title: state.blogTitle.value,
          category: state.category,
          content: state.content,
          imagePath: state.imagePath.value,
        )
            .then((_) {
          emit(
            state.copyWith(uploadStatus: UploadBlogStatus.done),
          );
        });
      } else {
        await _blogRepository
            .addBlog(
          title: state.blogTitle.value,
          category: state.category,
          content: state.content,
          imagePath: state.imagePath.value,
        )
            .then((_) {
          emit(
            state.copyWith(uploadStatus: UploadBlogStatus.done),
          );
        });
      }
    } catch (e) {
      emit(
        state.copyWith(uploadStatus: UploadBlogStatus.error),
      );
    }
  }

  void _onCategoryChanged(
    BlogEditorCategoryChanged event,
    Emitter<BlogEditorState> emit,
  ) {
    final category = event.category!;
    emit(
      state.copyWith(category: category),
    );
  }

  void _onSubmitContent(
    BlogEditorSubmitContent event,
    Emitter<BlogEditorState> emit,
  ) {
    final content = event.content;
    emit(
      state.copyWith(content: content),
    );
  }

  void _onTitleChanged(
    BlogEditorTitleChanged event,
    Emitter<BlogEditorState> emit,
  ) {
    if (event.title == null) {
      return;
    }
    final blogTitle = BlogTitle.dirty(event.title!);
    emit(
      state.copyWith(
        blogTitle: blogTitle,
        validationStatus: Formz.validate([
          blogTitle,
          state.imagePath,
        ]),
      ),
    );
  }

  Future<void> _onAddImage(
    BlogEditorAddImage event,
    Emitter<BlogEditorState> emit,
  ) async {
    if (event.imageUrl != null) {
      final imagePath = ImagePath.dirty(event.imageUrl!);
      emit(
        state.copyWith(
          imagePath: imagePath,
          validationStatus: Formz.validate([
            state.blogTitle,
            imagePath,
          ]),
        ),
      );
      return;
    }
    final imagePickedPath =
        await ImagePickerHelper.pickImageFromSource(ImageSource.gallery);
    if (imagePickedPath != null) {
      final imagePath = ImagePath.dirty(imagePickedPath);
      emit(
        state.copyWith(
          imagePath: imagePath,
          validationStatus: Formz.validate([
            state.blogTitle,
            imagePath,
          ]),
        ),
      );
    }
  }

  void _onEditExistBlog(
    BlogEditorEditExistBlog event,
    Emitter<BlogEditorState> emit,
  ) {
    if (event.existBlog != null) {
      final blogTitle = BlogTitle.dirty(event.existBlog!.title);
      final imagePath = ImagePath.dirty(event.existBlog!.imageUrl);
      final category = event.existBlog!.category;

      emit(
        state.copyWith(
          blogTitle: blogTitle,
          imagePath: imagePath,
          existBlog: event.existBlog,
          category: category,
          validationStatus: Formz.validate([blogTitle, imagePath]),
        ),
      );
    }
  }
}
