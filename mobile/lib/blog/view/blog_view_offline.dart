import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:models/models.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/widgets/widgets.dart';

class BlogViewOffline extends StatefulWidget {
  const BlogViewOffline({
    super.key,
    required this.blog,
  });

  final BlogModel blog;

  @override
  State<BlogViewOffline> createState() => _BlogViewOfflineState();
}

class _BlogViewOfflineState extends State<BlogViewOffline> {
  late final QuillController _quillController;
  late final ValueNotifier<int> _likeCount;
  late final ScrollController _scrollController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    log(widget.blog.content.toString());
    _quillController = QuillController(
      document: Document.fromJson(jsonDecode(widget.blog.content!) as List),
      selection: const TextSelection.collapsed(offset: 0),
    );

    _likeCount = ValueNotifier(widget.blog.likeCount);
  }

  @override
  void dispose() {
    _likeCount.dispose();
    super.dispose();
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
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 14,
                left: 8,
                right: 8,
              ),
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
                  _BlogImage(blog: widget.blog),
                  const SizedBox(
                    height: 16,
                  ),
                  QuillEditor(
                    scrollController: _scrollController,
                    focusNode: _focusNode,
                    configurations: QuillEditorConfigurations(
                      controller: _quillController,
                      padding: const EdgeInsets.all(16),
                    ),
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
  const _BlogImage({required this.blog});

  final BlogModel blog;

  @override
  Widget build(BuildContext context) {
    return blog.id != AppContants.previewBlogId
        ? CachedNetworkImage(
            imageUrl: blog.imageUrl,
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
        : Container(
            margin: const EdgeInsets.only(top: 16),
            height: context.screenHeight / 3.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: Image.file(
                  File(blog.imageUrl),
                ).image,
                fit: BoxFit.fill,
              ),
            ),
          );
  }
}
