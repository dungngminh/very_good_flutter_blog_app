import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';
import 'package:very_good_blog_app_backend/dtos/response/base_response_data.dart';
import 'package:very_good_blog_app_backend/dtos/response/users/followers/get_user_profile_response.dart';
import 'package:very_good_blog_app_backend/models/following_follower.dart';

/// @Allow(GET)
Future<Response> onRequest(RequestContext context, String id) {
  return switch (context.request.method) {
    HttpMethod.get => _onFollowersByIdGetRequest(context, id),
    _ => Future.value(MethodNotAllowedResponse()),
  };
}

Future<Response> _onFollowersByIdGetRequest(
  RequestContext context,
  String id,
) {
  return context
      .read<Database>()
      .followingFollowers
      .queryFollowingFollowers(
        QueryParams(
          where: 'follower_id = @id',
          values: {'id': id},
        ),
      )
      .then((result) => result.map(GetUserFollowerResponse.fromView))
      .then<Response>((res) => OkResponse(res.map((e) => e.toJson()).toList()))
      .onError((e, _) => ServerErrorResponse(e.toString()));
}
