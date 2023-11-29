import 'package:json_annotation/json_annotation.dart';
import 'package:very_good_blog_app_backend/models/following_follower.dart';

part 'get_user_following_response.g.dart';

@JsonSerializable()
class GetUserFollowingResponse {
  GetUserFollowingResponse({
    required this.id,
    required this.fullName,
    required this.email,
    this.avatarUrl,
  });

  factory GetUserFollowingResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserFollowingResponseFromJson(json);

  factory GetUserFollowingResponse.fromView(FollowingFollowerView view) {
    return GetUserFollowingResponse(
      id: view.following.id,
      fullName: view.following.fullName,
      email: view.following.email,
      avatarUrl: view.following.avatarUrl,
    );
  }

  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;

  Map<String, dynamic> toJson() => _$GetUserFollowingResponseToJson(this);
}
