import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/blog/blog.dart';
import 'package:very_good_blog_app/bookmark/book_mark.dart';
import 'package:very_good_blog_app/profile/profile.dart';
import 'package:very_good_blog_app/widgets/widgets.dart';

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
  late ValueNotifier<bool> _liked;
  late ValueNotifier<int> _likeCount;

  @override
  void initState() {
    super.initState();
    log(widget.blog.content.toString());
    _quillController = QuillController(
      document: Document.fromJson(jsonDecode(widget.blog.content!) as List),
      selection: const TextSelection.collapsed(offset: 0),
    );
    if (context
        .read<ProfileBloc>()
        .state
        .userLikedBlogs
        .any((likedBlog) => likedBlog == widget.blog.id)) {
      _liked = ValueNotifier(true);
    } else {
      _liked = ValueNotifier(false);
    }
    _likeCount = ValueNotifier(widget.blog.likeCount);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlogBloc, BlogState>(
      listenWhen: (previous, current) =>
          previous.likeBlogStatus != current.likeBlogStatus,
      listener: (context, state) {
        if (state.likeBlogStatus == LikeBlogStatus.done) {
          if (_likeCount.value > widget.blog.likeCount) {
            Fluttertoast.cancel();
            Fluttertoast.showToast(msg: 'Đã thích bài viết');
          } else {
            Fluttertoast.cancel();
            Fluttertoast.showToast(msg: 'Đã bỏ thích bài viết');
          }
          context.read<ProfileBloc>().add(ProfileGetLikedBlogs());
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, context.padding.top + 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Builder(
                builder: (context) {
                  final user = context.read<ProfileBloc>().state.user;
                  return ActionBar(
                    title: widget.blog.title,
                    titleFontSize: 20,
                    actions: widget.blog.user == user!
                        ? [
                            IconButton(
                              icon: Assets.icons.editSquare.svg(
                                color: AppPalette.purple700Color,
                                height: 28,
                              ),
                              splashRadius: 24,
                              onPressed: () => context.push(
                                AppRoutes.blogEditor,
                                extra: ExtraParams3<ProfileBloc, BlogBloc,
                                    BlogModel>(
                                  param1: context.read<ProfileBloc>(),
                                  param2: context.read<BlogBloc>(),
                                  param3: widget.blog,
                                ),
                              ),
                            ),
                          ]
                        : null,
                  );
                },
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
                          Builder(
                            builder: (context) {
                              final likedBlogs = context
                                  .watch<ProfileBloc>()
                                  .state
                                  .userLikedBlogs;
                              final isLiked = likedBlogs.any(
                                (likedBlog) => widget.blog.id == likedBlog,
                              );
                              return IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: Assets.icons.heart.svg(
                                  color: isLiked
                                      ? AppPalette.pink500Color
                                      : AppPalette.unSelectedColor,
                                  height: 24,
                                ),
                                splashRadius: 24,
                                onPressed: isLiked
                                    ? () {
                                        context.read<BlogBloc>().add(
                                              BlogUnlikePressed(
                                                id: widget.blog.id,
                                              ),
                                            );

                                        _likeCount.value--;
                                      }
                                    : () {
                                        context.read<BlogBloc>().add(
                                              BlogLikePressed(
                                                id: widget.blog.id,
                                              ),
                                            );

                                        _likeCount.value++;
                                      },
                              );
                            },
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          ValueListenableBuilder(
                            valueListenable: _likeCount,
                            builder: (context, index, child) {
                              return Text(
                                '$index',
                                style: AppTextTheme.regularTextStyle
                                    .copyWith(fontSize: 15),
                              );
                            },
                          ),
                          const Spacer(),
                          Builder(
                            builder: (context) {
                              final bookmarks =
                                  context.watch<BookmarkBloc>().state.bookmarks;
                              final isInUserBookmark = bookmarks.any(
                                (bookmark) => bookmark.id == widget.blog.id,
                              );
                              return InkEffectIconButton(
                                onPressed: isInUserBookmark
                                    ? () {
                                        context.read<BookmarkBloc>().add(
                                              BookmarkRemoveBlog(
                                                blog: widget.blog,
                                              ),
                                            );
                                      }
                                    : () {
                                        context.read<BookmarkBloc>().add(
                                              BookmarkAddBlog(
                                                blog: widget.blog,
                                              ),
                                            );
                                      },
                                child: isInUserBookmark
                                    ? Assets.icons.closeSquare.svg(
                                        color: AppPalette.purple700Color,
                                        height: 28,
                                      )
                                    : Assets.icons.bookmark.svg(
                                        color: AppPalette.purple700Color,
                                        height: 24,
                                      ),
                              );
                            },
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
