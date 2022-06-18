import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:go_router/go_router.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/models/models.dart';

class BlogView extends StatefulWidget {
  const BlogView({
    super.key,
    required this.blog,
  });

  final Blog blog;

  @override
  State<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
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
        padding: EdgeInsets.fromLTRB(16, context.padding.top + 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Assets.icons.circleArrowLeft.svg(
                  color: AppPalette.primaryColor,
                  height: 36,
                ),
                splashRadius: 24,
                onPressed: () => context.pop(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: widget.blog.user.avatarUrl != null
                            ? Image.network(widget.blog.user.avatarUrl!).image
                            : Assets.images.komkat.image().image,
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
                            '20 phút trước',
                            style: AppTextTheme.decriptionTextStyle
                                .copyWith(fontSize: 14),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    widget.blog.title,
                    style: AppTextTheme.titleTextStyle.copyWith(fontSize: 19),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    height: context.screenHeight / 3.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: widget.blog.id != 'preview'
                            ? Image.network(
                                'https://miro.medium.com/max/1400/1*yuiVVfFOuPnrsHcUx7xf_Q.png',
                              ).image
                            : Image.file(
                                File(widget.blog.imageUrl),
                              ).image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: widget.blog.id != 'preview'
                        ? EdgeInsets.zero
                        : const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Assets.icons.heart.svg(
                          color: AppPalette.pink500Color,
                          height: 24,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          '${widget.blog.likeCount}',
                          style: AppTextTheme.regularTextStyle,
                        ),
                        const Spacer(),
                        if (widget.blog.id != 'preview')
                          IconButton(
                            icon: Assets.icons.bookmark.svg(
                              color: AppPalette.purple700Color,
                              height: 20,
                            ),
                            splashRadius: 24,
                            onPressed: () {},
                          )
                      ],
                    ),
                  ),
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
