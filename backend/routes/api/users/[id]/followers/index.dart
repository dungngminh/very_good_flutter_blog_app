import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';
import 'package:very_good_blog_app_backend/dtos/response/base_response_data.dart';
import 'package:very_good_blog_app_backend/dtos/response/users/followers/get_user_profile_response.dart';
import 'package:very_good_blog_app_backend/models/following_follower.dart';
import 'package:very_good_blog_app_backend/models/user.dart';

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
) async {
  final database = context.read<Database>();

  return database.followingFollowers
      .queryFollowingFollowers(
        QueryParams(
          where: 'follower_id = @id',
          values: {'id': id},
        ),
      )
      .then(
        (followingFollowerViews) async {
          final followers = <UserView>[];
          for (final view in followingFollowerViews) {
            final follower = await database.users.queryUser(view.followerId);
            if (follower == null) continue;
            followers.add(follower);
          }
          return followers;
        },
      )
      .then((followers) => followers.map(GetUserFollowerResponse.fromView))
      .then<Response>((res) => OkResponse(res.map((e) => e.toJson()).toList()))
      .onError((e, _) => InternalServerErrorResponse(e.toString()))
      .whenComplete(database.close);
}
