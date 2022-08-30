import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:very_good_blog_app/blog/blog.dart';
import 'package:very_good_blog_app/blog/view/blog_view_offline.dart';
import 'package:very_good_blog_app/blog_editor/blog_editor.dart';
import 'package:very_good_blog_app/bookmark/book_mark.dart';
import 'package:very_good_blog_app/login/login.dart';
import 'package:very_good_blog_app/main/main.dart';
import 'package:very_good_blog_app/profile/profile.dart';
import 'package:very_good_blog_app/register/register.dart';
import 'package:very_good_blog_app/setting/setting.dart';
import 'package:very_good_blog_app/splash/splash.dart';

class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const login = '/login';
  static const register = '/register';
  static const setting = '/setting';
  static const editProfile = 'edit-profile';
  static const blogEditor = '/editor';
  static const blog = '/blog';
  static const bookmarkOffline = '/bookmark-off';
  static const uploadBlog = 'upload';
  static const previewBlog = 'preview';
  static const offlineBlog = 'blog-off';

  static final route = GoRouter(
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) {
          return const SplashView();
        },
      ),
      GoRoute(
        path: home,
        builder: (context, state) {
          return const MainView();
        },
      ),
      GoRoute(
        path: login,
        builder: (context, state) {
          return const LoginView();
        },
      ),
      GoRoute(
        path: register,
        builder: (context, state) {
          return const RegisterView();
        },
      ),
      GoRoute(
        path: bookmarkOffline,
        builder: (context, state) {
          return const BookmarkPageOffline();
        },
        routes: [
          GoRoute(
            path: offlineBlog,
            builder: (context, state) {
              final blog = state.extra as BlogModel?;
              return BlogViewOffline(
                blog: blog!,
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: setting,
        builder: (context, state) {
          final profileBloc = state.extra! as ProfileBloc;
          return BlocProvider.value(
            value: profileBloc,
            child: const SettingView(),
          );
        },
        routes: [
          GoRoute(
            path: editProfile,
            builder: (context, state) {
              final extras = state.extra! as ProfileBloc;
              return BlocProvider.value(
                value: extras,
                child: const EditProfilePage(),
              );
            },
          )
        ],
      ),
      GoRoute(
        path: blogEditor,
        builder: (context, state) {
          final extras =
              state.extra! as ExtraParams3<ProfileBloc, BlogBloc, BlogModel?>;
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: extras.param1,
              ),
              BlocProvider.value(
                value: extras.param2,
              ),
            ],
            child: BlogEditorPage(
              blog: extras.param3,
            ),
          );
        },
        routes: [
          GoRoute(
            path: uploadBlog,
            builder: (context, state) {
              final extras = state.extra! as ExtraParams4<BlogEditorBloc,
                  BlogBloc, ProfileBloc, BlogModel?>;

              return MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: extras.param1,
                  ),
                  BlocProvider.value(
                    value: extras.param2,
                  ),
                  BlocProvider.value(
                    value: extras.param3,
                  ),
                ],
                child: const UploadBlogView(),
              );
            },
            routes: [
              GoRoute(
                path: previewBlog,
                builder: (context, state) {
                  final blog = state.extra! as BlogModel;

                  return BlogPreviewView(
                    blog: blog,
                  );
                },
              )
            ],
          ),
        ],
      ),
      GoRoute(
        path: blog,
        builder: (context, state) {
          final extras = state.extra!
              as ExtraParams4<BlogModel, ProfileBloc, BlogBloc, BookmarkBloc>;
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: extras.param2,
              ),
              BlocProvider.value(
                value: extras.param3,
              ),
              BlocProvider.value(
                value: extras.param4,
              ),
            ],
            child: BlogView(
              blog: extras.param1,
            ),
          );
        },
      )
    ],
    // initialLocation: home,
    debugLogDiagnostics: true,
    urlPathStrategy: UrlPathStrategy.path,
  );
}

class ExtraParams2<T, S> {
  ExtraParams2({required this.param1, required this.param2});

  final T param1;
  final S param2;
}

class ExtraParams3<A, B, C> {
  ExtraParams3({
    required this.param1,
    required this.param2,
    required this.param3,
  });

  final A param1;
  final B param2;
  final C param3;
}

class ExtraParams4<A, B, C, D> {
  ExtraParams4({
    required this.param1,
    required this.param2,
    required this.param3,
    required this.param4,
  });

  final A param1;
  final B param2;
  final C param3;
  final D param4;
}
