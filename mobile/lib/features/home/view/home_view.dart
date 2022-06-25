import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/features/blog/blog.dart';
import 'package:very_good_blog_app/features/home/widget/widget.dart';
import 'package:very_good_blog_app/features/profile/profile.dart';
import 'package:very_good_blog_app/widgets/blog_card_placeholder.dart';
import 'package:very_good_blog_app/widgets/widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlogBloc, BlogState>(
      listener: (context, state) {
        if (state.getBlogStatus == GetBlogStatus.error) {
          Fluttertoast.cancel();
          Fluttertoast.showToast(msg: 'Cập nhất thất bại, hãy thử lại!');
        }
      },
      child: TapHideKeyboard(
        child: Scaffold(
          body: RefreshIndicator(
            color: AppPalette.primaryColor,
            onRefresh: () async =>
                context.read<BlogBloc>().add(const BlogGetBlogs()),
            child: SingleChildScrollView(
              primary: true,
              padding: EdgeInsets.only(top: context.padding.top + 16),
              child: Column(
                children: [
                  const _Header(),
                  const _SearchField(),
                  Builder(
                    builder: (context) {
                      final currentCategory = context.select(
                        (BlogBloc blogBloc) => blogBloc.state.category,
                      );
                      final isSearching = context.select(
                        (BlogBloc blogBloc) => blogBloc.state.isSearching,
                      );
                      if (currentCategory == 'Tất cả' && isSearching == false) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const _CategoryChoiceBar(),
                            _buildHeadTitle('Phổ biến'),
                            const _PopularBlogList(),
                            _buildHeadTitle('Tất cả bài viết'),
                            const _MoreBlogList(),
                          ],
                        );
                      } else if (currentCategory != 'Tất cả' &&
                          isSearching == false) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const _CategoryChoiceBar(),
                            _buildHeadTitle('Bài viết về $currentCategory'),
                            const _MoreBlogList(),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildHeadTitle(
                              'Kết quả tìm kiếm',
                              padding: const EdgeInsets.fromLTRB(24, 8, 0, 16),
                            ),
                            const _MoreBlogList(),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeadTitle(
    String title, {
    EdgeInsets padding = const EdgeInsets.fromLTRB(24, 32, 0, 16),
  }) {
    return Padding(
      padding: padding,
      child: Text(
        title,
        style: AppTextTheme.mediumTextStyle.copyWith(fontSize: 18),
      ),
    );
  }
}

class _MoreBlogList extends StatelessWidget {
  const _MoreBlogList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogBloc, BlogState>(
      buildWhen: (previous, current) =>
          previous.getBlogStatus != current.getBlogStatus,
      builder: (context, state) {
        if (state.getBlogStatus == GetBlogStatus.loading) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListView.builder(
              primary: false,
              shrinkWrap: true,
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
          );
        } else if (state.getBlogStatus == GetBlogStatus.error) {
          return Center(
            child: Text(state.errorMessage),
          );
        }
        return state.filterBlogs.isEmpty
            ? const Center(
                child: Text('Không có bài viết nào'),
              )
            : ListView.separated(
                padding: const EdgeInsets.only(
                  bottom: 36,
                ),
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final blog = state.filterBlogs[index];
                  return BlogCard(
                    needMargin: true,
                    blog: blog,
                  );
                },
                itemCount: state.filterBlogs.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 16,
                  );
                },
              );
      },
    );
  }
}

class _PopularBlogList extends StatelessWidget {
  const _PopularBlogList();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * 0.35,
      child: BlocBuilder<BlogBloc, BlogState>(
        buildWhen: (previous, current) =>
            previous.filterBlogs != current.filterBlogs,
        builder: (context, state) {
          if (state.getBlogStatus == GetBlogStatus.loading) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return const ShimmerPopularBlogCard();
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  width: 16,
                );
              },
            );
          } else if (state.getBlogStatus == GetBlogStatus.error) {
            return Center(
              child: Text(state.errorMessage),
            );
          }
          return state.filterBlogs.isEmpty
              ? const Center(
                  child: Text('Không có bài viết nào'),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.filterBlogs.length,
                  itemBuilder: (context, index) {
                    final blog = state.filterBlogs.elementAt(index);

                    return PopularBlogCard(
                      blog: blog,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 16,
                    );
                  },
                );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.screenHeight * 0.07,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Builder(
                  builder: (context) {
                    final lastName = context.select(
                          (ProfileBloc profileBloc) =>
                              profileBloc.state.user?.lastName,
                        ) ??
                        'bạn';
                    return Text(
                      'Xin chào, $lastName',
                      style: AppTextTheme.lightTextStyle.copyWith(fontSize: 15),
                    );
                  },
                ),
              ),
              const Expanded(
                flex: 3,
                child: Text(
                  'Chào mừng bạn!',
                  style: AppTextTheme.titleTextStyle,
                ),
              )
            ],
          ),
          GestureDetector(
            onTap: () => context.read<BlogBloc>().add(const BlogGetBlogs()),
            child: Builder(
              builder: (context) {
                final avatarUrl = context.select(
                  (ProfileBloc profileBloc) =>
                      profileBloc.state.user?.avatarUrl,
                );
                return CircleAvatar(
                  radius: 24,
                  backgroundImage: avatarUrl == null || avatarUrl.isEmpty
                      ? Assets.images.blankAvatar.image().image
                      : NetworkImage(avatarUrl),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChoiceBar extends StatelessWidget {
  const _CategoryChoiceBar();

  @override
  Widget build(BuildContext context) {
    final categories = <String>[
      'Tất cả',
      'Đời sống',
      'Khoa học',
      'Du lịch',
      'Ẩm thực'
    ];
    return SizedBox(
      height: context.screenHeight * 0.06,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Builder(
            builder: (context) {
              final currentCategory = context
                  .select((BlogBloc blogBloc) => blogBloc.state.category);
              return GestureDetector(
                onTap: currentCategory != category
                    ? () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        context
                            .read<BlogBloc>()
                            .add(BlogCategoryPressed(catagory: category));
                      }
                    : null,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  decoration: BoxDecoration(
                    color: currentCategory == category
                        ? Theme.of(context).primaryColor
                        : AppPalette.fieldColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 16,
                      color: currentCategory == category
                          ? AppPalette.whiteBackgroundColor
                          : AppPalette.unSelectedTextChipColor,
                    ),
                  ),
                ),
              );
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            width: 16,
          );
        },
        itemCount: categories.length,
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      height: context.screenHeight * 0.07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppPalette.fieldColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            PhosphorIcons.magnifyingGlassFill,
            color: AppPalette.primaryColor,
            size: 26,
          ),
          hintText: 'Tìm kiếm',
          contentPadding: EdgeInsets.only(right: 16),
        ),
        onChanged: (value) => EasyDebounce.debounce(
          'searching',
          const Duration(milliseconds: 750),
          () => context.read<BlogBloc>().add(BlogSearchChanged(value: value)),
        ),
        style: AppTextTheme.regularTextStyle.copyWith(fontSize: 16),
      ),
    );
  }
}
