import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/features/blog/blog.dart';
import 'package:very_good_blog_app/features/home/home.dart';
import 'package:very_good_blog_app/features/profile/profile.dart';
import 'package:very_good_blog_app/widgets/widgets.dart'
    show BlogCard, TapHideKeyboard;

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return TapHideKeyboard(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            primary: true,
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Header(),
                const _SearchField(),
                const _CategoryChoiceBar(),
                _buildHeadTitle('Phổ biến'),
                const _PopularBlogList(),
                _buildHeadTitle('Bài viết khác'),
                const _MoreBlogList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeadTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 0, 16),
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
          return const Center(
            child: CircularProgressIndicator(
              color: AppPalette.primaryColor,
            ),
          );
        } else if (state.getBlogStatus == GetBlogStatus.error) {
          return Center(
            child: Text(state.errorMessage),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.only(
            bottom: 36,
          ),
          primary: false,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final blog = state.blogs[index];
            return BlogCard(
              needMargin: true,
              blog: blog,
            );
          },
          itemCount: state.blogs.length,
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
        buildWhen: (previous, current) => previous.blogs != current.blogs,
        builder: (context, state) {
          if (state.getBlogStatus == GetBlogStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppPalette.primaryColor,
              ),
            );
          } else if (state.getBlogStatus == GetBlogStatus.error) {
            return Center(
              child: Text(state.errorMessage),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              final blog = state.blogs.elementAt(index);
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
    final category = <String>[
      'Tất cả',
      'Kinh tế',
      'Khoa học',
      'Văn hóa',
      'Nghệ thuật'
    ];
    return SizedBox(
      height: context.screenHeight * 0.06,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            decoration: BoxDecoration(
              color: index == 0
                  ? Theme.of(context).primaryColor
                  : AppPalette.fieldColor,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(
              category[index],
              style: TextStyle(
                fontSize: 16,
                color: index == 0
                    ? AppPalette.whiteBackgroundColor
                    : AppPalette.unSelectedTextChipColor,
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            width: 16,
          );
        },
        itemCount: category.length,
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
        style: AppTextTheme.regularTextStyle.copyWith(fontSize: 16),
      ),
    );
  }
}
