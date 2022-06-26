part of 'blog_editor_bloc.dart';

abstract class BlogEditorEvent extends Equatable {
  const BlogEditorEvent();

  @override
  List<Object?> get props => [];
}

class BlogEditorSubmitContent extends BlogEditorEvent {
  const BlogEditorSubmitContent(this.content);

  final String content;

  @override
  List<Object?> get props => [content];
}

class BlogEditorTitleChanged extends BlogEditorEvent {
  const BlogEditorTitleChanged(this.title);

  final String? title;

  @override
  List<Object?> get props => [title];
}

class BlogEditorCategoryChanged extends BlogEditorEvent {
  const BlogEditorCategoryChanged(
    this.category,
  );

  final String? category;

  @override
  List<Object?> get props => [category];
}

class BlogEditorAddImage extends BlogEditorEvent {
  const BlogEditorAddImage({this.imageUrl});

  final String? imageUrl;

  @override
  List<Object?> get props => [imageUrl];
}

class BlogEditorRemoveImage extends BlogEditorEvent {}

class BlogEditorUploadBlog extends BlogEditorEvent {}

class BlogEditorEditExistBlog extends BlogEditorEvent {
  const BlogEditorEditExistBlog({this.existBlog});

  final BlogModel? existBlog;

  @override
  List<Object?> get props => [existBlog];
}
