import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:models/models.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/widgets/action_bar.dart';

class BlogPreviewView extends StatefulWidget {
  const BlogPreviewView({
    super.key,
    required this.blog,
  });

  final BlogModel blog;

  @override
  State<BlogPreviewView> createState() => _BlogPreviewViewState();
}

class _BlogPreviewViewState extends State<BlogPreviewView> {
  late QuillController _quillController;

  @override
  void initState() {
    super.initState();
    _quillController = QuillController(
      document: Document.fromJson(jsonDecode(widget.blog.content!) as List),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, context.padding.top + 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ActionBar(
              title: widget.blog.title,
              titleFontSize: 20,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 12, bottom: 14, left: 8, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: widget.blog.user.avatarUrl.isEmpty
                            ? Assets.images.blankAvatar.image().image
                            : Image.network(widget.blog.user.avatarUrl).image,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.blog.user.username,
                            style: AppTextTheme.titleTextStyle
                                .copyWith(fontSize: 16),
                          ),
                          Text(
                            timeago.format(
                              widget.blog.createdAt,
                            ),
                            style: AppTextTheme.decriptionTextStyle
                                .copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  _BlogImage(imagePath: widget.blog.imageUrl),
                  QuillEditor(
                    controller: _quillController,
                    autoFocus: false,
                    scrollable: true,
                    focusNode: FocusNode(),
                    scrollController: ScrollController(),
                    padding: EdgeInsets.zero,
                    expands: false,
                    readOnly: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlogImage extends StatelessWidget {
  const _BlogImage({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      height: context.screenHeight / 3.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: Image.file(
            File(imagePath),
          ).image,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
