import 'package:json_annotation/json_annotation.dart';

part 'create_following_request.g.dart';

@JsonSerializable()
class CreateFollowingRequest {
  const CreateFollowingRequest({required this.userId});

  factory CreateFollowingRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateFollowingRequestFromJson(json);
  final String userId;

  Map<String, dynamic> toJson() => _$CreateFollowingRequestToJson(this);
}
