import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_blog_app/features/blog/blog.dart' show BlogView;
import 'package:very_good_blog_app/features/blog_editor/blog_editor.dart'
    show BlogEditorPage, UploadBlogView, BlogEditorBloc;
import 'package:very_good_blog_app/features/login/login.dart' show LoginView;
import 'package:very_good_blog_app/features/main/main.dart' show MainView;
import 'package:very_good_blog_app/features/profile/profile.dart'
    show ProfileBloc;
import 'package:very_good_blog_app/features/register/register.dart'
    show RegisterView;
import 'package:very_good_blog_app/features/setting/setting.dart'
    show SettingView;
import 'package:very_good_blog_app/features/splash/splash.dart' show SplashView;
import 'package:very_good_blog_app/models/models.dart' show Blog;

class AppRoute {
  static const splash = '/';
  static const home = '/home';
  static const login = '/login';
  static const register = '/register';
  static const setting = '/setting';
  static const addBlog = '/addBlog';
  static const blog = '/blog';
  static const uploadBlog = 'upload';

  static final route = GoRouter(
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) {
          return const MainView();
        },
      ),
      GoRoute(
        path: splash,
        builder: (context, state) {
          return const SplashView();
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
        path: setting,
        builder: (context, state) {
          final profileBloc = state.extra! as ProfileBloc;
          return BlocProvider.value(
            value: profileBloc,
            child: const SettingView(),
          );
        },
      ),
      GoRoute(
        path: addBlog,
        builder: (context, state) {
          return const BlogEditorPage();
        },
        routes: [
          GoRoute(
            path: uploadBlog,
            builder: (context, state) {
              final addBlogBloc = state.extra! as BlogEditorBloc;
              return BlocProvider.value(
                value: addBlogBloc,
                child: const UploadBlogView(),
              );
            },
          )
        ],
      ),
      GoRoute(
        path: blog,
        builder: (context, state) {
          final blog = state.extra! as Blog;
          return BlogView(blog: blog);
        },
      )
    ],
    // initialLocation: home,
    debugLogDiagnostics: true,
    urlPathStrategy: UrlPathStrategy.path,
  );
}
