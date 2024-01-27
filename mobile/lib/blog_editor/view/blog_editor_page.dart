import 'dart:convert';

import 'package:blog_repository/blog_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/blog/bloc/blog_bloc.dart';
import 'package:very_good_blog_app/blog_editor/blog_editor.dart';
import 'package:very_good_blog_app/profile/bloc/profile_bloc.dart';
import 'package:very_good_blog_app/widgets/widgets.dart';

class BlogEditorPage extends StatelessWidget {
  const BlogEditorPage({super.key, this.blog});

  final BlogModel? blog;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BlogEditorBloc>(
      create: (context) => BlogEditorBloc(
        blogRepository: context.read<BlogRepository>(),
      )..add(BlogEditorEditExistBlog(existBlog: blog)),
      child: _AddBlogView(blog),
    );
  }
}

class _AddBlogView extends StatefulWidget {
  const _AddBlogView(this.blog);

  final BlogModel? blog;

  @override
  State<_AddBlogView> createState() => _AddBlogViewState();
}

class _AddBlogViewState extends State<_AddBlogView> {
  late final QuillController _quillController;
  late final FocusNode _textEditorFocusNode;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    if (widget.blog != null) {
      _quillController = QuillController(
        document: Document.fromJson(jsonDecode(widget.blog!.content!) as List),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _quillController = QuillController.basic();
    }
    _textEditorFocusNode = FocusNode();
    _scrollController = ScrollController();
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
    _textEditorFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissFocusKeyboard(
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
                        '${AppRoutes.blogEditor}/${AppRoutes.uploadBlog}',
                        extra: ExtraParams4<BlogEditorBloc, BlogBloc,
                            ProfileBloc, BlogModel?>(
                          param1: context.read<BlogEditorBloc>(),
                          param2: context.read<BlogBloc>(),
                          param3: context.read<ProfileBloc>(),
                          param4: widget.blog,
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
                child: QuillSimpleToolbar(
                  configurations: QuillSimpleToolbarConfigurations(
                    controller: _quillController,
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(
              //     left: 8,
              //     right: 8,
              //     top: 16,
              //     bottom: 8,
              //   ),
              //   child: QuillToolbar.basic(
              //     controller: _quillController,
              //     iconTheme: const QuillIconTheme(
              //       borderRadius: 40,
              //       iconSelectedFillColor: AppPalette.primaryColor,
              //     ),
              //   ),
              // ),
              Expanded(
                child: ColoredBox(
                  color: AppPalette.whiteBackgroundColor,
                  child: QuillEditor(
                    scrollController: _scrollController,
                    focusNode: _textEditorFocusNode,
                    configurations: QuillEditorConfigurations(
                      controller: _quillController,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
