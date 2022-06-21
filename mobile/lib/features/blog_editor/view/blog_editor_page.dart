import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:go_router/go_router.dart';
import 'package:very_good_blog_app/app/app.dart'
    show ContextExtension, AppPalette, AppRoute, AppTextTheme, ExtraParams3;
import 'package:very_good_blog_app/features/blog/bloc/blog_bloc.dart';
import 'package:very_good_blog_app/features/blog_editor/blog_editor.dart'
    show BlogEditorBloc, BlogEditorSubmitContent;
import 'package:very_good_blog_app/features/profile/bloc/profile_bloc.dart';
import 'package:very_good_blog_app/models/models.dart' show BlogModel;
import 'package:very_good_blog_app/repository/blog_repository.dart';
import 'package:very_good_blog_app/widgets/widgets.dart'
    show TapHideKeyboard, ActionBar;

// TODO(dungngminh): handle edit blog
class BlogEditorPage extends StatelessWidget {
  const BlogEditorPage({super.key, this.blog});

  final BlogModel? blog;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BlogEditorBloc>(
      create: (context) => BlogEditorBloc(
        blogRepository: context.read<BlogRepository>(),
      ),
      child: const _AddBlogView(),
    );
  }
}

class _AddBlogView extends StatefulWidget {
  const _AddBlogView();

  @override
  State<_AddBlogView> createState() => _AddBlogViewState();
}

class _AddBlogViewState extends State<_AddBlogView> {
  late QuillController _quillController;
  late FocusNode _textEditorFocusNode;

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
    _textEditorFocusNode = FocusNode();
  }

  String get editorContent {
    _quillController.document.toDelta();
    final content = jsonEncode(
      _quillController.document.toDelta().toJson(),
    );
    return content;
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TapHideKeyboard(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: context.padding.top + 16,
            bottom: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ActionBar(
                actions: [
                  InkWell(
                    onTap: () {
                      _quillController.clear();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Nháp',
                        style: AppTextTheme.decriptionTextStyle
                            .copyWith(fontSize: 16),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (_quillController.document.isEmpty()) {
                        return;
                      }
                      context
                          .read<BlogEditorBloc>()
                          .add(BlogEditorSubmitContent(editorContent));
                      context.push(
                        '${AppRoute.blogEditor}/${AppRoute.uploadBlog}',
                        extra:
                            ExtraParams3<BlogEditorBloc, BlogBloc, ProfileBloc>(
                          param1: context.read<BlogEditorBloc>(),
                          param2: context.read<BlogBloc>(),
                          param3: context.read<ProfileBloc>(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Tiếp tục',
                        style: AppTextTheme.darkW700TextStyle
                            .copyWith(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                  top: 16,
                  bottom: 8,
                ),
                child: QuillToolbar.basic(
                  controller: _quillController,
                  iconTheme: const QuillIconTheme(
                    borderRadius: 40,
                    iconSelectedFillColor: AppPalette.primaryColor,
                  ),
                  showImageButton: false,
                  showCameraButton: false,
                  showVideoButton: false,
                ),
              ),
              Expanded(
                child: ColoredBox(
                  color: AppPalette.whiteBackgroundColor,
                  child: QuillEditor(
                    controller: _quillController,
                    autoFocus: false,
                    scrollable: true,
                    focusNode: _textEditorFocusNode,
                    scrollController: ScrollController(),
                    padding: const EdgeInsets.all(16),
                    expands: false,
                    readOnly: false,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
