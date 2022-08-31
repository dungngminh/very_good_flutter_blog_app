import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shimmer/shimmer.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/bookmark/book_mark.dart';
import 'package:very_good_blog_app/widgets/blog_card_placeholder.dart';
import 'package:very_good_blog_app/widgets/widgets.dart';

class BookmarkView extends StatelessWidget {
  const BookmarkView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: context.padding.top + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Danh sách bài viết đã lưu',
                    style: AppTextTheme.darkW700TextStyle,
                  ),
                  Builder(
                    builder: (context) {
                      final getBookmarkStatus = context.select(
                        (BookmarkBloc bookmarkBloc) =>
                            bookmarkBloc.state.getBookmarkStatus,
                      );
                      return RotateIconButton(
                        icon: Assets.icons.refresh
                            .svg(height: 26, color: AppPalette.primaryColor),
                        onPressed: () => context
                            .read<BookmarkBloc>()
                            .add(BookmarkFetching()),
                        isLoading:
                            getBookmarkStatus == LoadingStatus.loading,
                      );
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Builder(
              builder: (context) {
                final bookmarkStatus = context.select(
                  (BookmarkBloc bookmarkBloc) =>
                      bookmarkBloc.state.getBookmarkStatus,
                );
                final messageError = context.select(
                  (BookmarkBloc bookmarkBloc) =>
                      bookmarkBloc.state.messageError,
                );
                if (bookmarkStatus == LoadingStatus.loading) {
                  return const _BookmarkPlaceholder();
                } else if (bookmarkStatus == LoadingStatus.error) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        messageError,
                      ),
                    ),
                  );
                } else {
                  return const _BookmarkList();
                }
              },
            ),

            // _BookmarkList(),
          ],
        ),
      ),
    );
  }
}

class _BookmarkList extends StatelessWidget {
  const _BookmarkList();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final bookmarks = context.watch<BookmarkBloc>().state.bookmarks;
        return bookmarks.isEmpty
            ? const Expanded(
                child: Center(
                  child: Text(
                    'Bạn không có bài viết nào đã lưu',
                  ),
                ),
              )
            : Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(
                    bottom: 36,
                    // left: 24,
                    // right: 24,
                  ),
                  itemCount: bookmarks.length,
                  itemBuilder: (context, index) {
                    final blog = bookmarks[index];
                    return Slidable(
                      endActionPane: const ActionPane(
                        motion: ScrollMotion(),
                        children: [],
                      ),
                      child: BlogCard(
                        needMargin: true,
                        blog: blog,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 16,
                    );
                  },
                ),
              );
      },
    );
  }
}

class _BookmarkPlaceholder extends StatelessWidget {
  const _BookmarkPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Shimmer.fromColors(
        baseColor: AppPalette.shimmerBaseColor,
        highlightColor: AppPalette.shimmerHighlightColor,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(
            bottom: 36,
            // left: 24,
            // right: 24,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return const BlogCardPlaceholder(
              needMargin: true,
            );
          },
        ),
      ),
    );
  }
}
