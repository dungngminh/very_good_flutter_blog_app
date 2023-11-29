import 'package:json_annotation/json_annotation.dart';
import 'package:very_good_blog_app_backend/models/following_follower.dart';

part 'get_user_profile_response.g.dart';

@JsonSerializable()
class GetUserFollowerResponse {
  GetUserFollowerResponse({
    required this.id,
    required this.fullName,
    required this.email,
    this.avatarUrl,
  });

  factory GetUserFollowerResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserFollowerResponseFromJson(json);

  factory GetUserFollowerResponse.fromView(FollowingFollowerView view) {
    return GetUserFollowerResponse(
      id: view.follower.id,
      fullName: view.follower.fullName,
      email: view.follower.email,
      avatarUrl: view.follower.avatarUrl,
    );
  }

  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;

  Map<String, dynamic> toJson() => _$GetUserFollowerResponseToJson(this);
}
