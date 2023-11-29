import 'package:dart_frog/dart_frog.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stormberry/stormberry.dart';
import 'package:very_good_blog_app_backend/common/extensions/json_ext.dart';
import 'package:very_good_blog_app_backend/dtos/request/followings/create_following_request.dart';
import 'package:very_good_blog_app_backend/dtos/response/base_response_data.dart';
import 'package:very_good_blog_app_backend/models/following_follower.dart';
import 'package:very_good_blog_app_backend/models/user.dart';

/// @Allow(POST)
Future<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.post => _onFollowingPost(context),
    _ => Future.value(MethodNotAllowedResponse()),
  };
}

Future<Response> _onFollowingPost(RequestContext context) async {
  final userView = context.read<UserView>();
  final db = context.read<Database>();

  final body = await context.request.body();

  if (body.isEmpty) {
    return BadRequestResponse();
  }

  try {
    final request = CreateFollowingRequest.fromJson(body.asJson());
    if (request.userId == userView.id) {
      return BadRequestResponse('You cannot follow yourself');
    }
    final existFollowing = (await db.followingFollowers.queryFollowingFollowers(
      QueryParams(
        where: 'following_id=@followingId AND follower_id=@followerId',
        values: {
          'followingId': request.userId,
          'followerId': userView.id,
        },
      ),
    ))
        .firstOrNull;
    if (existFollowing != null) {
      return db
          .query(
            'DELETE FROM following_followers '
            'WHERE following_id=@followingId AND follower_id=@followerId',
            {'followingId': userView.id, 'userId': userView.id},
          )
          .then<Response>((_) => OkResponse())
          .onError((e, _) => ServerErrorResponse(e.toString()));
    }
    return db.followingFollowers
        .insertOne(
          FollowingFollowerInsertRequest(
            followerId: userView.id,
            followingId: request.userId,
          ),
        )
        .then<Response>((_) => OkResponse())
        .onError((e, _) => ServerErrorResponse(e.toString()));
  } on CheckedFromJsonException catch (e) {
    return BadRequestResponse(e.message);
  } catch (e) {
    return ServerErrorResponse(e.toString());
  }
}
