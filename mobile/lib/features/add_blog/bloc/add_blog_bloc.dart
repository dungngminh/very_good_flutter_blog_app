import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:very_good_blog_app/app/config/helpers/image_picker_helper.dart';
import 'package:very_good_blog_app/features/add_blog/add_blog.dart';
import 'package:very_good_blog_app/repository/blog_repository.dart';

part 'add_blog_event.dart';
part 'add_blog_state.dart';

class AddBlogBloc extends Bloc<AddBlogEvent, AddBlogState> {
  AddBlogBloc({required BlogRepository blogRepository})
      : _blogRepository = blogRepository,
        super(const AddBlogState()) {
    on<AddBlogTitleChanged>(_onTitleChanged);
    on<AddBlogAddImage>(_onAddImage);
    on<AddBlogCategoryChanged>(_onCategoryChanged);
    on<AddBlogUploadBlog>(_onPostBlog);
    on<AddBlogSubmitContent>(_onSubmitContent);
    on<AddBlogRemoveImage>(_onRemoveImage);
  }

  final BlogRepository _blogRepository;

  void _onRemoveImage(AddBlogRemoveImage event, Emitter<AddBlogState> emit) {
    const imagePath = ImagePath.pure();
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

  Future<void> _onPostBlog(
    AddBlogUploadBlog event,
    Emitter<AddBlogState> emit,
  ) async {
    emit(
      state.copyWith(
        uploadStatus: UploadBlogStatus.loading,
      ),
    );
    try {
      await _blogRepository
          .addBlog(
        title: state.blogTitle.value,
        category: state.category,
        content: state.content,
        imagePath: state.imagePath.value,
      )
          .then((_) {
        emit(
          state.copyWith(
            uploadStatus: UploadBlogStatus.idle,
          ),
        );
      });
    } catch (e) {
      emit(
        state.copyWith(
          uploadStatus: UploadBlogStatus.error,
        ),
      );
    }
  }

  void _onCategoryChanged(
    AddBlogCategoryChanged event,
    Emitter<AddBlogState> emit,
  ) {
    final category = event.category;
    emit(
      state.copyWith(
        blogTitle: state.blogTitle,
        imagePath: state.imagePath,
        category: category,
        validationStatus: Formz.validate([
          state.blogTitle,
          state.imagePath,
        ]),
      ),
    );
  }

  void _onSubmitContent(
    AddBlogSubmitContent event,
    Emitter<AddBlogState> emit,
  ) {
    final content = event.content;
    emit(
      state.copyWith(
        content: content,
      ),
    );
  }

  void _onTitleChanged(
    AddBlogTitleChanged event,
    Emitter<AddBlogState> emit,
  ) {
    final blogTitle = BlogTitle.dirty(event.title);
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
    AddBlogAddImage event,
    Emitter<AddBlogState> emit,
  ) async {
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
}
