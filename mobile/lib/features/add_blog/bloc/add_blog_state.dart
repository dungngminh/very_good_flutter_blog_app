part of 'add_blog_bloc.dart';

enum UploadBlogStatus { idle, loading, error }

class AddBlogState extends Equatable {
  const AddBlogState({
    this.validationStatus = FormzStatus.pure,
    this.uploadStatus = UploadBlogStatus.idle,
    this.blogTitle = const BlogTitle.pure(),
    this.content = '',
    this.imagePath = const ImagePath.pure(),
    this.category = '',
  });

  final FormzStatus validationStatus;
  final UploadBlogStatus uploadStatus;
  final BlogTitle blogTitle;
  final String content;
  final ImagePath imagePath;
  final String category;

  AddBlogState copyWith({
    FormzStatus? validationStatus,
    UploadBlogStatus? uploadStatus,
    BlogTitle? blogTitle,
    String? content,
    ImagePath? imagePath,
    String? category,
  }) {
    return AddBlogState(
      validationStatus: validationStatus ?? this.validationStatus,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      blogTitle: blogTitle ?? this.blogTitle,
      content: content ?? this.content,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
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
