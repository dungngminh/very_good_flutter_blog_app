import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/features/blog/bloc/blog_bloc.dart';
import 'package:very_good_blog_app/features/profile/profile.dart';
import 'package:very_good_blog_app/models/models.dart';
import 'package:very_good_blog_app/widgets/action_bar.dart';

class BlogView extends StatefulWidget {
  const BlogView({
    super.key,
    required this.blog,
  });

  final BlogModel blog;

  @override
  State<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  late QuillController _quillController;

  @override
  void initState() {
    super.initState();
    log(widget.blog.content.toString());
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
              actions: [
                IconButton(
                  icon: Assets.icons.editSquare.svg(
                    color: AppPalette.purple700Color,
                    height: 28,
                  ),
                  splashRadius: 24,
                  onPressed: () => context.push(
                    AppRoute.blogEditor,
                    extra: ExtraParams3<ProfileBloc, BlogBloc, BlogModel>(
                      param1: context.read<ProfileBloc>(),
                      param2: context.read<BlogBloc>(),
                      param3: widget.blog,
                    ),
                  ),
                ),
              ],
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
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  _BlogImage(blog: widget.blog),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Assets.icons.heart.svg(
                            color: AppPalette.pink500Color,
                            height: 24,
                          ),
                          splashRadius: 24,
                          onPressed: () => context
                              .read<BlogBloc>()
                              .add(BlogLikePressed(id: widget.blog.id)),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          '${widget.blog.likeCount}',
                          style: AppTextTheme.regularTextStyle
                              .copyWith(fontSize: 15),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Assets.icons.bookmark.svg(
                            color: AppPalette.purple700Color,
                            height: 24,
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

class _BlogImage extends StatelessWidget {
  const _BlogImage({required this.blog});

  final BlogModel blog;

  @override
  Widget build(BuildContext context) {
    return blog.id != AppContants.previewBlogId
        ? CachedNetworkImage(
            imageUrl: blog.imageUrl,
            imageBuilder: (context, imageProvider) => Hero(
              tag: blog.imageUrl,
              child: Container(
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
