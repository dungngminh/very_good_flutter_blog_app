part of 'add_blog_bloc.dart';

abstract class AddBlogEvent extends Equatable {
  const AddBlogEvent();

  @override
  List<Object?> get props => [];
}

class AddBlogSubmitContent extends AddBlogEvent {
  const AddBlogSubmitContent(this.content);

  final String content;

  @override
  List<Object?> get props => [content];
}

class AddBlogTitleChanged extends AddBlogEvent {
  const AddBlogTitleChanged(this.title);

  final String title;

  @override
  List<Object?> get props => [title];
}

class AddBlogCategoryChanged extends AddBlogEvent {
  const AddBlogCategoryChanged(
    this.category,
  );

  final String category;

  @override
  List<Object?> get props => [category];
}

class AddBlogAddImage extends AddBlogEvent {}

class AddBlogRemoveImage extends AddBlogEvent{}

class AddBlogUploadBlog extends AddBlogEvent {}
