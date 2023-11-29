import 'package:dart_frog/dart_frog.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stormberry/stormberry.dart';
import 'package:uuid/uuid.dart';
import 'package:very_good_blog_app_backend/common/extensions/json_ext.dart';
import 'package:very_good_blog_app_backend/dtos/request/blogs/create_blog_request.dart';
import 'package:very_good_blog_app_backend/dtos/response/base_pagination_response.dart';
import 'package:very_good_blog_app_backend/dtos/response/base_response_data.dart';
import 'package:very_good_blog_app_backend/dtos/response/blogs/get_blog_response.dart';
import 'package:very_good_blog_app_backend/models/blog.dart';
import 'package:very_good_blog_app_backend/models/user.dart';

/// @Allow(GET, POST)
/// @Query(limit)
/// @Query(page)
Future<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.get => _onBlogsGetRequest(context),
    HttpMethod.post => _onBlogsPostRequest(context),
    _ => Future.value(MethodNotAllowedResponse()),
  };
}

Future<Response> _onBlogsGetRequest(RequestContext context) async {
  final db = context.read<Database>();
  final queryParams = context.request.uri.queryParameters;
  final limit = int.tryParse(queryParams['limit'] ?? '') ?? 20;
  final currentPage = int.tryParse(queryParams['page'] ?? '') ?? 1;

  try {
    final results = await db.blogs.queryBlogs(
      QueryParams(
        limit: limit,
        offset: (currentPage - 1) * limit,
      ),
    );
    final blogs = results.map(GetBlogResponse.fromView);
    final pagination = BasePaginationResponse(
      currentPage: currentPage,
      limit: limit,
      totalCount: blogs.length,
    );
    return OkResponse(
      {
        'blogs': blogs.map((e) => e.toJson()).toList(),
        'pagination': pagination.toJson(),
      },
    );
  } catch (e) {
    return ServerErrorResponse(e.toString());
  }
}

Future<Response> _onBlogsPostRequest(RequestContext context) async {
  final db = context.read<Database>();
  final user = context.read<UserView>();

  final body = await context.request.body();

  if (body.isEmpty) return BadRequestResponse();
  try {
    final request = CreateBlogRequest.fromJson(body.asJson());

    await db.blogs.insertOne(
      BlogInsertRequest(
        id: const Uuid().v4(),
        title: request.title,
        category: request.category,
        content: request.content,
        imageUrl: request.imageUrl,
        createdAt: DateTime.now(),
        creatorId: user.id,
        updatedAt: DateTime.now(),
        isDeleted: false,
      ),
    );
    return CreatedResponse('New blog is created');
  } on CheckedFromJsonException catch (e) {
    return BadRequestResponse(e.message);
  } catch (e) {
    return ServerErrorResponse(e.toString());
  }
}
