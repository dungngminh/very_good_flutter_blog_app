part of 'blog_editor_bloc.dart';


class BlogEditorState extends Equatable {
  const BlogEditorState({
    this.validationStatus = FormzStatus.pure,
    this.uploadStatus = LoadingStatus.done,
    this.blogTitle = const BlogTitle.pure(),
    this.content = '',
    this.imagePath = const ImagePath.pure(),
    this.category = '',
    this.existBlog,
  });

  final FormzStatus validationStatus;
  final LoadingStatus uploadStatus;
  final BlogTitle blogTitle;
  final String content;
  final ImagePath imagePath;
  final String category;
  final BlogModel? existBlog;

  BlogEditorState copyWith({
    FormzStatus? validationStatus,
    LoadingStatus? uploadStatus,
    BlogTitle? blogTitle,
    String? content,
    ImagePath? imagePath,
    String? category,
    BlogModel? existBlog,
  }) {
    return BlogEditorState(
      validationStatus: validationStatus ?? this.validationStatus,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      blogTitle: blogTitle ?? this.blogTitle,
      content: content ?? this.content,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      existBlog: existBlog ?? this.existBlog,
    );
  }

  @override
  List<Object?> get props {
    return [
      validationStatus,
      blogTitle,
      uploadStatus,
      content,
      imagePath,
      category,
    ];
  }
}
