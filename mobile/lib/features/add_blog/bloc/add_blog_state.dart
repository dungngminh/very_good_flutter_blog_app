part of 'add_blog_bloc.dart';

abstract class AddBlogState extends Equatable {
  const AddBlogState();
  
  @override
  List<Object> get props => [];
}

class AddBlogInitial extends AddBlogState {}
