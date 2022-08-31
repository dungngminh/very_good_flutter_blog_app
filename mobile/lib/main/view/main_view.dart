import 'package:authentication_repository/authentication_repository.dart';
import 'package:blog_repository/blog_repository.dart';
import 'package:bookmark_repository/bookmark_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/authentication/authentication.dart';
import 'package:very_good_blog_app/blog/blog.dart';
import 'package:very_good_blog_app/bookmark/book_mark.dart';
import 'package:very_good_blog_app/home/home.dart';
import 'package:very_good_blog_app/notification/notification.dart';
import 'package:very_good_blog_app/profile/profile.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late ValueNotifier<int> _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = ValueNotifier(0);
  }

  @override
  Widget build(BuildContext context) {
    final isKeyBoardShowing = MediaQuery.of(context).viewInsets.bottom != 0;
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.status == AuthenticationStatus.unauthenticated) {
          context.go(AppRoutes.login);
        } else if (state.status == AuthenticationStatus.authenticatedOffline) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Builder(
                  builder: (context) {
                    return const Text(
                      'Hiện tại bạn đã offline, '
                      'nhưng bạn có thể xem những blog đã lưu',
                    );
                  },
                ),
              ),
            );
        }
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<BlogBloc>(
            create: (context) => BlogBloc(
              blogRepository: context.read<BlogRepository>(),
            ),
          ),
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(
              authenticationRepository:
                  context.read<AuthenticationRepository>(),
              userRepository: context.read<UserRepository>(),
              blogRepository: context.read<BlogRepository>(),
            ),
          ),
          BlocProvider<BookmarkBloc>(
            create: (context) => BookmarkBloc(
              bookmarkRepository: context.read<BookmarkRepository>(),
            ),
          ),
        ],
        child: Scaffold(
          body: ValueListenableBuilder<int>(
            valueListenable: _currentIndex,
            builder: (context, value, child) {
              return LazyLoadIndexedStack(
                index: value,
                children: const [
                  HomeView(),
                  NotificationView(),
                  BookmarkView(),
                  ProfileView(),
                ],
              );
            },
          ),
          floatingActionButton: Visibility(
            visible: !isKeyBoardShowing,
            child: SizedBox.square(
              dimension: 65,
              child: Builder(
                builder: (context) {
                  return FloatingActionButton(
                    onPressed: () => context.push(
                      AppRoutes.blogEditor,
                      extra: ExtraParams3<ProfileBloc, BlogBloc, BlogModel?>(
                        param1: context.read<ProfileBloc>(),
                        param2: context.read<BlogBloc>(),
                        param3: null,
                      ),
                    ),
                    backgroundColor: AppPalette.primaryColor,
                    shape: const CircleBorder(),
                    child: Assets.icons.plus.svg(
                      color: AppPalette.whiteBackgroundColor,
                      height: 24,
                    ),
                  );
                },
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            color: AppPalette.whiteBackgroundColor,
            clipBehavior: Clip.hardEdge,
            shape: const CircularNotchedRectangle(),
            child: SizedBox(
              height: 70,
              child: Row(
                children: [
                  _buildBottomBarItem(index: 0, icon: Assets.icons.home),
                  _buildBottomBarItem(index: 1, icon: Assets.icons.bell),
                  const Spacer(),
                  _buildBottomBarItem(index: 2, icon: Assets.icons.bookmark),
                  _buildBottomBarItem(index: 3, icon: Assets.icons.user),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildBottomBarItem({
    required int index,
    required SvgGenImage icon,
  }) {
    return Expanded(
      flex: 2,
      child: IconButton(
        icon: ValueListenableBuilder<int>(
          valueListenable: _currentIndex,
          builder: (context, value, child) {
            return icon.svg(
              color: value == index
                  ? AppPalette.primaryColor
                  : AppPalette.unSelectedColor,
              height: value == index ? 28 : 26,
            );
          },
        ),
        onPressed: () => _currentIndex.value = index,
      ),
    );
  }
}
