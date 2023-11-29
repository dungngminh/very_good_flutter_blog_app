import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';
import 'package:very_good_blog_app_backend/dtos/response/base_response_data.dart';
import 'package:very_good_blog_app_backend/dtos/response/users/blogs/get_user_blog_response.dart';
import 'package:very_good_blog_app_backend/models/blog.dart';

/// @Allow(GET)
Future<Response> onRequest(RequestContext context, String id) {
  return switch (context.request.method) {
    HttpMethod.get => _onUsersByIdBlogsGet(context, id),
    _ => Future.value(MethodNotAllowedResponse()),
  };
}

Future<Response> _onUsersByIdBlogsGet(RequestContext context, String id) {
  return context
      .read<Database>()
      .blogs
      .queryBlogs(QueryParams(where: 'creator_id=@id', values: {'id': id}))
      .then((views) => views.map(GetUserBlogResponse.fromView))
      .then<Response>((res) => OkResponse(res.map((e) => e.toJson()).toList()))
      .onError((e, _) => ServerErrorResponse(e.toString()));
}
