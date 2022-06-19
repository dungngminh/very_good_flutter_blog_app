import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/features/blog/blog.dart'
    show BlogBloc, BlogCardPressed, BlogState, ContentBlogStatus;
import 'package:very_good_blog_app/models/models.dart' show Blog;
import 'package:very_good_blog_app/widgets/widgets.dart';

class PopularBlogCard extends StatelessWidget {
  const PopularBlogCard({
    super.key,
    required this.blog,
  });

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlogBloc, BlogState>(
      listenWhen: (previous, current) {
        log((previous.blogs.indexOf(blog) + 1).toString());
        log((current.blogs.indexOf(blog) + 1).toString());

        return previous.blogs.elementAt(previous.blogs.indexOf(blog) + 1) !=
                current.blogs.elementAt(current.blogs.indexOf(blog) + 1) &&
            previous.contentBlogStatus != current.contentBlogStatus;
      },
      listener: (context, state) {
        if (state.contentBlogStatus == ContentBlogStatus.loading) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Đang lấy nội dung bài viết'),
              ),
            );
        } else if (state.contentBlogStatus == ContentBlogStatus.idle) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          final updatedBlog = state.blogs.firstWhere(
            (element) => element.id == blog.id,
          );
          context.push(AppRoute.blog, extra: updatedBlog);
        }
      },
      child: GestureDetector(
        onTap: () {
          if (blog.content == null) {
            context.read<BlogBloc>().add(
                  BlogCardPressed(blogId: blog.id),
                );
            return;
          }
          context.push(AppRoute.blog, extra: blog);
        },
        child: Container(
          width: context.screenHeight * 0.35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: DecorationImage(
              image: Image.network(
                blog.imageUrl,
              ).image,
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkEffectIconButton(
                  child: Assets.icons.bookmark.svg(
                    color: AppPalette.whiteBackgroundColor,
                    height: 24,
                  ),
                  onPressed: () {},
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: AppPalette.whiteBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: Assets.images.komkat.image().image,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                blog.user.username,
                                style: AppTextTheme.titleTextStyle
                                    .copyWith(fontSize: 14),
                              ),
                              // TODO(dungngminh): handle timeago
                              Text(
                                '20 phút trước',
                                style: AppTextTheme.regularTextStyle
                                    .copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      blog.title,
                      style: AppTextTheme.titleTextStyle.copyWith(fontSize: 15),
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
