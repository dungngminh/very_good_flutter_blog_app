import 'package:dart_frog/dart_frog.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stormberry/stormberry.dart';
import 'package:very_good_blog_app_backend/common/extensions/header_extesion.dart';
import 'package:very_good_blog_app_backend/common/extensions/json_ext.dart';
import 'package:very_good_blog_app_backend/dtos/request/blogs/edit_blog_request.dart';
import 'package:very_good_blog_app_backend/dtos/response/base_response_data.dart';
import 'package:very_good_blog_app_backend/dtos/response/blogs/get_blog_response.dart';
import 'package:very_good_blog_app_backend/models/blog.dart';
import 'package:very_good_blog_app_backend/models/favorite_blogs_users.dart';
import 'package:very_good_blog_app_backend/models/user.dart';
import 'package:very_good_blog_app_backend/util/jwt_handler.dart';

/// @Allow(GET, PATCH, DELETE)
Future<Response> onRequest(RequestContext context, String id) {
  return switch (context.request.method) {
    HttpMethod.get => _onBlogsGetRequest(context, id),
    HttpMethod.patch => _onBlogsPatchRequest(context, id),
    HttpMethod.delete => _onBlogsDeleteRequest(context, id),
    _ => Future.value(MethodNotAllowedResponse()),
  };
}

Future<Response> _onBlogsGetRequest(RequestContext context, String id) async {
  final db = context.read<Database>();
  UserView? user;
  final bearerToken = context.request.headers.bearer();
  if (bearerToken != null) {
    final jwtHandler = context.read<JwtHandler>();
    user = await jwtHandler.userFromToken(bearerToken);
  }
  try {
    final blog = await db.blogs.queryBlog(id);
    if (blog == null) return NotFoundResponse('Blog not found');
    bool? isFavoritedByUser;
    if (user != null) {
      final foundBlog =
          (await db.favoriteBlogsUserses.queryFavoriteBlogsUserses(
        QueryParams(
          where: 'blog_id=@blogId and user_id=@userId',
          values: {
            'blogId': id,
            'userId': user.id,
          },
        ),
      ))
              .firstOrNull;
      isFavoritedByUser = foundBlog != null;
    }
    return OkResponse(
      GetBlogResponse.fromView(blog, isFavoritedByUser: isFavoritedByUser)
          .toJson(),
    );
  } catch (e) {
    return ServerErrorResponse(e.toString());
  }
}

Future<Response> _onBlogsPatchRequest(RequestContext context, String id) async {
  final db = context.read<Database>();
  final user = context.read<UserView>();
  try {
    final body = await context.request.body();
    if (body.isEmpty) return BadRequestResponse();
    final request = EditBlogRequest.fromJson(body.asJson());
    final blog = await db.blogs.queryBlog(id);
    if (blog == null) return NotFoundResponse('Blog not found');
    if (blog.creator.id != user.id) {
      return ForbiddenResponse('You are not creator of this blog');
    }
    await db.blogs.updateOne(
      BlogUpdateRequest(
        id: id,
        title: request.title,
        content: request.content,
        imageUrl: request.imageUrl,
        category: request.category,
        updatedAt: DateTime.now(),
      ),
    );
    return OkResponse();
  } on CheckedFromJsonException catch (e) {
    return BadRequestResponse(e.message);
  } catch (e) {
    return ServerErrorResponse(e.toString());
  }
}

Future<Response> _onBlogsDeleteRequest(
  RequestContext context,
  String id,
) async {
  final db = context.read<Database>();
  final user = context.read<UserView>();
  try {
    final blog = await db.blogs.queryBlog(id);
    if (blog == null) return NotFoundResponse('Blog not found');
    if (blog.creator.id != user.id) {
      return ForbiddenResponse('You are not creator of this blog');
    }
    await db.blogs.deleteOne(id);
    return OkResponse();
  } catch (e) {
    return ServerErrorResponse(e.toString());
  }
}
