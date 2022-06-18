import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:go_router/go_router.dart';
import 'package:very_good_blog_app/app/app.dart'
    show ContextExtension, AppPalette, AppRoute, AppTextTheme;
import 'package:very_good_blog_app/widgets/widgets.dart'
    show TapHideKeyboard, ActionBar;

class AddBlogView extends StatefulWidget {
  const AddBlogView({super.key});

  @override
  State<AddBlogView> createState() => _AddBlogViewState();
}

class _AddBlogViewState extends State<AddBlogView> {
  late quill.QuillController _quillController;
  late FocusNode _textEditorFocusNode;

  @override
  void initState() {
    super.initState();
    _quillController = quill.QuillController.basic();
    _textEditorFocusNode = FocusNode();
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
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: context.padding.top + 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ActionBar(
                actions: [
                  InkWell(
                    onTap: () {},
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
                      _textEditorFocusNode.unfocus();
                      context.push('${AppRoute.addBlog}/${AppRoute.postBlog}');
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: quill.QuillToolbar.basic(
                  controller: _quillController,
                  iconTheme: const quill.QuillIconTheme(
                    borderRadius: 40,
                    iconSelectedFillColor: AppPalette.primaryColor,
                  ),
                  showImageButton: false,
                  showCameraButton: false,
                  showVideoButton: false,
                ),
              ),
              Expanded(
                child: quill.QuillEditor(
                  controller: _quillController,
                  autoFocus: true,
                  scrollable: true,
                  onLaunchUrl: (url) {},
                  focusNode: _textEditorFocusNode,
                  scrollController: ScrollController(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  expands: false,
                  readOnly: false,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
