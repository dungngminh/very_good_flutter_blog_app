part of 'blog_editor_bloc.dart';

class BlogEditorState extends Equatable {
  const BlogEditorState({
    this.uploadStatus = LoadingStatus.done,
    this.blogTitle = const BlogTitle.isPure(),
    this.content = '',
    this.imagePath = const ImagePath.isPure(),
    this.category = '',
    this.existBlog,
    this.isValid = false,
  });

  final LoadingStatus uploadStatus;
  final BlogTitle blogTitle;
  final String content;
  final ImagePath imagePath;
  final String category;
  final BlogModel? existBlog;
  final bool isValid;

  BlogEditorState copyWith({
    LoadingStatus? uploadStatus,
    BlogTitle? blogTitle,
    String? content,
    ImagePath? imagePath,
    String? category,
    BlogModel? existBlog,
    bool? isValid,
  }) {
    return BlogEditorState(
      uploadStatus: uploadStatus ?? this.uploadStatus,
      blogTitle: blogTitle ?? this.blogTitle,
      content: content ?? this.content,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      existBlog: existBlog ?? this.existBlog,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props {
    return [
      uploadStatus,
      blogTitle,
      content,
      imagePath,
      category,
      existBlog,
      isValid,
    ];
  }
}
