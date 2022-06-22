import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_blog_app/app/app.dart'
    show
        AppPalette,
        AppRoute,
        AppTextTheme,
        Assets,
        ContextExtension,
        ExtraParams3;
import 'package:very_good_blog_app/features/blog/bloc/blog_bloc.dart';
import 'package:very_good_blog_app/features/blog_editor/blog_editor.dart'
    show
        BlogEditorAddImage,
        BlogEditorBloc,
        BlogEditorCategoryChanged,
        BlogEditorRemoveImage,
        BlogEditorState,
        BlogEditorTitleChanged,
        BlogEditorUploadBlog,
        UploadBlogStatus;
import 'package:very_good_blog_app/features/profile/profile.dart'
    show ProfileBloc, ProfileGetUserInformation;
import 'package:very_good_blog_app/models/models.dart' show BlogModel;
import 'package:very_good_blog_app/widgets/widgets.dart';

class UploadBlogView extends StatelessWidget {
  const UploadBlogView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlogEditorBloc, BlogEditorState>(
      listener: (context, state) {
        if (state.uploadStatus == UploadBlogStatus.done) {
          Fluttertoast.showToast(
            msg: state.existBlog == null
                ? 'Đăng bài viết thành công'
                : 'Cập nhật bài viết thành công',
          );
          context
            ..pop()
            ..pop();
          if (state.existBlog != null) context.pop();
          context.read<BlogBloc>().add(const BlogGetBlogs());
          context.read<ProfileBloc>().add(ProfileGetUserInformation());
        } else if (state.uploadStatus == UploadBlogStatus.error) {
          Fluttertoast.showToast(
            msg: state.existBlog == null
                ? 'Đăng bài viết thất bài'
                : 'Cập nhật bài viết thất bại',
          );
        }
      },
      child: TapHideKeyboard(
        child: Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: context.padding.top + 16,
            ),
            child: Column(
              children: [
                Builder(
                  builder: (context) {
                    final validationStatus = context.select(
                      (BlogEditorBloc blogEditorBloc) =>
                          blogEditorBloc.state.validationStatus,
                    );
                    final category = context.select(
                      (BlogEditorBloc blogEditorBloc) =>
                          blogEditorBloc.state.category,
                    );
                    final existBlog = context.select(
                      (BlogEditorBloc blogEditorBloc) =>
                          blogEditorBloc.state.existBlog,
                    );
                    return ActionBar(
                      title: existBlog == null
                          ? 'Đăng bài viết'
                          : 'Cập nhật bài viết',
                      actions: [
                        Visibility(
                          replacement: const Padding(
                            padding: EdgeInsets.all(8),
                            child: SizedBox.square(
                              dimension: 30,
                            ),
                          ),
                          visible: validationStatus.isValid &&
                              category.isNotEmpty &&
                              existBlog == null,
                          child: IconButton(
                            tooltip: 'Bạn có thể xem trước bài viết'
                                ' trước khi đăng',
                            splashRadius: 24,
                            icon: Assets.icons.search.svg(
                              color: AppPalette.deepPurpleColor,
                              height: 28,
                            ),
                            onPressed: () {
                              final title = context
                                  .read<BlogEditorBloc>()
                                  .state
                                  .blogTitle
                                  .value;
                              final content =
                                  context.read<BlogEditorBloc>().state.content;
                              final user =
                                  context.read<ProfileBloc>().state.user;
                              final imagePath = context
                                  .read<BlogEditorBloc>()
                                  .state
                                  .imagePath
                                  .value;
                              final category =
                                  context.read<BlogEditorBloc>().state.category;
                              final previewBlog = BlogModel.preview(
                                title: title,
                                category: category,
                                content: content,
                                imageUrl: imagePath,
                                user: user!,
                                createdAt: DateTime.now(),
                              );

                              context.push(
                                AppRoute.blog,
                                extra: ExtraParams3<BlogModel, ProfileBloc,
                                    BlogBloc>(
                                  param1: previewBlog,
                                  param2: context.read<ProfileBloc>(),
                                  param3: context.read<BlogBloc>(),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    );
                  },
                ),
                const _ImagePlacer(),
                const SizedBox(
                  height: 32,
                ),
                const _BlogInformationForm(),
              ],
            ),
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
      onTap: () =>
          context.read<BlogEditorBloc>().add(const BlogEditorAddImage()),
      child: Center(
        child: Builder(
          builder: (context) {
            final pickedImage = context.select(
              (BlogEditorBloc blogEditorBlog) =>
                  blogEditorBlog.state.imagePath.value,
            );
            if (pickedImage.isEmpty) {
              return _buildImagePlaceHoder();
            }
            final isImageUploaded = pickedImage.contains('firebasestorage');
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
                      image: isImageUploaded
                          ? Image.network(pickedImage).image
                          : Image.file(File(pickedImage)).image,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 8,
                  child: InkEffectIconButton(
                    onPressed: () => context
                        .read<BlogEditorBloc>()
                        .add(BlogEditorRemoveImage()),
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
          (BlogEditorBloc blogEditorBlog) => blogEditorBlog.state.blogTitle,
        );
        return TextFieldDecoration(
          fieldColor: AppPalette.whiteBackgroundColor,
          margin: const EdgeInsets.fromLTRB(8, 10, 8, 0),
          child: TextFormField(
            key: const Key('blogInformationForm_titleBlogInput_textField'),
            onChanged: (title) => context.read<BlogEditorBloc>().add(
                  BlogEditorTitleChanged(title),
                ),
            initialValue: blogTitle.value.isNotEmpty ? blogTitle.value : null,
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
      child: Builder(
        builder: (context) {
          final category = context.select(
            (BlogEditorBloc blogEditorBlog) => blogEditorBlog.state.category,
          );
          return DropdownButtonFormField<String>(
            key: const Key('blogInformationForm_categoryDowndown_fromField'),
            items: categories
                .map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  ),
                )
                .toList(),
            value: category.isNotEmpty ? category : null,
            onChanged: (category) => context.read<BlogEditorBloc>().add(
                  BlogEditorCategoryChanged(category!),
                ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 16, right: 16),
              border: InputBorder.none,
              hintText: 'Chọn thể loại',
            ),
          );
        },
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
            (BlogEditorBloc blogEditorBlog) =>
                blogEditorBlog.state.validationStatus,
          );
          final category = context.select(
            (BlogEditorBloc blogEditorBlog) => blogEditorBlog.state.category,
          );
          final uploadStatus = context.select(
            (BlogEditorBloc blogEditorBloc) =>
                blogEditorBloc.state.uploadStatus,
          );
          return uploadStatus == UploadBlogStatus.loading
              ? const CircularProgressIndicator(
                  color: AppPalette.primaryColor,
                )
              : ElevatedButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  onPressed: validationStatus.isValidated && category.isNotEmpty
                      ? () {
                          context.read<BlogEditorBloc>().add(
                                BlogEditorUploadBlog(),
                              );
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
