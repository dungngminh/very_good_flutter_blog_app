import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_blog_app/features/blog/blog.dart'
    show BlogBloc, BlogView;
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
import 'package:very_good_blog_app/features/setting/view/edit_profile_page.dart';
import 'package:very_good_blog_app/features/splash/splash.dart' show SplashView;
import 'package:very_good_blog_app/models/models.dart' show BlogModel;

class AppRoute {
  static const splash = '/';
  static const home = '/home';
  static const login = '/login';
  static const register = '/register';
  static const setting = '/setting';
  static const editProfile = 'edit-profile';
  static const blogEditor = '/editor';
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
              final extras = state.extra!
                  as ExtraParams3<BlogEditorBloc, BlogBloc, ProfileBloc>;

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
          )
        ],
      ),
      GoRoute(
        path: blog,
        builder: (context, state) {
          final extras =
              state.extra! as ExtraParams3<BlogModel, ProfileBloc, BlogBloc>;
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: extras.param2,
              ),
              BlocProvider.value(
                value: extras.param3,
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
