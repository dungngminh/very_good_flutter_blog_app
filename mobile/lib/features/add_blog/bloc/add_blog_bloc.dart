import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_blog_event.dart';
part 'add_blog_state.dart';

class AddBlogBloc extends Bloc<AddBlogEvent, AddBlogState> {
  AddBlogBloc() : super(AddBlogInitial()) {
    on<AddBlogEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
