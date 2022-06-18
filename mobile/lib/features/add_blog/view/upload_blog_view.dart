import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:very_good_blog_app/app/app.dart'
    show AppPalette, AppTextTheme, Assets, ContextExtension;
import 'package:very_good_blog_app/features/add_blog/add_blog.dart'
    show
        AddBlogAddImage,
        AddBlogBloc,
        AddBlogCategoryChanged,
        AddBlogRemoveImage,
        AddBlogTitleChanged,
        AddBlogUploadBlog;
import 'package:very_good_blog_app/widgets/widgets.dart';

class UploadBlogView extends StatelessWidget {
  const UploadBlogView({super.key});

  @override
  Widget build(BuildContext context) {
    return TapHideKeyboard(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: context.padding.top + 8,
          ),
          child: Column(
            children: const [
              ActionBar(),
              _ImagePlacer(),
              SizedBox(
                height: 32,
              ),
              _BlogInformationForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePlacer extends StatelessWidget {
  const _ImagePlacer();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<AddBlogBloc>().add(AddBlogAddImage()),
      child: Center(
        child: Builder(
          builder: (context) {
            final pickedImage = context.select(
              (AddBlogBloc addBlogBloc) => addBlogBloc.state.imagePath.value,
            );
            if (pickedImage.isEmpty) {
              return _buildImagePlaceHoder();
            }
            return Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  height: 190,
                  width: context.screenWidth,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: Image.file(File(pickedImage)).image,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 8,
                  child: InkEffectIconButton(
                    onPressed: () =>
                        context.read<AddBlogBloc>().add(AddBlogRemoveImage()),
                    child: Assets.icons.closeSquare.svg(
                      height: 32,
                      color: AppPalette.red300Color,
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildImagePlaceHoder() {
    return Container(
      height: 190,
      width: 150,
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppPalette.whiteBackgroundColor,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Assets.icons.plusBorder.svg(
              color: AppPalette.primaryColor,
              height: 32,
            ),
          ),
          Text(
            'Thêm ảnh',
            style: AppTextTheme.regularTextStyle.copyWith(fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _BlogInformationForm extends StatelessWidget {
  const _BlogInformationForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        TitleOfTextField(
          'Tiêu đề',
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
        _TitleBlogInput(),
        SizedBox(
          height: 32,
        ),
        TitleOfTextField(
          'Thể loại',
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
        _CategoryDropdownField(),
        SizedBox(
          height: 48,
        ),
        _UploadButton(),
      ],
    );
  }
}

class _TitleBlogInput extends StatelessWidget {
  const _TitleBlogInput();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final blogTitle = context.select(
          (AddBlogBloc addBlogBloc) => addBlogBloc.state.blogTitle,
        );
        return TextFieldDecoration(
          fieldColor: AppPalette.whiteBackgroundColor,
          margin: const EdgeInsets.fromLTRB(8, 10, 8, 0),
          child: TextField(
            key: const Key('blogInformationForm_titleBlogInput_textField'),
            onChanged: (title) => context.read<AddBlogBloc>().add(
                  AddBlogTitleChanged(title),
                ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 16, right: 16),
              border: InputBorder.none,
              hintText: 'Nhập vào tiêu đề blog của bạn',
              errorText:
                  blogTitle.invalid ? 'Tiêu đề không được để trống' : null,
            ),
            textInputAction: TextInputAction.next,
          ),
        );
      },
    );
  }
}

class _CategoryDropdownField extends StatelessWidget {
  const _CategoryDropdownField();

  @override
  Widget build(BuildContext context) {
    final categories = <String>['Đời sống', 'Khoa học', 'Du lịch', 'Ẩm thực'];
    return TextFieldDecoration(
      fieldColor: AppPalette.whiteBackgroundColor,
      margin: const EdgeInsets.fromLTRB(8, 10, 8, 0),
      child: DropdownButtonFormField<String>(
        key: const Key('blogInformationForm_categoryDowndown_fromField'),
        items: categories
            .map(
              (category) => DropdownMenuItem(
                value: category,
                child: Text(category),
              ),
            )
            .toList(),
        onChanged: (category) => context.read<AddBlogBloc>().add(
              AddBlogCategoryChanged(category!),
            ),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 16, right: 16),
          border: InputBorder.none,
          hintText: 'Chọn thể loại',
        ),
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  const _UploadButton();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Builder(
        builder: (context) {
          final validationStatus = context.select(
            (AddBlogBloc addBlogBloc) => addBlogBloc.state.validationStatus,
          );
          return validationStatus.isSubmissionInProgress
              ? const CircularProgressIndicator(
                  color: AppPalette.primaryColor,
                )
              : ElevatedButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  onPressed: validationStatus.isValidated
                      ? () {
                          context.read<AddBlogBloc>().add(AddBlogUploadBlog());
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(130, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    primary: Theme.of(context).primaryColor,
                  ),
                  child: const Text(
                    'Đăng bài viết',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppPalette.whiteBackgroundColor,
                    ),
                  ),
                );
        },
      ),
    );
  }
}
