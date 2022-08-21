import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/blog/bloc/blog_bloc.dart';
import 'package:very_good_blog_app/blog_editor/blog_editor.dart';
import 'package:very_good_blog_app/l10n/l10n.dart';
import 'package:very_good_blog_app/models/models.dart';
import 'package:very_good_blog_app/profile/profile.dart';
import 'package:very_good_blog_app/widgets/widgets.dart';

class UploadBlogView extends StatelessWidget {
  const UploadBlogView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<BlogEditorBloc, BlogEditorState>(
      listener: (context, state) {
        if (state.uploadStatus == LoadingStatus.done) {
          Fluttertoast.showToast(
            msg: state.existBlog == null
                ? l10n.createBlogSuccessfully
                : l10n.updateBlogSuccessfully,
          );
          Future.delayed(const Duration(milliseconds: 300), () {
            context
              ..pop()
              ..pop();
            if (state.existBlog != null) context.pop();
          });

          context.read<BlogBloc>().add(const BlogGetBlogs());
          context.read<ProfileBloc>().add(ProfileGetUserInformation());
        } else if (state.uploadStatus == LoadingStatus.error) {
          Fluttertoast.showToast(
            msg: state.existBlog == null
                ? l10n.createBlogFailed
                : l10n.updateBlogFailed,
          );
        }
      },
      child: DismissFocusKeyboard(
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
                      title:
                          existBlog == null ? l10n.updateBlog : l10n.updateBlog,
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
                            tooltip: l10n.previewTooltip,
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
                                '${context.currentLocation}/${AppRoutes.previewBlog}',
                                extra: previewBlog,
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
    final l10n = context.l10n;
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
              return _buildImagePlaceHoder(l10n);
            }
            final isImageUploaded = pickedImage.contains('firebasestorage');
            return Stack(
              alignment: Alignment.topRight,
              children: [
                if (isImageUploaded)
                  CachedNetworkImage(
                    imageUrl: pickedImage,
                    imageBuilder: (context, imageProvider) => Container(
                      height: context.screenHeight / 3.8,
                      margin: const EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    progressIndicatorBuilder: (context, url, progress) =>
                        Shimmer.fromColors(
                      baseColor: AppPalette.shimmerBaseColor,
                      highlightColor: AppPalette.shimmerHighlightColor,
                      child: Container(
                        margin: const EdgeInsets.only(top: 16),
                        height: context.screenHeight / 3.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppPalette.whiteBackgroundColor,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: context.screenHeight / 3.8,
                      margin: const EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: Assets.images.blankImage.image().image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    cacheManager: AppCacheManager.customCacheManager,
                  )
                else
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

  Widget _buildImagePlaceHoder(AppLocalizations l10n) {
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
            l10n.addPicture,
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
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleOfTextField(
          l10n.titleBlog,
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        const _TitleBlogInput(),
        const SizedBox(
          height: 32,
        ),
        TitleOfTextField(
          l10n.category('other'),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        const _CategoryDropdownField(),
        const SizedBox(
          height: 48,
        ),
        const _UploadButton(),
      ],
    );
  }
}

class _TitleBlogInput extends StatelessWidget {
  const _TitleBlogInput();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
              hintText: l10n.titleBlogFieldHint,
              errorText: blogTitle.invalid ? l10n.titleBlogEmpty : null,
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
    final l10n = context.l10n;
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
                  BlogEditorCategoryChanged(category),
                ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 16, right: 16),
              border: InputBorder.none,
              hintText: l10n.chooseCategory,
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
    final l10n = context.l10n;

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
          final existBlog = context.select(
            (BlogEditorBloc blogEditorBloc) => blogEditorBloc.state.existBlog,
          );
          return uploadStatus == LoadingStatus.loading
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
                    fixedSize: Size(existBlog == null ? 130 : 160, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    primary: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    existBlog == null ? l10n.uploadBlog : l10n.updateBlog,
                    style: const TextStyle(
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
